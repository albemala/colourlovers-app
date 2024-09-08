import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/app/routing.dart';
import 'package:colourlovers_app/palette-details/view.dart';
import 'package:colourlovers_app/related-items.dart';
import 'package:colourlovers_app/widgets/app-top-bar.dart';
import 'package:colourlovers_app/widgets/item-tiles.dart';
import 'package:colourlovers_app/widgets/items-list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RelatedPalettesViewBloc
    extends Cubit<ItemsListViewModel<PaletteTileViewModel>> {
  factory RelatedPalettesViewBloc.fromContext(
    BuildContext context, {
    required List<String> hex,
  }) {
    return RelatedPalettesViewBloc(
      hex,
      ColourloversApiClient(),
    );
  }

  final List<String> _hex;
  final ColourloversApiClient _client;
  late final ItemsPagination<ColourloversPalette> _pagination;

  RelatedPalettesViewBloc(
    this._hex,
    this._client,
  ) : super(
          ItemsListViewModel.initialState(),
        ) {
    _pagination = ItemsPagination<ColourloversPalette>((numResults, offset) {
      return fetchRelatedPalettes(_client, numResults, offset, _hex);
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

class RelatedPalettesViewBuilder extends StatelessWidget {
  final List<String> hex;

  const RelatedPalettesViewBuilder({
    super.key,
    required this.hex,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RelatedPalettesViewBloc>(
      create: (context) {
        return RelatedPalettesViewBloc.fromContext(
          context,
          hex: hex,
        );
      },
      child: BlocBuilder<RelatedPalettesViewBloc,
          ItemsListViewModel<PaletteTileViewModel>>(
        builder: (context, viewModel) {
          return RelatedPalettesView(
            listViewModel: viewModel,
            bloc: context.read<RelatedPalettesViewBloc>(),
          );
        },
      ),
    );
  }
}

class RelatedPalettesView extends StatelessWidget {
  final ItemsListViewModel<PaletteTileViewModel> listViewModel;
  final RelatedPalettesViewBloc bloc;

  const RelatedPalettesView({
    super.key,
    required this.listViewModel,
    required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTopBarView(
        context,
        title: 'Related palettes',
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
