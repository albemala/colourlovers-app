import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/widgets/app-top-bar.dart';
import 'package:colourlovers_app/widgets/item-tiles.dart';
import 'package:colourlovers_app/widgets/random-item-button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_state_management/flutter_state_management.dart';

// TODO load more

class ColorsViewConductor extends Conductor {
  factory ColorsViewConductor.fromContext(BuildContext context) {
    return ColorsViewConductor(
      ColourloversApiClient(),
    );
  }

  final ColourloversApiClient client;
  int page = 0;

  final colors = ValueNotifier(<ColourloversColor>[]);
  final isLoading = ValueNotifier(false);

  ColorsViewConductor(
    this.client,
  ) {
    load();
  }

  Future<void> load() async {
    isLoading.value = true;

    const numResults = 20;
    final items = await client.getColors(
          numResults: numResults,
          resultOffset: page * numResults,
          // orderBy: ClRequestOrderBy.numVotes,
          sortBy: ColourloversRequestSortBy.DESC,
        ) ??
        [];
    colors.value = [
      ...colors.value,
      ...items,
    ];

    isLoading.value = false;
  }

  Future<void> loadMore() async {
    page++;
    await load();
  }

  void showColorDetails(ColourloversColor color) {
    // TODO
  }

  Future<void> openRandomColor() async {
    final color = await client.getRandomColor();
    if (color == null) return;
    showColorDetails(color);
  }

  @override
  void dispose() {
    colors.dispose();
    isLoading.dispose();
  }
}

class ColorsViewCreator extends StatelessWidget {
  const ColorsViewCreator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ConductorCreator(
      create: ColorsViewConductor.fromContext,
      child: ConductorConsumer<ColorsViewConductor>(
        builder: (context, conductor) {
          return ColorsView(
            conductor: conductor,
          );
        },
      ),
    );
  }
}

class ColorsView extends StatelessWidget {
  final ColorsViewConductor conductor;

  const ColorsView({
    super.key,
    required this.conductor,
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
            onPressed: conductor.openRandomColor,
            tooltip: 'Random color',
          ),
          // _FilterButton(
          //   onPressed: () {
          //     // TODO
          //   },
          // ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: conductor.colors,
        builder: (context, colors, child) {
          return ValueListenableBuilder(
            valueListenable: conductor.isLoading,
            builder: (context, isLoading, child) {
              return ListView.separated(
                padding: const EdgeInsets.all(16),
                // controller: scrollController,
                itemCount: colors.length + 1,
                itemBuilder: (context, index) {
                  if (index == colors.length) {
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
                    final color = colors[index];
                    return ColorTileView(
                      color: color,
                      onTap: () {
                        conductor.showColorDetails(color);
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
