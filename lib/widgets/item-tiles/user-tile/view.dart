import 'package:colourlovers_app/widgets/item-tiles/user-tile/view-state.dart';
import 'package:colourlovers_app/widgets/items/user.dart';
import 'package:colourlovers_app/widgets/pill.dart';
import 'package:colourlovers_app/widgets/skewed-container.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class UserTileView extends StatelessWidget {
  final void Function() onTap;
  final UserTileViewState state;

  const UserTileView({super.key, required this.onTap, required this.state});

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
            child: InkWell(onTap: onTap),
          ),
          Positioned(
            top: 8,
            left: -4,
            // right: 8,
            child: Row(
              children: [
                SkewedContainerView(
                  padding: const EdgeInsets.fromLTRB(8, 4, 12, 4),
                  color: Theme.of(context).colorScheme.onSurface,
                  elevation: 4,
                  child: Text(
                    state.userName,
                    // maxLines: 1,
                    // overflow: TextOverflow.fade,
                    // softWrap: false,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.surface,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
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
