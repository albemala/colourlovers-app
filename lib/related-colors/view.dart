import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/app/routing.dart';
import 'package:colourlovers_app/color-details/view.dart';
import 'package:colourlovers_app/related-items.dart';
import 'package:colourlovers_app/widgets/app-top-bar.dart';
import 'package:colourlovers_app/widgets/item-tiles.dart';
import 'package:colourlovers_app/widgets/items-list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RelatedColorsViewBloc
    extends Cubit<ItemsListViewModel<ColorTileViewModel>> {
  factory RelatedColorsViewBloc.fromContext(
    BuildContext context, {
    required Hsv hsv,
  }) {
    return RelatedColorsViewBloc(
      hsv,
      ColourloversApiClient(),
    );
  }

  final Hsv _hsv;
  final ColourloversApiClient _client;
  late final ItemsPagination<ColourloversColor> _pagination;

  RelatedColorsViewBloc(
    this._hsv,
    this._client,
  ) : super(
          ItemsListViewModel.initialState(),
        ) {
    _pagination = ItemsPagination<ColourloversColor>((numResults, offset) {
      return fetchRelatedColors(_client, numResults, offset, _hsv);
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

class RelatedColorsViewBuilder extends StatelessWidget {
  final Hsv hsv;

  const RelatedColorsViewBuilder({
    super.key,
    required this.hsv,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RelatedColorsViewBloc>(
      create: (context) {
        return RelatedColorsViewBloc.fromContext(
          context,
          hsv: hsv,
        );
      },
      child: BlocBuilder<RelatedColorsViewBloc,
          ItemsListViewModel<ColorTileViewModel>>(
        builder: (context, viewModel) {
          return RelatedColorsView(
            listViewModel: viewModel,
            bloc: context.read<RelatedColorsViewBloc>(),
          );
        },
      ),
    );
  }
}

class RelatedColorsView extends StatelessWidget {
  final ItemsListViewModel<ColorTileViewModel> listViewModel;
  final RelatedColorsViewBloc bloc;

  const RelatedColorsView({
    super.key,
    required this.listViewModel,
    required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTopBarView(
        context,
        title: 'Related colors',
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
