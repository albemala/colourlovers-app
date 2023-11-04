import 'package:colourlovers_app/widgets/color.dart';
import 'package:colourlovers_app/widgets/palette.dart';
import 'package:colourlovers_app/widgets/pattern.dart';
import 'package:colourlovers_app/widgets/skewed-container.dart';
import 'package:colourlovers_app/widgets/user.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ExploreView extends StatelessWidget {
  const ExploreView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ExploreTileView(
              onTap: () {
                // ref.read(routingProvider.notifier).showScreen(context, const ColorsView());
              },
              title: 'Colors',
              child: const ColorTileView(hex: '1693A5'),
            ),
            const SizedBox(height: 8),
            ExploreTileView(
              onTap: () {
                // ref.read(routingProvider.notifier).showScreen(context, const PalettesView());
              },
              title: 'Palettes',
              child: const PaletteTileView(
                colors: ['FE4365', 'FC9D9A', 'F9CDAD', 'C8C8A9', '83AF9B'],
                widths: [0.23, 0.07, 0.06, 0.07, 0.57],
              ),
            ),
            const SizedBox(height: 8),
            ExploreTileView(
              onTap: () {
                // ref.read(routingProvider.notifier).showScreen(context, const PatternsView());
              },
              title: 'Patterns',
              child: const PatternTileView(
                // TODO store locally
                imageUrl:
                    'http://static.colourlovers.com/images/patterns/1101/1101098.png',
              ),
            ),
            const SizedBox(height: 8),
            ExploreTileView(
              onTap: () {
                // ref.read(routingProvider.notifier).showScreen(context, const UsersView());
              },
              title: 'Users',
              child: const UserTileView(),
            ),
          ],
        ),
      ),
    );
  }
}

class ExploreTileView extends StatelessWidget {
  final void Function() onTap;
  final String title;
  final Widget child;

  const ExploreTileView({
    super.key,
    required this.onTap,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 96,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          SizedBox.expand(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: child,
            ),
          ),
          Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: onTap,
            ),
          ),
          Positioned(
            top: 8,
            left: -4,
            child: SkewedContainerView(
              padding: const EdgeInsets.fromLTRB(16, 8, 21, 8),
              color: Colors.white,
              elevation: 4,
              child: Text(
                title.toUpperCase(),
                style: GoogleFonts.archivoNarrow(
                  textStyle: Theme.of(context).textTheme.bodyLarge,
                  color: Theme.of(context).colorScheme.background,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.6,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
