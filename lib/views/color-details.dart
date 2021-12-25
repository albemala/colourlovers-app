import 'dart:math';

import 'package:boxicons/boxicons.dart';
import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/providers/item-provider.dart';
import 'package:colourlovers_app/providers/related-items-provider.dart';
import 'package:colourlovers_app/widgets/app-bar.dart';
import 'package:colourlovers_app/widgets/background.dart';
import 'package:colourlovers_app/widgets/color-tile.dart';
import 'package:colourlovers_app/widgets/color-value.dart';
import 'package:colourlovers_app/widgets/color.dart';
import 'package:colourlovers_app/widgets/h2-text.dart';
import 'package:colourlovers_app/widgets/palette-tile.dart';
import 'package:colourlovers_app/widgets/pattern-tile.dart';
import 'package:colourlovers_app/widgets/user-tile.dart';
import 'package:flutter/cupertino.dart';
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
      appBar: AppBarWidget(
        context,
        titleText: "Color",
      ),
      body: BackgroundWidget(
        colors: [
          Theme.of(context).backgroundColor,
          // TODO change based on current item
          const Color(0xFF881337),
          const Color(0xFF581C87),
        ],
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Text(
                  color?.title ?? "",
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 56,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: ColorWidget(hex: color?.hex ?? ""),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text(color?.numViews.toString() ?? ""),
                      const Icon(BoxIcons.glasses_regular),
                    ],
                  ),
                  Column(
                    children: [
                      Text(color?.numVotes.toString() ?? ""),
                      const Icon(BoxIcons.heart_regular),
                    ],
                  ),
                  Column(
                    children: [
                      Text(color?.rank.toString() ?? ""),
                      const Icon(BoxIcons.medal_regular),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 32),
              const H2TextWidget("Values"),
              const SizedBox(height: 16),
              ColorValueWidget(
                label: "R",
                value: color?.rgb?.red?.toDouble() ?? 0,
                minValue: 0,
                maxValue: 256,
                trackColors: const [Color(0xFF000000), Color(0xFFFF0000)],
              ),
              ColorValueWidget(
                label: "G",
                value: color?.rgb?.green?.toDouble() ?? 0,
                minValue: 0,
                maxValue: 256,
                trackColors: const [Color(0xFF000000), Color(0xFF00FF00)],
              ),
              ColorValueWidget(
                label: "B",
                value: color?.rgb?.blue?.toDouble() ?? 0,
                minValue: 0,
                maxValue: 256,
                trackColors: const [Color(0xFF000000), Color(0xFF0000FF)],
              ),
              const SizedBox(height: 16),
              ColorValueWidget(
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
              ColorValueWidget(
                label: "S",
                value: color?.hsv?.saturation?.toDouble() ?? 0,
                minValue: 0,
                maxValue: 100,
                trackColors: [
                  const Color(0xFF000000),
                  HSVColor.fromAHSV(1, color?.hsv?.hue?.toDouble() ?? 0, 1, 1).toColor()
                ],
              ),
              ColorValueWidget(
                label: "V",
                value: color?.hsv?.value?.toDouble() ?? 0,
                minValue: 0,
                maxValue: 100,
                trackColors: const [Color(0xFF000000), Color(0xFFFFFFFF)],
              ),
              const SizedBox(height: 32),
              const H2TextWidget("Created by"),
              const SizedBox(height: 16),
              user != null
                  ? UserTileWidget(
                      lover: user,
                    )
                  : Container(),
              const SizedBox(height: 32),
              const H2TextWidget("Related colors"),
              const SizedBox(height: 16),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: relatedColors?.length ?? 0,
                itemBuilder: (context, index) {
                  final color = relatedColors?.elementAt(index);
                  return color != null ? ColorTileWidget(color: color) : Container();
                },
                separatorBuilder: (context, index) => const SizedBox(height: 8),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {},
                child: const Text("Show more"),
              ),
              const SizedBox(height: 32),
              const H2TextWidget("Related palettes"),
              const SizedBox(height: 16),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: relatedPalettes?.length ?? 0,
                itemBuilder: (context, index) {
                  final palette = relatedPalettes?.elementAt(index);
                  return palette != null ? PaletteTileWidget(palette: palette) : Container();
                },
                separatorBuilder: (context, index) => const SizedBox(height: 8),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {},
                child: const Text("Show more"),
              ),
              const SizedBox(height: 32),
              const H2TextWidget("Related patterns"),
              const SizedBox(height: 16),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: relatedPatterns?.length ?? 0,
                itemBuilder: (context, index) {
                  final pattern = relatedPatterns?.elementAt(index);
                  return pattern != null ? PatternTileWidget(pattern: pattern) : Container();
                },
                separatorBuilder: (context, index) => const SizedBox(height: 8),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {},
                child: const Text("Show more"),
              ),
              const SizedBox(height: 32),
              const Text("This color on COLOURlovers.com"),
              const SizedBox(height: 16),
              const Text("Licensed under Attribution-Noncommercial-Share Alike"),
            ],
          ),
        ),
      ),
    );
  }
}
