import 'package:colourlovers_app/conductors/routing.dart';
import 'package:colourlovers_app/views/colors.dart';
import 'package:colourlovers_app/views/palettes.dart';
import 'package:colourlovers_app/views/patterns.dart';
import 'package:colourlovers_app/widgets/items.dart';
import 'package:colourlovers_app/widgets/skewed-container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_state_management/flutter_state_management.dart';
import 'package:google_fonts/google_fonts.dart';

class ExploreViewConductor extends Conductor {
  factory ExploreViewConductor.fromContext(BuildContext context) {
    return ExploreViewConductor(
      context.getConductor<RoutingConductor>(),
    );
  }

  final RoutingConductor _routingConductor;

  ExploreViewConductor(
    this._routingConductor,
  );

  void showColorsView() {
    _routingConductor.openRoute((context) {
      return const ColorsViewCreator();
    });
  }

  void showPalettesView() {
    _routingConductor.openRoute((context) {
      return const PalettesViewCreator();
    });
  }

  void showPatternsView() {
    _routingConductor.openRoute((context) {
      return const PatternsViewCreator();
    });
  }

  void showUsersView() {
    // _routingConductor.openRoute((context) {
    //   return const UsersViewCreator();
    // });
  }

  @override
  void dispose() {}
}

class ExploreViewCreator extends StatelessWidget {
  const ExploreViewCreator({super.key});

  @override
  Widget build(BuildContext context) {
    return ConductorCreator(
      create: ExploreViewConductor.fromContext,
      child: ConductorConsumer<ExploreViewConductor>(
        builder: (context, conductor) {
          return ExploreView(
            conductor: conductor,
          );
        },
      ),
    );
  }
}

class ExploreView extends StatelessWidget {
  final ExploreViewConductor conductor;

  const ExploreView({
    super.key,
    required this.conductor,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ExploreTileView(
              onTap: conductor.showColorsView,
              title: 'Colors',
              child: const ColorView(hex: '1693A5'),
            ),
            const SizedBox(height: 8),
            ExploreTileView(
              onTap: conductor.showPalettesView,
              title: 'Palettes',
              child: const PaletteView(
                hexs: ['FE4365', 'FC9D9A', 'F9CDAD', 'C8C8A9', '83AF9B'],
                widths: [0.23, 0.07, 0.06, 0.07, 0.57],
              ),
            ),
            const SizedBox(height: 8),
            ExploreTileView(
              onTap: conductor.showPatternsView,
              title: 'Patterns',
              child: const PatternView(
                // TODO store locally
                imageUrl:
                    'http://static.colourlovers.com/images/patterns/1101/1101098.png',
              ),
            ),
            const SizedBox(height: 8),
            ExploreTileView(
              onTap: conductor.showUsersView,
              title: 'Users',
              child: const UserView(),
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
              color: Theme.of(context).colorScheme.inverseSurface,
              elevation: 4,
              child: Text(
                title.toUpperCase(),
                style: GoogleFonts.archivoNarrow(
                  textStyle: Theme.of(context).textTheme.bodyLarge,
                  color: Theme.of(context).colorScheme.onInverseSurface,
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
