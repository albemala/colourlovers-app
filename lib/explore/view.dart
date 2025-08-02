import 'package:colourlovers_app/explore/view-controller.dart';
import 'package:colourlovers_app/explore/view-state.dart';
import 'package:colourlovers_app/theme/text.dart';
import 'package:colourlovers_app/widgets/app-bar.dart';
import 'package:colourlovers_app/widgets/background/view.dart';
import 'package:colourlovers_app/widgets/items/color.dart';
import 'package:colourlovers_app/widgets/items/palette.dart';
import 'package:colourlovers_app/widgets/items/pattern.dart';
import 'package:colourlovers_app/widgets/items/user.dart';
import 'package:colourlovers_app/widgets/skewed-container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExploreViewCreator extends StatelessWidget {
  const ExploreViewCreator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: ExploreViewController.fromContext,
      child: BlocBuilder<ExploreViewController, ExploreViewState>(
        builder: (context, state) {
          return ExploreView(
            state: state,
            controller: context.read<ExploreViewController>(),
          );
        },
      ),
    );
  }
}

class ExploreView extends StatelessWidget {
  final ExploreViewState state;
  final ExploreViewController controller;

  const ExploreView({super.key, required this.state, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarView(context, title: 'Explore'),
      body: BackgroundView(
        blobs: state.backgroundBlobs.toList(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 8,
            children: [
              ExploreTileView(
                onTap: () {
                  controller.showColorsView(context);
                },
                title: 'Colors',
                child: const ColorView(hex: '1693A5'),
              ),
              ExploreTileView(
                onTap: () {
                  controller.showPalettesView(context);
                },
                title: 'Palettes',
                child: const PaletteView(
                  hexs: ['FE4365', 'FC9D9A', 'F9CDAD', 'C8C8A9', '83AF9B'],
                  widths: [0.23, 0.07, 0.06, 0.07, 0.57],
                ),
              ),
              ExploreTileView(
                onTap: () {
                  controller.showPatternsView(context);
                },
                title: 'Patterns',
                child: const PatternView(
                  imageUrl: 'asset://assets/items/patterns/1101098.png',
                ),
              ),
              ExploreTileView(
                onTap: () {
                  controller.showUsersView(context);
                },
                title: 'Users',
                child: const UserView(),
              ),
            ],
          ),
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
            child: InkWell(onTap: onTap),
          ),
          Positioned(
            top: 8,
            left: -4,
            child: SkewedContainerView.large(
              child: Text(
                title.toUpperCase(),
                style: getExploreTileTextStyle(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
