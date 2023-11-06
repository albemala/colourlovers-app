import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/widgets/app-top-bar.dart';
import 'package:colourlovers_app/widgets/item-tiles.dart';
import 'package:colourlovers_app/widgets/random-item-button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_state_management/flutter_state_management.dart';

// TODO load more

class PatternsViewConductor extends Conductor {
  factory PatternsViewConductor.fromContext(BuildContext context) {
    return PatternsViewConductor(
      ColourloversApiClient(),
    );
  }

  final ColourloversApiClient client;
  int page = 0;

  final patterns = ValueNotifier(<ColourloversPattern>[]);
  final isLoading = ValueNotifier(false);

  PatternsViewConductor(
    this.client,
  ) {
    load();
  }

  Future<void> load() async {
    isLoading.value = true;

    const numResults = 20;
    final items = await client.getPatterns(
          numResults: numResults,
          resultOffset: page * numResults,
          // orderBy: ClRequestOrderBy.numVotes,
          sortBy: ColourloversRequestSortBy.DESC,
        ) ??
        [];
    patterns.value = [
      ...patterns.value,
      ...items,
    ];

    isLoading.value = false;
  }

  Future<void> loadMore() async {
    page++;
    await load();
  }

  void showPatternDetails(ColourloversPattern pattern) {
    // TODO
  }

  Future<void> openRandomPattern() async {
    final pattern = await client.getRandomPattern();
    if (pattern == null) return;
    showPatternDetails(pattern);
  }

  @override
  void dispose() {
    patterns.dispose();
    isLoading.dispose();
  }
}

class PatternsViewCreator extends StatelessWidget {
  const PatternsViewCreator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ConductorCreator(
      create: PatternsViewConductor.fromContext,
      child: ConductorConsumer<PatternsViewConductor>(
        builder: (context, conductor) {
          return PatternsView(
            conductor: conductor,
          );
        },
      ),
    );
  }
}

class PatternsView extends StatelessWidget {
  final PatternsViewConductor conductor;

  const PatternsView({
    super.key,
    required this.conductor,
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
            onPressed: conductor.openRandomPattern,
            tooltip: 'Random pattern',
          ),
          // _FilterButton(
          //   onPressed: () {
          //     // TODO
          //   },
          // ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: conductor.patterns,
        builder: (context, patterns, child) {
          return ValueListenableBuilder(
            valueListenable: conductor.isLoading,
            builder: (context, isLoading, child) {
              return ListView.separated(
                padding: const EdgeInsets.all(16),
                // controller: scrollController,
                itemCount: patterns.length + 1,
                itemBuilder: (context, index) {
                  if (index == patterns.length) {
                    if (isLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      // TODO dont show if no more items
                      return OutlinedButton(
                        onPressed: conductor.loadMore,
                        child: const Text('Load more'),
                      );
                    }
                  } else {
                    final pattern = patterns[index];
                    return PatternTileView(
                      pattern: pattern,
                      onTap: () {
                        conductor.showPatternDetails(pattern);
                      },
                    );
                  }
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 12);
                },
              );
            },
          );
        },
      ),
    );
  }
}
