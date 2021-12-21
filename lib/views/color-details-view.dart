import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/providers.dart';
import 'package:colourlovers_app/widgets/color-value-view.dart';
import 'package:colourlovers_app/widgets/color-view.dart';
import 'package:colourlovers_app/widgets/user-tile-view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ColorDetailsView extends HookConsumerWidget {
  final ClColor? color;

  const ColorDetailsView({
    Key? key,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = useFuture(
      useMemoized(() async {
        final id = color?.userName ?? "";
        return await ref.read(userService).load(id);
      }),
      initialData: null,
    );
    final user = snapshot.data;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Color"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(color?.title ?? ""),
            SizedBox(
              height: 48,
              child: ColorView(hex: color?.hex ?? ""),
            ),
            Row(
              children: [
                Column(
                  children: [
                    Text(color?.numViews.toString() ?? ""),
                    Icon(Icons.remove_red_eye_outlined),
                  ],
                ),
                Column(
                  children: [
                    Text(color?.numVotes.toString() ?? ""),
                    Icon(Icons.favorite_border_outlined),
                  ],
                ),
                Column(
                  children: [
                    Text(color?.rank.toString() ?? ""),
                    Icon(Icons.military_tech_outlined),
                  ],
                ),
              ],
            ),
            Text("Values"),
            ColorValueView(
              label: "R",
              value: color?.rgb?.red?.toDouble() ?? 0,
              minValue: 0,
              maxValue: 256,
              trackColors: const [Color(0xFF000000), Color(0xFFFF0000)],
            ),
            ColorValueView(
              label: "G",
              value: color?.rgb?.green?.toDouble() ?? 0,
              minValue: 0,
              maxValue: 256,
              trackColors: const [Color(0xFF000000), Color(0xFF00FF00)],
            ),
            ColorValueView(
              label: "B",
              value: color?.rgb?.blue?.toDouble() ?? 0,
              minValue: 0,
              maxValue: 256,
              trackColors: const [Color(0xFF000000), Color(0xFF0000FF)],
            ),
            ColorValueView(
              label: "H",
              value: color?.hsv?.hue?.toDouble() ?? 0,
              minValue: 0,
              maxValue: 360,
              trackColors: const [
                Color(0xFFFF0000),
                Color(0xFFFFFF00),
                Color(0xFF00FF00),
                Color(0xFF00FFFF),
                Color(0xFF0000FF),
                Color(0xFFFF00FF),
                Color(0xFFFF0000),
              ],
            ),
            ColorValueView(
              label: "S",
              value: color?.hsv?.saturation?.toDouble() ?? 0,
              minValue: 0,
              maxValue: 100,
              trackColors: [
                const Color(0xFF000000),
                HSVColor.fromAHSV(1, color?.hsv?.hue?.toDouble() ?? 0, 1, 1).toColor()
              ],
            ),
            ColorValueView(
              label: "V",
              value: color?.hsv?.value?.toDouble() ?? 0,
              minValue: 0,
              maxValue: 100,
              trackColors: const [Color(0xFF000000), Color(0xFFFFFFFF)],
            ),
            Text("Created by"),
            user != null
                ? UserTileView(
                    lover: user,
                  )
                : Container(),
            Text("Related colors"),
            Text("Related palettes"),
            Text("This color on COLOURlovers.com"),
            Text("Licensed under Attribution-Noncommercial-Share Alike"),
          ],
        ),
      ),
    );
  }
}
