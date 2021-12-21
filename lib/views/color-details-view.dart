import 'dart:math';

import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/providers/item-provider.dart';
import 'package:colourlovers_app/providers/related-items-provider.dart';
import 'package:colourlovers_app/widgets/color-tile-view.dart';
import 'package:colourlovers_app/widgets/color-value-view.dart';
import 'package:colourlovers_app/widgets/color-view.dart';
import 'package:colourlovers_app/widgets/palette-tile-view.dart';
import 'package:colourlovers_app/widgets/pattern-tile-view.dart';
import 'package:colourlovers_app/widgets/user-tile-view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ColorDetailsView extends HookConsumerWidget {
  final ClColor? color;

  late final StateNotifierProvider<ItemProvider<ClLover>, ClLover?> _userProvider;
  late final StateNotifierProvider<RelatedItemsProvider<ClColor>, List<ClColor>> _relatedColorsProvider;
  late final StateNotifierProvider<RelatedItemsProvider<ClPalette>, List<ClPalette>> _relatedPalettesProvider;
  late final StateNotifierProvider<RelatedItemsProvider<ClPattern>, List<ClPattern>> _relatedPatternsProvider;

  ColorDetailsView({
    Key? key,
    required this.color,
  }) : super(key: key) {
    _userProvider = StateNotifierProvider<ItemProvider<ClLover>, ClLover?>((ref) {
      return ItemProvider(
        (client) async {
          final userName = color?.userName ?? "";
          return await client.getLover(userName: userName);
        },
      );
    });
    _relatedColorsProvider = StateNotifierProvider<RelatedItemsProvider<ClColor>, List<ClColor>>((ref) {
      return RelatedItemsProvider(
        (client, numResults) async {
          final hue = color?.hsv?.hue ?? 0;
          final value = color?.hsv?.value ?? 0;
          const delta = 20;
          return await client.getTopColors(
            hueMin: max(0, hue - delta),
            hueMax: min(359, hue + delta),
            brightnessMin: max(0, value - delta),
            brightnessMax: min(99, value + delta),
            numResults: numResults,
          );
        },
      );
    });
    _relatedPalettesProvider = StateNotifierProvider<RelatedItemsProvider<ClPalette>, List<ClPalette>>((ref) {
      return RelatedItemsProvider(
        (client, numResults) async {
          final hex = color?.hex ?? "";
          return await client.getTopPalettes(
            hex: [hex],
            numResults: numResults,
          );
        },
      );
    });
    _relatedPatternsProvider = StateNotifierProvider<RelatedItemsProvider<ClPattern>, List<ClPattern>>((ref) {
      return RelatedItemsProvider(
        (client, numResults) async {
          final hex = color?.hex ?? "";
          return await client.getTopPatterns(
            hex: [hex],
            numResults: numResults,
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userSnapshot = useFuture(
      useMemoized(() async {
        await ref.read(_userProvider.notifier).load();
        return ref.read(_userProvider);
      }),
      initialData: null,
    );
    final user = userSnapshot.data;

    final relatedColorsSnapshot = useFuture(
      useMemoized(() async {
        await ref.read(_relatedColorsProvider.notifier).load();
        return ref.read(_relatedColorsProvider);
      }),
      initialData: null,
    );
    final relatedColors = relatedColorsSnapshot.data;

    final relatedPalettesSnapshot = useFuture(
      useMemoized(() async {
        await ref.read(_relatedPalettesProvider.notifier).load();
        return ref.read(_relatedPalettesProvider);
      }),
      initialData: null,
    );
    final relatedPalettes = relatedPalettesSnapshot.data;

    final relatedPatternsSnapshot = useFuture(
      useMemoized(() async {
        await ref.read(_relatedPatternsProvider.notifier).load();
        return ref.read(_relatedPatternsProvider);
      }),
      initialData: null,
    );
    final relatedPatterns = relatedPatternsSnapshot.data;

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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
            ...relatedColors?.map((color) => ColorTileView(color: color)).toList() ?? [],
            TextButton(
              onPressed: () {},
              child: Text("Show more"),
            ),
            Text("Related palettes"),
            ...relatedPalettes?.map((palette) => PaletteTileView(palette: palette)).toList() ?? [],
            TextButton(
              onPressed: () {},
              child: Text("Show more"),
            ),
            Text("Related patterns"),
            ...relatedPatterns?.map((pattern) => PatternTileView(pattern: pattern)).toList() ?? [],
            TextButton(
              onPressed: () {},
              child: Text("Show more"),
            ),
            Text("This color on COLOURlovers.com"),
            Text("Licensed under Attribution-Noncommercial-Share Alike"),
          ],
        ),
      ),
    );
  }
}
