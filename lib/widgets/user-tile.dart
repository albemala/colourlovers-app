import 'package:boxicons/boxicons.dart';
import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/widgets/pill.dart';
import 'package:colourlovers_app/widgets/skewed-container.dart';
import 'package:colourlovers_app/widgets/user.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class UserTileWidget extends HookConsumerWidget {
  final ClLover lover;

  const UserTileWidget({
    Key? key,
    required this.lover,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 72,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          SizedBox(
            width: double.maxFinite,
            child: Material(
              type: MaterialType.transparency,
              elevation: 12,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: const UserWidget(),
              ),
            ),
          ),
          Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: () {
                // ref.read(routingProvider.notifier).showScreen(context, ColorDetailsView(color: color));
              },
            ),
          ),
          Positioned(
            top: 8,
            left: -4,
            // right: 8,
            child: SkewedContainerWidget(
              padding: const EdgeInsets.fromLTRB(8, 4, 12, 4),
              color: Colors.white,
              elevation: 4,
              child: Text(
                lover.userName ?? "",
                // maxLines: 1,
                // overflow: TextOverflow.fade,
                // softWrap: false,
                style: Theme.of(context).textTheme.bodyText2?.copyWith(
                      color: Theme.of(context).backgroundColor,
                    ),
              ),
            ),
          ),
          Positioned(
            bottom: 8,
            left: 8,
            right: 8,
            child: Row(
              children: [
                PillWidget(
                  text: (lover.numColors ?? 0).toString(),
                  icon: BoxIcons.square_regular,
                ),
                const SizedBox(width: 8),
                PillWidget(
                  text: (lover.numPalettes ?? 0).toString(),
                  icon: BoxIcons.dock_left_regular,
                ),
                const SizedBox(width: 8),
                PillWidget(
                  text: (lover.numPatterns ?? 0).toString(),
                  icon: BoxIcons.grid_regular,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
