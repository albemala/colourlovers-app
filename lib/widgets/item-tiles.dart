import 'package:boxicons/boxicons.dart';
import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/providers/providers.dart';
import 'package:colourlovers_app/views/color-details.dart';
import 'package:colourlovers_app/views/palette-details.dart';
import 'package:colourlovers_app/views/pattern-details.dart';
import 'package:colourlovers_app/widgets/color.dart';
import 'package:colourlovers_app/widgets/palette.dart';
import 'package:colourlovers_app/widgets/pattern.dart';
import 'package:colourlovers_app/widgets/pill.dart';
import 'package:colourlovers_app/widgets/skewed-container.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ColorTileWidget extends HookConsumerWidget {
  final ClColor color;

  const ColorTileWidget({
    Key? key,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _ItemTileWidget(
      onTap: () {
        ref.read(routingProvider.notifier).showScreen(context, ColorDetailsView(color: color));
      },
      title: color.title,
      numViews: color.numViews,
      numVotes: color.numVotes,
      child: ColorWidget(hex: color.hex),
    );
  }
}

class PaletteTileWidget extends HookConsumerWidget {
  final ClPalette palette;

  const PaletteTileWidget({
    Key? key,
    required this.palette,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _ItemTileWidget(
      onTap: () {
        ref.read(routingProvider.notifier).showScreen(context, PaletteDetailsView(palette: palette));
      },
      title: palette.title,
      numViews: palette.numViews,
      numVotes: palette.numVotes,
      child: PaletteWidget(colors: palette.colors),
    );
  }
}

class PatternTileWidget extends HookConsumerWidget {
  final ClPattern pattern;

  const PatternTileWidget({
    Key? key,
    required this.pattern,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _ItemTileWidget(
      onTap: () {
        ref.read(routingProvider.notifier).showScreen(context, PatternDetailsView(pattern: pattern));
      },
      title: pattern.title,
      numViews: pattern.numViews,
      numVotes: pattern.numVotes,
      child: PatternWidget(imageUrl: pattern.imageUrl),
    );
  }
}

class _ItemTileWidget extends HookConsumerWidget {
  final void Function() onTap;
  final String? title;
  final int? numViews;
  final int? numVotes;
  final Widget child;

  const _ItemTileWidget({
    Key? key,
    required this.onTap,
    required this.title,
    required this.numViews,
    required this.numVotes,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 72,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          SizedBox.expand(
            child: Material(
              type: MaterialType.transparency,
              elevation: 12,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: child,
              ),
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
                  child: SkewedContainerWidget(
                    padding: const EdgeInsets.fromLTRB(8, 4, 12, 4),
                    color: Colors.white,
                    elevation: 4,
                    child: Text(
                      title ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                      softWrap: false,
                      style: Theme.of(context).textTheme.bodyText2?.copyWith(
                            color: Theme.of(context).backgroundColor,
                          ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    const SizedBox(width: 8),
                    PillWidget(
                      text: (numViews ?? 0).toString(),
                      icon: BoxIcons.bx_glasses_regular,
                    ),
                    const SizedBox(width: 8),
                    PillWidget(
                      text: (numVotes ?? 0).toString(),
                      icon: BoxIcons.bx_heart_regular,
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
