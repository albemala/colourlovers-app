import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/widgets/items.dart';
import 'package:colourlovers_app/widgets/pill.dart';
import 'package:colourlovers_app/widgets/skewed-container.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

// TODO create view models for each item type

class ColorTileView extends StatelessWidget {
  final ColourloversColor color;
  final void Function() onTap;

  const ColorTileView({
    super.key,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return _ItemTileView(
      onTap: onTap,
      title: color.title ?? '',
      numViews: color.numViews ?? 0,
      numVotes: color.numVotes ?? 0,
      child: ColorView(colorHex: color.hex ?? '0'),
    );
  }
}

class PaletteTileView extends StatelessWidget {
  final ColourloversPalette palette;
  final void Function() onTap;

  const PaletteTileView({
    super.key,
    required this.palette,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return _ItemTileView(
      onTap: onTap,
      title: palette.title ?? '',
      numViews: palette.numViews ?? 0,
      numVotes: palette.numVotes ?? 0,
      child: PaletteView(colorsHex: palette.colors ?? []),
    );
  }
}

class PatternTileView extends StatelessWidget {
  final ColourloversPattern pattern;
  final void Function() onTap;

  const PatternTileView({
    super.key,
    required this.pattern,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return _ItemTileView(
      onTap: onTap,
      title: pattern.title ?? '',
      numViews: pattern.numViews ?? 0,
      numVotes: pattern.numVotes ?? 0,
      child: PatternView(imageUrl: pattern.imageUrl ?? ''),
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

class UserTileView extends StatelessWidget {
  final ColourloversLover lover;
  final void Function() onTap;

  const UserTileView({
    super.key,
    required this.lover,
    required this.onTap,
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
                lover.userName ?? '',
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
                  text: (lover.numColors ?? 0).toString(),
                  icon: LucideIcons.square,
                ),
                const SizedBox(width: 8),
                PillView(
                  text: (lover.numPalettes ?? 0).toString(),
                  icon: LucideIcons.columns,
                ),
                const SizedBox(width: 8),
                PillView(
                  text: (lover.numPatterns ?? 0).toString(),
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
