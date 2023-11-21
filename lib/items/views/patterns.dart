import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/app/routing.dart';
import 'package:colourlovers_app/common/widgets/app-top-bar.dart';
import 'package:colourlovers_app/common/widgets/item-tiles.dart';
import 'package:colourlovers_app/common/widgets/items-list.dart';
import 'package:colourlovers_app/item-details/views/pattern-details.dart';
import 'package:colourlovers_app/items/widgets/random-item-button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PatternsViewBloc extends Cubit<ItemsListViewModel<PatternTileViewModel>> {
  factory PatternsViewBloc.fromContext(BuildContext context) {
    return PatternsViewBloc(
      ColourloversApiClient(),
    );
  }

  final ColourloversApiClient _client;
  late final ItemsPagination<ColourloversPattern> _pagination;

  PatternsViewBloc(
    this._client,
  ) : super(
          ItemsListViewModel.initialState(),
        ) {
    _pagination = ItemsPagination<ColourloversPattern>((numResults, offset) {
      return _client.getPatterns(
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

  void showPatternDetails(
    BuildContext context,
    PatternTileViewModel viewModel,
  ) {
    final viewModelIndex = state.items.indexOf(viewModel);
    final pattern = _pagination.items[viewModelIndex];
    _showPatternDetailsView(context, pattern);
  }

  Future<void> showRandomPattern(
    BuildContext context,
  ) async {
    final pattern = await _client.getRandomPattern();
    if (pattern == null) return;
    _showPatternDetailsView(context, pattern);
  }

  void _showPatternDetailsView(
    BuildContext context,
    ColourloversPattern pattern,
  ) {
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

class PatternsViewBuilder extends StatelessWidget {
  const PatternsViewBuilder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PatternsViewBloc>(
      create: PatternsViewBloc.fromContext,
      child: BlocBuilder<PatternsViewBloc,
          ItemsListViewModel<PatternTileViewModel>>(
        builder: (context, viewModel) {
          return PatternsView(
            listViewModel: viewModel,
            bloc: context.read<PatternsViewBloc>(),
          );
        },
      ),
    );
  }
}

class PatternsView extends StatelessWidget {
  final ItemsListViewModel<PatternTileViewModel> listViewModel;
  final PatternsViewBloc bloc;

  const PatternsView({
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
        title: 'Patterns',
        actions: [
          RandomItemButton(
            onPressed: () {
              bloc.showRandomPattern(context);
            },
            tooltip: 'Random pattern',
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
