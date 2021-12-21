import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/widgets/palette-view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PaletteTileView extends HookConsumerWidget {
  final ClPalette palette;

  const PaletteTileView({
    Key? key,
    required this.palette,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      child: InkWell(
        onTap: () {
          // ref.read(routingProvider.notifier).showScreen(context, const ColorView(color: color));
        },
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 48,
                child: PaletteView(
                  colors: palette.colors ?? [],
                  widths: palette.colorWidths ?? [],
                ),
              ),
            ),
            Text(palette.title ?? ""),
          ],
        ),
      ),
    );
  }
}
