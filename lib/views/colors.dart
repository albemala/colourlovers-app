import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/functions/routing.dart';
import 'package:colourlovers_app/views/color-details.dart';
import 'package:colourlovers_app/widgets/app-top-bar.dart';
import 'package:colourlovers_app/widgets/item-tiles.dart';
import 'package:colourlovers_app/widgets/random-item-button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@immutable
class ColorsViewModel {
  final bool isLoading;
  final List<ColorTileViewModel> colors;

  const ColorsViewModel({
    required this.isLoading,
    required this.colors,
  });

  factory ColorsViewModel.initialState() {
    return const ColorsViewModel(
      isLoading: false,
      colors: <ColorTileViewModel>[],
    );
  }
}

class ColorsViewBloc extends Cubit<ColorsViewModel> {
  factory ColorsViewBloc.fromContext(BuildContext context) {
    return ColorsViewBloc(
      ColourloversApiClient(),
    );
  }

  final ColourloversApiClient _client;
  bool _isLoading = false;
  List<ColourloversColor> _colors = <ColourloversColor>[];
  int _page = 0;

  ColorsViewBloc(
    this._client,
  ) : super(
          ColorsViewModel.initialState(),
        ) {
    load();
  }

  Future<void> load() async {
    _isLoading = true;
    _emitState();

    const numResults = 20;
    final items = await _client.getColors(
          numResults: numResults,
          resultOffset: _page * numResults,
          // orderBy: ClRequestOrderBy.numVotes,
          sortBy: ColourloversRequestSortBy.DESC,
        ) ??
        [];

    _isLoading = false;
    _colors = [
      ..._colors,
      ...items,
    ];
    _emitState();
  }

  Future<void> loadMore() async {
    _page++;
    await load();
  }

  void showColorDetails(
    BuildContext context,
    int colorIndex,
  ) {
    final color = _colors[colorIndex];
    _showColorDetails(context, color);
  }

  Future<void> openRandomColor(
    BuildContext context,
  ) async {
    final color = await _client.getRandomColor();
    if (color == null) return;
    _showColorDetails(context, color);
  }

  void _showColorDetails(
    BuildContext context,
    ColourloversColor color,
  ) {
    openRoute(context, ColorDetailsViewBuilder(color: color));
  }

  void _emitState() {
    emit(
      ColorsViewModel(
        isLoading: _isLoading,
        colors: _colors //
            .map(ColorTileViewModel.fromColourloverColor)
            .toList(),
      ),
    );
  }
}

class ColorsViewBuilder extends StatelessWidget {
  const ColorsViewBuilder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ColorsViewBloc>(
      create: ColorsViewBloc.fromContext,
      child: BlocBuilder<ColorsViewBloc, ColorsViewModel>(
        builder: (context, viewModel) {
          return ColorsView(
            viewModel: viewModel,
            bloc: context.read<ColorsViewBloc>(),
          );
        },
      ),
    );
  }
}

class ColorsView extends StatelessWidget {
  final ColorsViewModel viewModel;
  final ColorsViewBloc bloc;

  const ColorsView({
    super.key,
    required this.viewModel,
    required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      appBar: AppTopBarView(
        context,
        title: 'Colors',
        actions: [
          RandomItemButton(
            onPressed: () {
              bloc.openRandomColor(context);
            },
            tooltip: 'Random color',
          ),
          // _FilterButton(
          //   onPressed: () {
          //     // TODO
          //   },
          // ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        // controller: scrollController,
        itemCount: viewModel.colors.length + 1,
        itemBuilder: (context, index) {
          if (index == viewModel.colors.length) {
            if (viewModel.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              // TODO dont show if no more items
              return OutlinedButton(
                onPressed: bloc.loadMore,
                child: const Text('Load more'),
              );
            }
          } else {
            final color = viewModel.colors[index];
            return ColorTileView(
              viewModel: color,
              onTap: () {
                bloc.showColorDetails(context, index);
              },
            );
          }
        },
        separatorBuilder: (context, index) {
          return const SizedBox(height: 12);
        },
      ),
    );
  }
}
