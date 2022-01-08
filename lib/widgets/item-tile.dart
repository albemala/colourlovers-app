import 'package:boxicons/boxicons.dart';
import 'package:colourlovers_app/widgets/pill.dart';
import 'package:colourlovers_app/widgets/skewed-container.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ItemTileWidget extends HookConsumerWidget {
  final void Function() onTap;
  final String? title;
  final int? numViews;
  final int? numVotes;
  final Widget child;

  const ItemTileWidget({
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
          SizedBox(
            width: double.maxFinite,
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
                      title ?? "",
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
