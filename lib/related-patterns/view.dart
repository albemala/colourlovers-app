import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/app/routing.dart';
import 'package:colourlovers_app/pattern-details/view.dart';
import 'package:colourlovers_app/related-items.dart';
import 'package:colourlovers_app/widgets/app-top-bar.dart';
import 'package:colourlovers_app/widgets/item-tiles.dart';
import 'package:colourlovers_app/widgets/items-list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RelatedPatternsViewBloc
    extends Cubit<ItemsListViewModel<PatternTileViewModel>> {
  factory RelatedPatternsViewBloc.fromContext(
    BuildContext context, {
    required List<String> hex,
  }) {
    return RelatedPatternsViewBloc(
      hex,
      ColourloversApiClient(),
    );
  }

  final List<String> _hex;
  final ColourloversApiClient _client;
  late final ItemsPagination<ColourloversPattern> _pagination;

  RelatedPatternsViewBloc(
    this._hex,
    this._client,
  ) : super(
          ItemsListViewModel.initialState(),
        ) {
    _pagination = ItemsPagination<ColourloversPattern>((numResults, offset) {
      return fetchRelatedPatterns(_client, numResults, offset, _hex);
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

  void showPatternDetails(
    BuildContext context,
    PatternTileViewModel viewModel,
  ) {
    final viewModelIndex = state.items.indexOf(viewModel);
    final pattern = _pagination.items[viewModelIndex];
    openRoute(context, PatternDetailsViewBuilder(pattern: pattern));
  }

  void _updateState() {
    emit(
      ItemsListViewModel(
        isLoading: _pagination.isLoading,
        items: _pagination.items //
            .map(PatternTileViewModel.fromColourloverPattern)
            .toList(),
        hasMoreItems: _pagination.hasMoreItems,
      ),
    );
  }
}

class RelatedPatternsViewBuilder extends StatelessWidget {
  final List<String> hex;

  const RelatedPatternsViewBuilder({
    super.key,
    required this.hex,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RelatedPatternsViewBloc>(
      create: (context) {
        return RelatedPatternsViewBloc.fromContext(
          context,
          hex: hex,
        );
      },
      child: BlocBuilder<RelatedPatternsViewBloc,
          ItemsListViewModel<PatternTileViewModel>>(
        builder: (context, viewModel) {
          return RelatedPatternsView(
            listViewModel: viewModel,
            bloc: context.read<RelatedPatternsViewBloc>(),
          );
        },
      ),
    );
  }
}

class RelatedPatternsView extends StatelessWidget {
  final ItemsListViewModel<PatternTileViewModel> listViewModel;
  final RelatedPatternsViewBloc bloc;

  const RelatedPatternsView({
    super.key,
    required this.listViewModel,
    required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTopBarView(
        context,
        title: 'Related patterns',
      ),
      body: ItemsListView(
        viewModel: listViewModel,
        itemTileBuilder: (itemViewModel) {
          return PatternTileView(
            viewModel: itemViewModel,
            onTap: () {
              bloc.showPatternDetails(context, itemViewModel);
            },
          );
        },
        onLoadMorePressed: bloc.loadMore,
      ),
    );
  }
}
