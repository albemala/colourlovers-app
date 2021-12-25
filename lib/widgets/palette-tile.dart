import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/widgets/item-tile.dart';
import 'package:colourlovers_app/widgets/palette.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PaletteTileWidget extends HookConsumerWidget {
  final ClPalette palette;

  const PaletteTileWidget({
    Key? key,
    required this.palette,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ItemTileWidget(
      onTap: () {
        // ref.read(routingProvider.notifier).showScreen(context, PaletteDetailsView(palette: palette));
      },
      title: palette.title,
      numViews: palette.numViews,
      numVotes: palette.numVotes,
      child: PaletteWidget(
        colors: palette.colors,
      ),
    );
  }
}
