import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/functions/routing.dart';
import 'package:colourlovers_app/views/pattern-details.dart';
import 'package:colourlovers_app/widgets/app-top-bar.dart';
import 'package:colourlovers_app/widgets/item-tiles.dart';
import 'package:colourlovers_app/widgets/random-item-button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@immutable
class PatternsViewModel {
  final bool isLoading;
  final List<PatternTileViewModel> patterns;

  const PatternsViewModel({
    required this.isLoading,
    required this.patterns,
  });

  factory PatternsViewModel.initialState() {
    return const PatternsViewModel(
      isLoading: false,
      patterns: <PatternTileViewModel>[],
    );
  }
}

class PatternsViewBloc extends Cubit<PatternsViewModel> {
  factory PatternsViewBloc.fromContext(BuildContext context) {
    return PatternsViewBloc(
      ColourloversApiClient(),
    );
  }

  final ColourloversApiClient _client;
  bool _isLoading = false;
  List<ColourloversPattern> _patterns = <ColourloversPattern>[];
  int _page = 0;

  PatternsViewBloc(
    this._client,
  ) : super(
          PatternsViewModel.initialState(),
        ) {
    load();
  }

  Future<void> load() async {
    _isLoading = true;
    _emitState();

    const numResults = 20;
    final items = await _client.getPatterns(
          numResults: numResults,
          resultOffset: _page * numResults,
          // orderBy: ClRequestOrderBy.numVotes,
          sortBy: ColourloversRequestSortBy.DESC,
        ) ??
        [];

    _isLoading = false;
    _patterns = [
      ..._patterns,
      ...items,
    ];
    _emitState();
  }

  Future<void> loadMore() async {
    _page++;
    await load();
  }

  void showPatternDetails(
    BuildContext context,
    int patternIndex,
  ) {
    final pattern = _patterns[patternIndex];
    _showPatternDetails(context, pattern);
  }

  Future<void> openRandomPattern(
    BuildContext context,
  ) async {
    final pattern = await _client.getRandomPattern();
    if (pattern == null) return;
    _showPatternDetails(context, pattern);
  }

  void _showPatternDetails(
    BuildContext context,
    ColourloversPattern pattern,
  ) {
    openRoute(context, PatternDetailsViewBuilder(pattern: pattern));
  }

  void _emitState() {
    emit(
      PatternsViewModel(
        isLoading: _isLoading,
        patterns: _patterns //
            .map(PatternTileViewModel.fromColourloverPattern)
            .toList(),
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
      child: BlocBuilder<PatternsViewBloc, PatternsViewModel>(
        builder: (context, viewModel) {
          return PatternsView(
            viewModel: viewModel,
            bloc: context.read<PatternsViewBloc>(),
          );
        },
      ),
    );
  }
}

class PatternsView extends StatelessWidget {
  final PatternsViewModel viewModel;
  final PatternsViewBloc bloc;

  const PatternsView({
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
        title: 'Patterns',
        actions: [
          RandomItemButton(
            onPressed: () {
              bloc.openRandomPattern(context);
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
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        // controller: scrollController,
        itemCount: viewModel.patterns.length + 1,
        itemBuilder: (context, index) {
          if (index == viewModel.patterns.length) {
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
            final pattern = viewModel.patterns[index];
            return PatternTileView(
              viewModel: pattern,
              onTap: () {
                bloc.showPatternDetails(context, index);
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
