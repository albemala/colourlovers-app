import 'package:colourlovers_app/providers/providers.dart';
import 'package:colourlovers_app/views/items.dart';
import 'package:colourlovers_app/widgets/color.dart';
import 'package:colourlovers_app/widgets/explore-tile.dart';
import 'package:colourlovers_app/widgets/palette.dart';
import 'package:colourlovers_app/widgets/pattern.dart';
import 'package:colourlovers_app/widgets/user.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ExploreView extends HookConsumerWidget {
  const ExploreView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ExploreTileWidget(
                onTap: () {
                  ref.read(routingProvider.notifier).showScreen(context, const ColorsView());
                },
                title: 'Colors',
                child: const ColorWidget(hex: '1693A5'),
              ),
              const SizedBox(height: 8),
              ExploreTileWidget(
                onTap: () {
                  ref.read(routingProvider.notifier).showScreen(context, const PalettesView());
                },
                title: 'Palettes',
                child: const PaletteWidget(
                  colors: ['FE4365', 'FC9D9A', 'F9CDAD', 'C8C8A9', '83AF9B'],
                  widths: [0.23, 0.07, 0.06, 0.07, 0.57],
                ),
              ),
              const SizedBox(height: 8),
              ExploreTileWidget(
                onTap: () {
                  ref.read(routingProvider.notifier).showScreen(context, const PatternsView());
                },
                title: 'Patterns',
                child: const PatternWidget(
                  // TODO store locally
                  imageUrl: 'http://static.colourlovers.com/images/patterns/1101/1101098.png',
                ),
              ),
              const SizedBox(height: 8),
              ExploreTileWidget(
                onTap: () {
                  ref.read(routingProvider.notifier).showScreen(context, const UsersView());
                },
                title: 'Users',
                child: const UserWidget(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
