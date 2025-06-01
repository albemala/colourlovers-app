import 'package:colourlovers_app/theme/text.dart';
import 'package:colourlovers_app/widgets/pill.dart';
import 'package:colourlovers_app/widgets/skewed-container.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ItemTileView extends StatelessWidget {
  final void Function() onTap;
  final String title;
  final int numViews;
  final int numVotes;
  final Widget child;

  const ItemTileView({
    super.key,
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
            child: InkWell(onTap: onTap),
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
                    color: Theme.of(context).colorScheme.onSurface,
                    elevation: 4,
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                      softWrap: false,
                      style: getItemTileTextStyle(context),
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
