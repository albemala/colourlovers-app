import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/providers/providers.dart';
import 'package:colourlovers_app/views/color-details-view.dart';
import 'package:colourlovers_app/widgets/color-view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ColorTileView extends HookConsumerWidget {
  final ClColor color;

  const ColorTileView({
    Key? key,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      child: InkWell(
        onTap: () {
          ref.read(routingProvider.notifier).showScreen(context, ColorDetailsView(color: color));
        },
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 48,
                child: ColorView(hex: color.hex ?? ""),
              ),
            ),
            Text(color.title ?? ""),
          ],
        ),
      ),
    );
  }
}
