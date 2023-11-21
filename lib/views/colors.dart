import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/functions/routing.dart';
import 'package:colourlovers_app/views/color-details.dart';
import 'package:colourlovers_app/widgets/app-top-bar.dart';
import 'package:colourlovers_app/widgets/item-tiles.dart';
import 'package:colourlovers_app/widgets/items-list.dart';
import 'package:colourlovers_app/widgets/random-item-button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ColorsViewBloc extends Cubit<ItemsListViewModel<ColorTileViewModel>> {
  factory ColorsViewBloc.fromContext(BuildContext context) {
    return ColorsViewBloc(
      ColourloversApiClient(),
    );
  }

  final ColourloversApiClient _client;
  late final ItemsPagination<ColourloversColor> _pagination;

  ColorsViewBloc(
    this._client,
  ) : super(
          ItemsListViewModel.initialState(),
        ) {
    _pagination = ItemsPagination<ColourloversColor>((numResults, offset) {
      return _client.getColors(
        numResults: numResults,
        resultOffset: offset,
        // orderBy: ClRequestOrderBy.numVotes,
        sortBy: ColourloversRequestSortBy.DESC,
      );
    });
    _pagination.addListener(_updateState);
    _pagination.load();
  }

  @override
  Future<void> close() {
    _pagination.removeListener(_updateState);
    return super.close();
  }

  Future<void> loadMore() async {
    await _pagination.loadMore();
  }

  void showColorDetails(
    BuildContext context,
    ColorTileViewModel viewModel,
  ) {
    final viewModelIndex = state.items.indexOf(viewModel);
    final color = _pagination.items[viewModelIndex];
    _showColorDetails(context, color);
  }

  Future<void> showRandomColor(
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

  void _updateState() {
    emit(
      ItemsListViewModel(
        isLoading: _pagination.isLoading,
        items: _pagination.items //
            .map(ColorTileViewModel.fromColourloverColor)
            .toList(),
        hasMoreItems: _pagination.hasMoreItems,
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
      child:
          BlocBuilder<ColorsViewBloc, ItemsListViewModel<ColorTileViewModel>>(
        builder: (context, viewModel) {
          return ColorsView(
            listViewModel: viewModel,
            bloc: context.read<ColorsViewBloc>(),
          );
        },
      ),
    );
  }
}

class ColorsView extends StatelessWidget {
  final ItemsListViewModel<ColorTileViewModel> listViewModel;
  final ColorsViewBloc bloc;

  const ColorsView({
    super.key,
    required this.listViewModel,
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
              bloc.showRandomColor(context);
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
      body: ItemsListView(
        viewModel: listViewModel,
        itemTileBuilder: (itemViewModel) {
          return ColorTileView(
            viewModel: itemViewModel,
            onTap: () {
              bloc.showColorDetails(context, itemViewModel);
            },
          );
        },
        onLoadMorePressed: bloc.loadMore,
      ),
    );
  }
}
