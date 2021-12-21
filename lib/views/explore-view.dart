import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/providers/providers.dart';
import 'package:colourlovers_app/widgets/color-tile-view.dart';
import 'package:colourlovers_app/widgets/explore-tile-view.dart';
import 'package:colourlovers_app/widgets/items-view.dart';
import 'package:colourlovers_app/widgets/palette-tile-view.dart';
import 'package:colourlovers_app/widgets/pattern-tile-view.dart';
import 'package:colourlovers_app/widgets/user-tile-view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ExploreView extends HookConsumerWidget {
  const ExploreView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Wrap(
        direction: Axis.vertical,
        spacing: 16,
        // crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          ExploreTileView(
            onTap: () {
              ref.read(routingProvider.notifier).showScreen(context, createColorsView(ref));
            },
            text: "Colors",
          ),
          ExploreTileView(
            onTap: () {
              ref.read(routingProvider.notifier).showScreen(context, createPalettesView(ref));
            },
            text: "Palettes",
          ),
          ExploreTileView(
            onTap: () {
              ref.read(routingProvider.notifier).showScreen(context, createPatternsView(ref));
            },
            text: "Patterns",
          ),
          ExploreTileView(
            onTap: () {
              ref.read(routingProvider.notifier).showScreen(context, createUsersView(ref));
            },
            text: "Users",
          ),
        ],
      ),
    );
  }

  Widget createColorsView(WidgetRef ref) {
    return ItemsView<ClColor>(
      appBar: AppBar(
        title: const Text("Colors"),
      ),
      service: colorsProvider,
      itemBuilder: (context, state, index) {
        final color = state.items[index];
        return ColorTileView(color: color);
      },
    );
  }

  Widget createPalettesView(WidgetRef ref) {
    return ItemsView<ClPalette>(
      appBar: AppBar(
        title: const Text("Palettes"),
      ),
      service: palettesProvider,
      itemBuilder: (context, state, index) {
        final palette = state.items[index];
        return PaletteTileView(palette: palette);
      },
    );
  }

  Widget createPatternsView(WidgetRef ref) {
    return ItemsView<ClPattern>(
      appBar: AppBar(
        title: const Text("Patterns"),
      ),
      service: patternsProvider,
      itemBuilder: (context, state, index) {
        final pattern = state.items[index];
        return PatternTileView(pattern: pattern);
      },
    );
  }

  Widget createUsersView(WidgetRef ref) {
    return ItemsView<ClLover>(
      appBar: AppBar(
        title: const Text("Users"),
      ),
      service: usersProvider,
      itemBuilder: (context, state, index) {
        final lover = state.items[index];
        return UserTileView(lover: lover);
      },
    );
  }
}
