import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/providers/providers.dart';
import 'package:colourlovers_app/views/items.dart';
import 'package:colourlovers_app/widgets/app-bar.dart';
import 'package:colourlovers_app/widgets/color-tile.dart';
import 'package:colourlovers_app/widgets/color.dart';
import 'package:colourlovers_app/widgets/explore-tile.dart';
import 'package:colourlovers_app/widgets/palette-tile.dart';
import 'package:colourlovers_app/widgets/palette.dart';
import 'package:colourlovers_app/widgets/pattern-tile.dart';
import 'package:colourlovers_app/widgets/pattern.dart';
import 'package:colourlovers_app/widgets/user-tile.dart';
import 'package:colourlovers_app/widgets/user.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ExploreView extends HookConsumerWidget {
  const ExploreView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ExploreTileWidget(
              onTap: () {
                ref.read(routingProvider.notifier).showScreen(context, createColorsView(context, ref));
              },
              title: "Colors",
              child: const ColorWidget(hex: "1693A5"),
            ),
            const SizedBox(height: 8),
            ExploreTileWidget(
              onTap: () {
                ref.read(routingProvider.notifier).showScreen(context, createPalettesView(context, ref));
              },
              title: "Palettes",
              child: const PaletteWidget(
                colors: ["FE4365", "FC9D9A", "F9CDAD", "C8C8A9", "83AF9B"],
                widths: [0.23, 0.07, 0.06, 0.07, 0.57],
              ),
            ),
            const SizedBox(height: 8),
            ExploreTileWidget(
              onTap: () {
                ref.read(routingProvider.notifier).showScreen(context, createPatternsView(context, ref));
              },
              title: "Patterns",
              child: const PatternWidget(
                // TODO store locally
                imageUrl: "http://static.colourlovers.com/images/patterns/1101/1101098.png",
              ),
            ),
            const SizedBox(height: 8),
            ExploreTileWidget(
              onTap: () {
                ref.read(routingProvider.notifier).showScreen(context, createUsersView(context, ref));
              },
              title: "Users",
              child: const UserWidget(),
            ),
          ],
        ),
      ),
    );
  }

  Widget createColorsView(BuildContext context, WidgetRef ref) {
    return ItemsView<ClColor>(
      appBar: AppBarWidget(
        context,
        titleText: "Colors",
      ),
      service: colorsProvider,
      itemBuilder: (context, state, index) {
        final color = state.items[index];
        return ColorTileWidget(color: color);
      },
    );
  }

  Widget createPalettesView(BuildContext context, WidgetRef ref) {
    return ItemsView<ClPalette>(
      appBar: AppBarWidget(
        context,
        titleText: "Palettes",
      ),
      service: palettesProvider,
      itemBuilder: (context, state, index) {
        final palette = state.items[index];
        return PaletteTileWidget(palette: palette);
      },
    );
  }

  Widget createPatternsView(BuildContext context, WidgetRef ref) {
    return ItemsView<ClPattern>(
      appBar: AppBarWidget(
        context,
        titleText: "Patterns",
      ),
      service: patternsProvider,
      itemBuilder: (context, state, index) {
        final pattern = state.items[index];
        return PatternTileWidget(pattern: pattern);
      },
    );
  }

  Widget createUsersView(BuildContext context, WidgetRef ref) {
    return ItemsView<ClLover>(
      appBar: AppBarWidget(
        context,
        titleText: "Users",
      ),
      service: usersProvider,
      itemBuilder: (context, state, index) {
        final lover = state.items[index];
        return UserTileWidget(lover: lover);
      },
    );
  }
}
