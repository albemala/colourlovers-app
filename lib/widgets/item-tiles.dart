import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/widgets/items.dart';
import 'package:colourlovers_app/widgets/pill.dart';
import 'package:colourlovers_app/widgets/skewed-container.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

@immutable
class ColorTileViewState {
  final String title;
  final int numViews;
  final int numVotes;
  final String hex;

  const ColorTileViewState({
    required this.title,
    required this.numViews,
    required this.numVotes,
    required this.hex,
  });

  factory ColorTileViewState.empty() {
    return const ColorTileViewState(
      title: '',
      numViews: 0,
      numVotes: 0,
      hex: '',
    );
  }

  factory ColorTileViewState.fromColourloverColor(
    ColourloversColor color,
  ) {
    return ColorTileViewState(
      title: color.title ?? '',
      numViews: color.numViews ?? 0,
      numVotes: color.numVotes ?? 0,
      hex: color.hex ?? '',
    );
  }
}

class ColorTileView extends StatelessWidget {
  final void Function() onTap;
  final ColorTileViewState state;

  const ColorTileView({
    super.key,
    required this.onTap,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return _ItemTileView(
      onTap: onTap,
      title: state.title,
      numViews: state.numViews,
      numVotes: state.numVotes,
      child: ColorView(hex: state.hex),
    );
  }
}

@immutable
class PaletteTileViewState {
  final String title;
  final int numViews;
  final int numVotes;
  final List<String> hexs;
  final List<double> widths;

  const PaletteTileViewState({
    required this.title,
    required this.numViews,
    required this.numVotes,
    required this.hexs,
    required this.widths,
  });

  factory PaletteTileViewState.empty() {
    return const PaletteTileViewState(
      title: '',
      numViews: 0,
      numVotes: 0,
      hexs: [],
      widths: [],
    );
  }

  factory PaletteTileViewState.fromColourloverPalette(
    ColourloversPalette palette,
  ) {
    return PaletteTileViewState(
      title: palette.title ?? '',
      numViews: palette.numViews ?? 0,
      numVotes: palette.numVotes ?? 0,
      hexs: palette.colors ?? [],
      widths: palette.colorWidths ?? [],
    );
  }
}

class PaletteTileView extends StatelessWidget {
  final void Function() onTap;
  final PaletteTileViewState state;

  const PaletteTileView({
    super.key,
    required this.onTap,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return _ItemTileView(
      onTap: onTap,
      title: state.title,
      numViews: state.numViews,
      numVotes: state.numVotes,
      child: PaletteView(
        hexs: state.hexs,
        widths: state.widths,
      ),
    );
  }
}

@immutable
class PatternTileViewState {
  final String title;
  final int numViews;
  final int numVotes;
  final String imageUrl;

  const PatternTileViewState({
    required this.title,
    required this.numViews,
    required this.numVotes,
    required this.imageUrl,
  });

  factory PatternTileViewState.empty() {
    return const PatternTileViewState(
      title: '',
      numViews: 0,
      numVotes: 0,
      imageUrl: '',
    );
  }

  factory PatternTileViewState.fromColourloverPattern(
    ColourloversPattern pattern,
  ) {
    return PatternTileViewState(
      title: pattern.title ?? '',
      numViews: pattern.numViews ?? 0,
      numVotes: pattern.numVotes ?? 0,
      imageUrl: pattern.imageUrl ?? '',
    );
  }
}

class PatternTileView extends StatelessWidget {
  final void Function() onTap;
  final PatternTileViewState state;

  const PatternTileView({
    super.key,
    required this.onTap,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return _ItemTileView(
      onTap: onTap,
      title: state.title,
      numViews: state.numViews,
      numVotes: state.numVotes,
      child: PatternView(imageUrl: state.imageUrl),
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

@immutable
class UserTileViewState {
  final String userName;
  final int numColors;
  final int numPalettes;
  final int numPatterns;

  const UserTileViewState({
    required this.userName,
    required this.numColors,
    required this.numPalettes,
    required this.numPatterns,
  });

  factory UserTileViewState.empty() {
    return const UserTileViewState(
      userName: '',
      numColors: 0,
      numPalettes: 0,
      numPatterns: 0,
    );
  }

  factory UserTileViewState.fromColourloverUser(
    ColourloversLover user,
  ) {
    return UserTileViewState(
      userName: user.userName ?? '',
      numColors: user.numColors ?? 0,
      numPalettes: user.numPalettes ?? 0,
      numPatterns: user.numPatterns ?? 0,
    );
  }
}

class UserTileView extends StatelessWidget {
  final void Function() onTap;
  final UserTileViewState state;

  const UserTileView({
    super.key,
    required this.onTap,
    required this.state,
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
              color: Theme.of(context).colorScheme.inverseSurface,
              elevation: 4,
              child: Text(
                state.userName,
                // maxLines: 1,
                // overflow: TextOverflow.fade,
                // softWrap: false,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onInverseSurface,
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
                  text: state.numColors.toString(),
                  icon: LucideIcons.square,
                ),
                const SizedBox(width: 8),
                PillView(
                  text: state.numPalettes.toString(),
                  icon: LucideIcons.columns,
                ),
                const SizedBox(width: 8),
                PillView(
                  text: state.numPatterns.toString(),
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
