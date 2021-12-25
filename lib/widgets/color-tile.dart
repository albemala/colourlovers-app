import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/providers/providers.dart';
import 'package:colourlovers_app/views/color-details.dart';
import 'package:colourlovers_app/widgets/color.dart';
import 'package:colourlovers_app/widgets/item-tile.dart';
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
    return ItemTileWidget(
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
