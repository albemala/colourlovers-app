import 'package:colourlovers_app/functions/routing.dart';
import 'package:colourlovers_app/views/colors.dart';
import 'package:colourlovers_app/views/palettes.dart';
import 'package:colourlovers_app/views/patterns.dart';
import 'package:colourlovers_app/widgets/items.dart';
import 'package:colourlovers_app/widgets/skewed-container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

// TODO create view model and pass tiles data to view from bloc

class ExploreViewBloc extends Cubit<void> {
  factory ExploreViewBloc.fromContext(BuildContext context) {
    return ExploreViewBloc();
  }

  ExploreViewBloc() : super(null);

  void showColorsView(BuildContext context) {
    openRoute(context, const ColorsViewBuilder());
  }

  void showPalettesView(BuildContext context) {
    openRoute(context, const PalettesViewBuilder());
  }

  void showPatternsView(BuildContext context) {
    openRoute(context, const PatternsViewBuilder());
  }

  void showUsersView(BuildContext context) {
    // openRoute(context, const UsersViewBuilder());
  }
}

class ExploreViewBuilder extends StatelessWidget {
  const ExploreViewBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: ExploreViewBloc.fromContext,
      child: BlocBuilder<ExploreViewBloc, void>(
        builder: (context, viewModel) {
          return ExploreView(
            // viewModel: viewModel,
            bloc: context.read<ExploreViewBloc>(),
          );
        },
      ),
    );
  }
}

class ExploreView extends StatelessWidget {
  // final void viewModel;
  final ExploreViewBloc bloc;

  const ExploreView({
    super.key,
    // required this.viewModel,
    required this.bloc,
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
              onTap: () {
                bloc.showColorsView(context);
              },
              title: 'Colors',
              child: const ColorView(hex: '1693A5'),
            ),
            const SizedBox(height: 8),
            ExploreTileView(
              onTap: () {
                bloc.showPalettesView(context);
              },
              title: 'Palettes',
              child: const PaletteView(
                hexs: ['FE4365', 'FC9D9A', 'F9CDAD', 'C8C8A9', '83AF9B'],
                widths: [0.23, 0.07, 0.06, 0.07, 0.57],
              ),
            ),
            const SizedBox(height: 8),
            ExploreTileView(
              onTap: () {
                bloc.showPatternsView(context);
              },
              title: 'Patterns',
              child: const PatternView(
                // TODO store locally
                imageUrl:
                    'http://static.colourlovers.com/images/patterns/1101/1101098.png',
              ),
            ),
            const SizedBox(height: 8),
            ExploreTileView(
              onTap: () {
                bloc.showUsersView(context);
              },
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
