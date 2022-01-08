import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/assets/urls.dart';
import 'package:colourlovers_app/providers/related-item-providers.dart';
import 'package:colourlovers_app/providers/user-provider.dart';
import 'package:colourlovers_app/widgets/app-bar.dart';
import 'package:colourlovers_app/widgets/background.dart';
import 'package:colourlovers_app/widgets/color-tile.dart';
import 'package:colourlovers_app/widgets/color-value.dart';
import 'package:colourlovers_app/widgets/color.dart';
import 'package:colourlovers_app/widgets/h2-text.dart';
import 'package:colourlovers_app/widgets/link.dart';
import 'package:colourlovers_app/widgets/palette-tile.dart';
import 'package:colourlovers_app/widgets/pattern-tile.dart';
import 'package:colourlovers_app/widgets/related-items.dart';
import 'package:colourlovers_app/widgets/stats.dart';
import 'package:colourlovers_app/widgets/user-tile.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ColorDetailsView extends HookConsumerWidget {
  final ClColor? color;

  const ColorDetailsView({
    Key? key,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = getUser(color?.userName);
    final relatedColors = getRelatedColors(color?.hsv);
    final relatedPalettes = getRelatedPalettes([color?.hex ?? '']);
    final relatedPatterns = getRelatedPatterns([color?.hex ?? '']);

    return Scaffold(
      appBar: AppBarWidget(
        context,
        titleText: 'Color',
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
                  color?.title ?? '',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 56,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: ColorWidget(hex: color?.hex ?? ''),
                ),
              ),
              const SizedBox(height: 32),
              StatsWidget(
                stats: {
                  'Views': color?.numViews.toString() ?? '',
                  'Votes': color?.numVotes.toString() ?? '',
                  'Rank': color?.rank.toString() ?? '',
                },
              ),
              const SizedBox(height: 32),
              const H2TextWidget('Values'),
              const SizedBox(height: 16),
              ColorValueWidget(
                label: 'R',
                value: color?.rgb?.red?.toDouble() ?? 0,
                minValue: 0,
                maxValue: 256,
                trackColors: const [Color(0xFF000000), Color(0xFFFF0000)],
              ),
              ColorValueWidget(
                label: 'G',
                value: color?.rgb?.green?.toDouble() ?? 0,
                minValue: 0,
                maxValue: 256,
                trackColors: const [Color(0xFF000000), Color(0xFF00FF00)],
              ),
              ColorValueWidget(
                label: 'B',
                value: color?.rgb?.blue?.toDouble() ?? 0,
                minValue: 0,
                maxValue: 256,
                trackColors: const [Color(0xFF000000), Color(0xFF0000FF)],
              ),
              const SizedBox(height: 16),
              ColorValueWidget(
                label: 'H',
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
                label: 'S',
                value: color?.hsv?.saturation?.toDouble() ?? 0,
                minValue: 0,
                maxValue: 100,
                trackColors: [
                  const Color(0xFF000000),
                  HSVColor.fromAHSV(1, color?.hsv?.hue?.toDouble() ?? 0, 1, 1).toColor()
                ],
              ),
              ColorValueWidget(
                label: 'V',
                value: color?.hsv?.value?.toDouble() ?? 0,
                minValue: 0,
                maxValue: 100,
                trackColors: const [Color(0xFF000000), Color(0xFFFFFFFF)],
              ),
              const SizedBox(height: 32),
              const H2TextWidget('Created by'),
              const SizedBox(height: 16),
              user != null
                  ? UserTileWidget(
                      lover: user,
                    )
                  : Container(),
              relatedColors.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(top: 32),
                      child: RelatedItemsWidget<ClColor>(
                        title: 'Related colors',
                        items: relatedColors,
                        itemBuilder: (item) {
                          return ColorTileWidget(color: item);
                        },
                      ),
                    )
                  : Container(),
              relatedPalettes.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(top: 32),
                      child: RelatedItemsWidget<ClPalette>(
                        title: 'Related palettes',
                        items: relatedPalettes,
                        itemBuilder: (item) {
                          return PaletteTileWidget(palette: item);
                        },
                      ),
                    )
                  : Container(),
              relatedPatterns.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(top: 32),
                      child: RelatedItemsWidget<ClPattern>(
                        title: 'Related patterns',
                        items: relatedPatterns,
                        itemBuilder: (item) {
                          return PatternTileWidget(pattern: item);
                        },
                      ),
                    )
                  : Container(),
              const SizedBox(height: 32),
              LinkWidget(
                text: 'This color on COLOURlovers.com',
                onTap: () {
                  URLs.open('http://www.colourlovers.com/color/${color?.hex}');
                },
              ),
              const SizedBox(height: 16),
              LinkWidget(
                text: 'Licensed under Attribution-Noncommercial-Share Alike',
                onTap: () {
                  URLs.open(URLs.creativeCommons);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
