import 'package:boxicons/boxicons.dart';
import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/assets/urls.dart';
import 'package:colourlovers_app/loaders/related-items.dart';
import 'package:colourlovers_app/loaders/user.dart';
import 'package:colourlovers_app/providers/providers.dart';
import 'package:colourlovers_app/utils/url.dart';
import 'package:colourlovers_app/views/share-color.dart';
import 'package:colourlovers_app/widgets/app-bar.dart';
import 'package:colourlovers_app/widgets/background.dart';
import 'package:colourlovers_app/widgets/color-value.dart';
import 'package:colourlovers_app/widgets/color.dart';
import 'package:colourlovers_app/widgets/h2-text.dart';
import 'package:colourlovers_app/widgets/item-button.dart';
import 'package:colourlovers_app/widgets/link.dart';
import 'package:colourlovers_app/widgets/related-items.dart';
import 'package:colourlovers_app/widgets/stats.dart';
import 'package:colourlovers_app/widgets/user-tile.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ColorDetailsView extends HookConsumerWidget {
  final ClColor? color;

  const ColorDetailsView({
    Key? key,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hsv = color?.hsv;
    final hex = [color?.hex ?? ''];

    final user = loadUser(color?.userName);
    final relatedColors = loadRelatedColors(hsv);
    final relatedPalettes = loadRelatedPalettes(hex);
    final relatedPatterns = loadRelatedPatterns(hex);

    return Scaffold(
      appBar: AppBarWidget(
        context,
        titleText: 'Color',
        actionWidgets: [
          IconButton(
            onPressed: () async {
              ref.read(routingProvider.notifier).showScreen(context, ShareColorView(color: color));
            },
            icon: const Icon(
              BoxIcons.bx_export_regular,
            ),
          ),
        ],
      ),
      body: BackgroundWidget(
        colors: [
          HexColor(color?.hex ?? ''),
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
              ItemButtonWidget(
                onTap: () {
                  ref.read(routingProvider.notifier).showScreen(context, ShareColorView(color: color));
                },
                child: ColorWidget(hex: color?.hex ?? ''),
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
                value: hsv?.hue?.toDouble() ?? 0,
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
                value: hsv?.saturation?.toDouble() ?? 0,
                minValue: 0,
                maxValue: 100,
                trackColors: [const Color(0xFF000000), HSVColor.fromAHSV(1, hsv?.hue?.toDouble() ?? 0, 1, 1).toColor()],
              ),
              ColorValueWidget(
                label: 'V',
                value: hsv?.value?.toDouble() ?? 0,
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
              Padding(
                padding: const EdgeInsets.only(top: 32),
                child: RelatedColorsWidget(
                  hsv: hsv,
                  relatedColors: relatedColors,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 32),
                child: RelatedPalettesWidget(
                  hex: hex,
                  relatedPalettes: relatedPalettes,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 32),
                child: RelatedPatternsWidget(
                  hex: hex,
                  relatedPatterns: relatedPatterns,
                ),
              ),
              const SizedBox(height: 32),
              LinkWidget(
                text: 'This color on COLOURlovers.com',
                onTap: () {
                  openUrl('https://www.colourlovers.com/color/${color?.hex}');
                },
              ),
              const SizedBox(height: 16),
              LinkWidget(
                text: 'Licensed under Attribution-Noncommercial-Share Alike',
                onTap: () {
                  openUrl(URLs.creativeCommons);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
