import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/widgets/app-top-bar.dart';
import 'package:colourlovers_app/widgets/item-tiles.dart';
import 'package:colourlovers_app/widgets/random-item-button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_state_management/flutter_state_management.dart';

// TODO load more

class PalettesViewConductor extends Conductor {
  factory PalettesViewConductor.fromContext(BuildContext context) {
    return PalettesViewConductor(
      ColourloversApiClient(),
    );
  }

  final ColourloversApiClient client;
  int page = 0;

  final palettes = ValueNotifier(<ColourloversPalette>[]);
  final isLoading = ValueNotifier(false);

  PalettesViewConductor(
    this.client,
  ) {
    load();
  }

  Future<void> load() async {
    isLoading.value = true;

    const numResults = 20;
    final items = await client.getPalettes(
          numResults: numResults,
          resultOffset: page * numResults,
          // orderBy: ClRequestOrderBy.numVotes,
          sortBy: ColourloversRequestSortBy.DESC,
          showPaletteWidths: true,
        ) ??
        [];
    palettes.value = [
      ...palettes.value,
      ...items,
    ];

    isLoading.value = false;
  }

  Future<void> loadMore() async {
    page++;
    await load();
  }

  void showPaletteDetails(ColourloversPalette palette) {
    // TODO
  }

  Future<void> openRandomPalette() async {
    final palette = await client.getRandomPalette();
    if (palette == null) return;
    showPaletteDetails(palette);
  }

  @override
  void dispose() {
    palettes.dispose();
    isLoading.dispose();
  }
}

class PalettesViewCreator extends StatelessWidget {
  const PalettesViewCreator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ConductorCreator(
      create: PalettesViewConductor.fromContext,
      child: ConductorConsumer<PalettesViewConductor>(
        builder: (context, conductor) {
          return PalettesView(
            conductor: conductor,
          );
        },
      ),
    );
  }
}

class PalettesView extends StatelessWidget {
  final PalettesViewConductor conductor;

  const PalettesView({
    super.key,
    required this.conductor,
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
            onPressed: conductor.openRandomPalette,
            tooltip: 'Random palette',
          ),
          // _FilterButton(
          //   onPressed: () {
          //     // TODO
          //   },
          // ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: conductor.palettes,
        builder: (context, palettes, child) {
          return ValueListenableBuilder(
            valueListenable: conductor.isLoading,
            builder: (context, isLoading, child) {
              return ListView.separated(
                padding: const EdgeInsets.all(16),
                // controller: scrollController,
                itemCount: palettes.length + 1,
                itemBuilder: (context, index) {
                  if (index == palettes.length) {
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
                    final palette = palettes[index];
                    return PaletteTileView(
                      palette: palette,
                      onTap: () {
                        conductor.showPaletteDetails(palette);
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
