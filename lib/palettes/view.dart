import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/app/routing.dart';
import 'package:colourlovers_app/palette-details/view.dart';
import 'package:colourlovers_app/widgets/app-top-bar.dart';
import 'package:colourlovers_app/widgets/item-tiles.dart';
import 'package:colourlovers_app/widgets/items-list.dart';
import 'package:colourlovers_app/widgets/random-item-button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PalettesViewBloc extends Cubit<ItemsListViewModel<PaletteTileViewModel>> {
  factory PalettesViewBloc.fromContext(BuildContext context) {
    return PalettesViewBloc(
      ColourloversApiClient(),
    );
  }

  final ColourloversApiClient _client;
  late final ItemsPagination<ColourloversPalette> _pagination;

  PalettesViewBloc(
    this._client,
  ) : super(
          ItemsListViewModel.initialState(),
        ) {
    _pagination = ItemsPagination<ColourloversPalette>((numResults, offset) {
      return _client.getPalettes(
        numResults: numResults,
        resultOffset: offset,
        // orderBy: ClRequestOrderBy.numVotes,
        sortBy: ColourloversRequestSortBy.DESC,
        showPaletteWidths: true,
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

  void showPaletteDetails(
    BuildContext context,
    PaletteTileViewModel viewModel,
  ) {
    final viewModelIndex = state.items.indexOf(viewModel);
    final palette = _pagination.items[viewModelIndex];
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

  void _updateState() {
    emit(
      ItemsListViewModel(
        isLoading: _pagination.isLoading,
        items: _pagination.items //
            .map(PaletteTileViewModel.fromColourloverPalette)
            .toList(),
        hasMoreItems: _pagination.hasMoreItems,
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
      child: BlocBuilder<PalettesViewBloc,
          ItemsListViewModel<PaletteTileViewModel>>(
        builder: (context, viewModel) {
          return PalettesView(
            listViewModel: viewModel,
            bloc: context.read<PalettesViewBloc>(),
          );
        },
      ),
    );
  }
}

class PalettesView extends StatelessWidget {
  final ItemsListViewModel<PaletteTileViewModel> listViewModel;
  final PalettesViewBloc bloc;

  const PalettesView({
    super.key,
    required this.listViewModel,
    required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: ItemsListView(
        viewModel: listViewModel,
        itemTileBuilder: (itemViewModel) {
          return PaletteTileView(
            viewModel: itemViewModel,
            onTap: () {
              bloc.showPaletteDetails(context, itemViewModel);
            },
          );
        },
        onLoadMorePressed: bloc.loadMore,
      ),
    );
  }
}
