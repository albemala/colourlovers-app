import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/functions/routing.dart';
import 'package:colourlovers_app/views/palette-details.dart';
import 'package:colourlovers_app/widgets/app-top-bar.dart';
import 'package:colourlovers_app/widgets/item-tiles.dart';
import 'package:colourlovers_app/widgets/random-item-button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@immutable
class PalettesViewModel {
  final bool isLoading;
  final List<PaletteTileViewModel> palettes;

  const PalettesViewModel({
    required this.isLoading,
    required this.palettes,
  });

  factory PalettesViewModel.initialState() {
    return const PalettesViewModel(
      isLoading: false,
      palettes: <PaletteTileViewModel>[],
    );
  }
}

class PalettesViewBloc extends Cubit<PalettesViewModel> {
  factory PalettesViewBloc.fromContext(BuildContext context) {
    return PalettesViewBloc(
      ColourloversApiClient(),
    );
  }

  final ColourloversApiClient _client;
  bool _isLoading = false;
  List<ColourloversPalette> _palettes = <ColourloversPalette>[];
  int _page = 0;

  PalettesViewBloc(
    this._client,
  ) : super(
          PalettesViewModel.initialState(),
        ) {
    load();
  }

  Future<void> load() async {
    _isLoading = true;
    _emitState();

    const numResults = 20;
    final items = await _client.getPalettes(
          numResults: numResults,
          resultOffset: _page * numResults,
          // orderBy: ClRequestOrderBy.numVotes,
          sortBy: ColourloversRequestSortBy.DESC,
          showPaletteWidths: true,
        ) ??
        [];

    _isLoading = false;
    _palettes = [
      ..._palettes,
      ...items,
    ];
    _emitState();
  }

  Future<void> loadMore() async {
    _page++;
    await load();
  }

  void showPaletteDetails(
    BuildContext context,
    int paletteIndex,
  ) {
    final palette = _palettes[paletteIndex];
    _showPaletteDetails(context, palette);
  }

  Future<void> showRandomPalette(
    BuildContext context,
  ) async {
    final palette = await _client.getRandomPalette();
    if (palette == null) return;
    _showPaletteDetails(context, palette);
  }

  void _showPaletteDetails(
    BuildContext context,
    ColourloversPalette palette,
  ) {
    openRoute(context, PaletteDetailsViewBuilder(palette: palette));
  }

  void _emitState() {
    emit(
      PalettesViewModel(
        isLoading: _isLoading,
        palettes: _palettes //
            .map(PaletteTileViewModel.fromColourloverPalette)
            .toList(),
      ),
    );
  }
}

class PalettesViewBuilder extends StatelessWidget {
  const PalettesViewBuilder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PalettesViewBloc>(
      create: PalettesViewBloc.fromContext,
      child: BlocBuilder<PalettesViewBloc, PalettesViewModel>(
        builder: (context, viewModel) {
          return PalettesView(
            viewModel: viewModel,
            bloc: context.read<PalettesViewBloc>(),
          );
        },
      ),
    );
  }
}

class PalettesView extends StatelessWidget {
  final PalettesViewModel viewModel;
  final PalettesViewBloc bloc;

  const PalettesView({
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
        title: 'Palettes',
        actions: [
          RandomItemButton(
            onPressed: () {
              bloc.showRandomPalette(context);
            },
            tooltip: 'Random palette',
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
        itemCount: viewModel.palettes.length + 1,
        itemBuilder: (context, index) {
          if (index == viewModel.palettes.length) {
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
            final palette = viewModel.palettes[index];
            return PaletteTileView(
              viewModel: palette,
              onTap: () {
                bloc.showPaletteDetails(context, index);
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
