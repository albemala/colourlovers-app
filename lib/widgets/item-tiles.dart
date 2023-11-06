import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/widgets/items.dart';
import 'package:colourlovers_app/widgets/pill.dart';
import 'package:colourlovers_app/widgets/skewed-container.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ColorTileViewModel {
  final String title;
  final int numViews;
  final int numVotes;
  final String hex;

  const ColorTileViewModel({
    required this.title,
    required this.numViews,
    required this.numVotes,
    required this.hex,
  });

  factory ColorTileViewModel.empty() {
    return const ColorTileViewModel(
      title: '',
      numViews: 0,
      numVotes: 0,
      hex: '',
    );
  }

  factory ColorTileViewModel.fromColourloverColor(
    ColourloversColor color,
  ) {
    return ColorTileViewModel(
      title: color.title ?? '',
      numViews: color.numViews ?? 0,
      numVotes: color.numVotes ?? 0,
      hex: color.hex ?? '',
    );
  }
}

class ColorTileView extends StatelessWidget {
  final void Function() onTap;
  final ColorTileViewModel viewModel;

  const ColorTileView({
    super.key,
    required this.onTap,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return _ItemTileView(
      onTap: onTap,
      title: viewModel.title,
      numViews: viewModel.numViews,
      numVotes: viewModel.numVotes,
      child: ColorView(hex: viewModel.hex),
    );
  }
}

class PaletteTileViewModel {
  final String title;
  final int numViews;
  final int numVotes;
  final List<String> hexs;

  const PaletteTileViewModel({
    required this.title,
    required this.numViews,
    required this.numVotes,
    required this.hexs,
  });

  factory PaletteTileViewModel.empty() {
    return const PaletteTileViewModel(
      title: '',
      numViews: 0,
      numVotes: 0,
      hexs: [],
    );
  }

  factory PaletteTileViewModel.fromColourloverPalette(
    ColourloversPalette palette,
  ) {
    return PaletteTileViewModel(
      title: palette.title ?? '',
      numViews: palette.numViews ?? 0,
      numVotes: palette.numVotes ?? 0,
      hexs: palette.colors ?? [],
    );
  }
}

class PaletteTileView extends StatelessWidget {
  final void Function() onTap;
  final PaletteTileViewModel viewModel;

  const PaletteTileView({
    super.key,
    required this.onTap,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return _ItemTileView(
      onTap: onTap,
      title: viewModel.title,
      numViews: viewModel.numViews,
      numVotes: viewModel.numVotes,
      child: PaletteView(hexs: viewModel.hexs),
    );
  }
}

class PatternTileViewModel {
  final String title;
  final int numViews;
  final int numVotes;
  final String imageUrl;

  const PatternTileViewModel({
    required this.title,
    required this.numViews,
    required this.numVotes,
    required this.imageUrl,
  });

  factory PatternTileViewModel.empty() {
    return const PatternTileViewModel(
      title: '',
      numViews: 0,
      numVotes: 0,
      imageUrl: '',
    );
  }

  factory PatternTileViewModel.fromColourloverPattern(
    ColourloversPattern pattern,
  ) {
    return PatternTileViewModel(
      title: pattern.title ?? '',
      numViews: pattern.numViews ?? 0,
      numVotes: pattern.numVotes ?? 0,
      imageUrl: pattern.imageUrl ?? '',
    );
  }
}

class PatternTileView extends StatelessWidget {
  final void Function() onTap;
  final PatternTileViewModel viewModel;

  const PatternTileView({
    super.key,
    required this.onTap,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return _ItemTileView(
      onTap: onTap,
      title: viewModel.title,
      numViews: viewModel.numViews,
      numVotes: viewModel.numVotes,
      child: PatternView(imageUrl: viewModel.imageUrl),
    );
  }
}

class _ItemTileView extends StatelessWidget {
  final void Function() onTap;
  final String title;
  final int numViews;
  final int numVotes;
  final Widget child;

  const _ItemTileView({
    required this.onTap,
    required this.title,
    required this.numViews,
    required this.numVotes,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 72,
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
            right: 8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: SkewedContainerView(
                    padding: const EdgeInsets.fromLTRB(8, 4, 12, 4),
                    color: Theme.of(context).colorScheme.inverseSurface,
                    elevation: 4,
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                      softWrap: false,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onInverseSurface,
                          ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    const SizedBox(width: 8),
                    PillView(
                      text: numViews.toString(),
                      icon: LucideIcons.glasses,
                    ),
                    const SizedBox(width: 8),
                    PillView(
                      text: numVotes.toString(),
                      icon: LucideIcons.heart,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class UserTileViewModel {
  final String userName;
  final int numColors;
  final int numPalettes;
  final int numPatterns;

  const UserTileViewModel({
    required this.userName,
    required this.numColors,
    required this.numPalettes,
    required this.numPatterns,
  });

  factory UserTileViewModel.empty() {
    return const UserTileViewModel(
      userName: '',
      numColors: 0,
      numPalettes: 0,
      numPatterns: 0,
    );
  }

  factory UserTileViewModel.fromColourloverUser(
    ColourloversLover user,
  ) {
    return UserTileViewModel(
      userName: user.userName ?? '',
      numColors: user.numColors ?? 0,
      numPalettes: user.numPalettes ?? 0,
      numPatterns: user.numPatterns ?? 0,
    );
  }
}

class UserTileView extends StatelessWidget {
  final void Function() onTap;
  final UserTileViewModel viewModel;

  const UserTileView({
    super.key,
    required this.onTap,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 72,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          SizedBox(
            width: double.maxFinite,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: const UserView(),
            ),
          ),
          Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: () {
                onTap();
                // TODO
                // ref.read(routingProvider.notifier).showScreen(context, UserDetailsView(lover: lover));
              },
            ),
          ),
          Positioned(
            top: 8,
            left: -4,
            // right: 8,
            child: SkewedContainerView(
              padding: const EdgeInsets.fromLTRB(8, 4, 12, 4),
              color: Colors.white,
              elevation: 4,
              child: Text(
                viewModel.userName,
                // maxLines: 1,
                // overflow: TextOverflow.fade,
                // softWrap: false,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.background,
                    ),
              ),
            ),
          ),
          Positioned(
            bottom: 8,
            left: 8,
            // right: 8,
            child: Row(
              children: [
                PillView(
                  text: viewModel.numColors.toString(),
                  icon: LucideIcons.square,
                ),
                const SizedBox(width: 8),
                PillView(
                  text: viewModel.numPalettes.toString(),
                  icon: LucideIcons.columns,
                ),
                const SizedBox(width: 8),
                PillView(
                  text: viewModel.numPatterns.toString(),
                  icon: LucideIcons.grid,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
