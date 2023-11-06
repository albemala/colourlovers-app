import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/defines/urls.dart';
import 'package:colourlovers_app/functions/related-items.dart';
import 'package:colourlovers_app/functions/url.dart';
import 'package:colourlovers_app/functions/user.dart';
import 'package:colourlovers_app/widgets/app-top-bar.dart';
import 'package:colourlovers_app/widgets/color-value.dart';
import 'package:colourlovers_app/widgets/h2-text.dart';
import 'package:colourlovers_app/widgets/item-button.dart';
import 'package:colourlovers_app/widgets/item-tiles.dart';
import 'package:colourlovers_app/widgets/items.dart';
import 'package:colourlovers_app/widgets/link.dart';
import 'package:colourlovers_app/widgets/related-items.dart';
import 'package:colourlovers_app/widgets/stats.dart';
import 'package:flutter/material.dart';
import 'package:flutter_state_management/flutter_state_management.dart';

class ColorRgbViewModel {
  final double red;
  final double green;
  final double blue;

  const ColorRgbViewModel({
    required this.red,
    required this.green,
    required this.blue,
  });

  factory ColorRgbViewModel.empty() {
    return const ColorRgbViewModel(
      red: 0,
      green: 0,
      blue: 0,
    );
  }

  factory ColorRgbViewModel.fromColourloverRgb(Rgb rgb) {
    return ColorRgbViewModel(
      red: rgb.red?.toDouble() ?? 0,
      green: rgb.green?.toDouble() ?? 0,
      blue: rgb.blue?.toDouble() ?? 0,
    );
  }
}

class ColorHsvViewModel {
  final double hue;
  final double saturation;
  final double value;

  const ColorHsvViewModel({
    required this.hue,
    required this.saturation,
    required this.value,
  });

  factory ColorHsvViewModel.empty() {
    return const ColorHsvViewModel(
      hue: 0,
      saturation: 0,
      value: 0,
    );
  }

  factory ColorHsvViewModel.fromColourloverHsv(Hsv hsv) {
    return ColorHsvViewModel(
      hue: hsv.hue?.toDouble() ?? 0,
      saturation: hsv.saturation?.toDouble() ?? 0,
      value: hsv.value?.toDouble() ?? 0,
    );
  }
}

class ColorDetailsViewModel {
  final String title;
  final String hex;
  final ColorRgbViewModel rgb;
  final ColorHsvViewModel hsv;
  final String numViews;
  final String numVotes;
  final String rank;
  final UserTileViewModel user;
  final List<ColorTileViewModel> relatedColors;
  final List<PaletteTileViewModel> relatedPalettes;
  final List<PatternTileViewModel> relatedPatterns;

  const ColorDetailsViewModel({
    required this.title,
    required this.hex,
    required this.rgb,
    required this.hsv,
    required this.numViews,
    required this.numVotes,
    required this.rank,
    required this.user,
    required this.relatedColors,
    required this.relatedPalettes,
    required this.relatedPatterns,
  });
}

class ColorDetailsViewConductor extends Conductor {
  factory ColorDetailsViewConductor.fromContext(
    BuildContext context, {
    required ColourloversColor color,
  }) {
    return ColorDetailsViewConductor(
      color,
      ColourloversApiClient(),
    );
  }

  final ColourloversColor color;
  final ColourloversApiClient client;
  final colorDetails = ValueNotifier<ColorDetailsViewModel?>(null);

  ColorDetailsViewConductor(
    this.color,
    this.client,
  ) {
    _init();
  }

  Future<void> _init() async {
    final user = color.userName != null
        ? await fetchUser(client, color.userName!)
        : null;
    final relatedColors = color.hsv != null
        ? await fetchRelatedColorsPreview(client, color.hsv!)
        : <ColourloversColor>[];
    final relatedPalettes = color.hex != null
        ? await fetchRelatedPalettesPreview(client, [color.hex!])
        : <ColourloversPalette>[];
    final relatedPatterns = color.hex != null
        ? await fetchRelatedPatternsPreview(client, [color.hex!])
        : <ColourloversPattern>[];

    colorDetails.value = ColorDetailsViewModel(
      title: color.title ?? '',
      hex: color.hex ?? '',
      rgb: color.rgb != null
          ? ColorRgbViewModel.fromColourloverRgb(color.rgb!)
          : ColorRgbViewModel.empty(),
      hsv: color.hsv != null
          ? ColorHsvViewModel.fromColourloverHsv(color.hsv!)
          : ColorHsvViewModel.empty(),
      numViews: (color.numViews ?? 0).toString(),
      numVotes: (color.numVotes ?? 0).toString(),
      rank: (color.rank ?? 0).toString(),
      user: user != null
          ? UserTileViewModel.fromColourloverUser(user)
          : UserTileViewModel.empty(),
      relatedColors: relatedColors //
          .map(ColorTileViewModel.fromColourloverColor)
          .toList(),
      relatedPalettes: relatedPalettes //
          .map(PaletteTileViewModel.fromColourloverPalette)
          .toList(),
      relatedPatterns: relatedPatterns //
          .map(PatternTileViewModel.fromColourloverPattern)
          .toList(),
    );
  }

  @override
  void dispose() {
    colorDetails.dispose();
  }
}

class ColorDetailsViewCreator extends StatelessWidget {
  final ColourloversColor color;

  const ColorDetailsViewCreator({
    super.key,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ConductorCreator(
      create: (context) {
        return ColorDetailsViewConductor.fromContext(
          context,
          color: color,
        );
      },
      child: ConductorConsumer<ColorDetailsViewConductor>(
        builder: (context, conductor) {
          return ColorDetailsView(
            conductor: conductor,
          );
        },
      ),
    );
  }
}

class ColorDetailsView extends StatelessWidget {
  final ColorDetailsViewConductor conductor;

  const ColorDetailsView({
    super.key,
    required this.conductor,
  });

  @override
  Widget build(BuildContext context) {
/*
    final hsv = color.hsv;
    final hex = [color.hex ?? ''];

    final user = loadUser(color.userName);
    final relatedColors = loadRelatedColors(hsv);
    final relatedPalettes = loadRelatedPalettes(hex);
    final relatedPatterns = loadRelatedPatterns(hex);
*/

    return Scaffold(
      appBar: AppTopBarView(
        context,
        title: 'Color',
        actions: [
/* TODO
          IconButton(
            onPressed: () async {
              ref
                  .read(routingProvider.notifier)
                  .showScreen(context, ShareColorView(color: color));
            },
            icon: const Icon(
              BoxIcons.bx_export_regular,
            ),
          ),
*/
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: conductor.colorDetails,
        builder: (context, colorDetails, child) {
          if (colorDetails == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Text(
                    colorDetails.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                const SizedBox(height: 16),
                ItemButtonView(
                  onTap: () {
                    // TODO
                    // ref
                    //     .read(routingProvider.notifier)
                    //     .showScreen(context, ShareColorView(color: color));
                  },
                  child: ColorView(hex: colorDetails.hex),
                ),
                const SizedBox(height: 32),
                StatsView(
                  stats: [
                    StatsItemViewModel(
                      label: 'Views',
                      value: colorDetails.numViews,
                    ),
                    StatsItemViewModel(
                      label: 'Votes',
                      value: colorDetails.numVotes,
                    ),
                    StatsItemViewModel(
                      label: 'Rank',
                      value: colorDetails.rank,
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                const H2TextView('Values'),
                const SizedBox(height: 16),
                ColorValueView(
                  label: 'R',
                  value: colorDetails.rgb.red,
                  minValue: 0,
                  maxValue: 256,
                  trackColors: const [Color(0xFF000000), Color(0xFFFF0000)],
                ),
                ColorValueView(
                  label: 'G',
                  value: colorDetails.rgb.green,
                  minValue: 0,
                  maxValue: 256,
                  trackColors: const [Color(0xFF000000), Color(0xFF00FF00)],
                ),
                ColorValueView(
                  label: 'B',
                  value: colorDetails.rgb.blue,
                  minValue: 0,
                  maxValue: 256,
                  trackColors: const [Color(0xFF000000), Color(0xFF0000FF)],
                ),
                const SizedBox(height: 16),
                ColorValueView(
                  label: 'H',
                  value: colorDetails.hsv.hue,
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
                  label: 'S',
                  value: colorDetails.hsv.saturation,
                  minValue: 0,
                  maxValue: 100,
                  trackColors: [
                    const Color(0xFF000000),
                    HSVColor.fromAHSV(1, colorDetails.hsv.hue, 1, 1).toColor()
                  ],
                ),
                ColorValueView(
                  label: 'V',
                  value: colorDetails.hsv.value,
                  minValue: 0,
                  maxValue: 100,
                  trackColors: const [Color(0xFF000000), Color(0xFFFFFFFF)],
                ),
                const SizedBox(height: 32),
                const H2TextView('Created by'),
                const SizedBox(height: 16),
                UserTileView(
                  viewModel: colorDetails.user,
                  onTap: () {
                    // TODO
                    // ref
                    //     .read(routingProvider.notifier)
                    //     .showScreen(context, UserView(user: user));
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 32),
                  child: RelatedColorsView(
                    // hsv: colorDetails.hsv,
                    viewModels: colorDetails.relatedColors,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 32),
                  child: RelatedPalettesView(
                    // hexs: colorDetails.hexs,
                    viewModels: colorDetails.relatedPalettes,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 32),
                  child: RelatedPatternsView(
                    // hexs: colorDetails.hexs,
                    viewModels: colorDetails.relatedPatterns,
                  ),
                ),
                const SizedBox(height: 32),
                LinkView(
                  text: 'This color on COLOURlovers.com',
                  onTap: () {
                    openUrl(
                        'https://www.colourlovers.com/color/${colorDetails.hex}');
                  },
                ),
                const SizedBox(height: 16),
                LinkView(
                  text: 'Licensed under Attribution-Noncommercial-Share Alike',
                  onTap: () {
                    openUrl(creativeCommonsUrl);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
