import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/color-details/view-controller.dart';
import 'package:colourlovers_app/color-details/view-state.dart';
import 'package:colourlovers_app/urls/defines.dart';
import 'package:colourlovers_app/widgets/app-bar.dart';
import 'package:colourlovers_app/widgets/background/view.dart';
import 'package:colourlovers_app/widgets/color-channel.dart';
import 'package:colourlovers_app/widgets/created-by.dart';
import 'package:colourlovers_app/widgets/credits.dart';
import 'package:colourlovers_app/widgets/details-header.dart';
import 'package:colourlovers_app/widgets/icon-buttons.dart';
import 'package:colourlovers_app/widgets/item-tiles/color-tile/view.dart';
import 'package:colourlovers_app/widgets/item-tiles/palette-tile/view.dart';
import 'package:colourlovers_app/widgets/item-tiles/pattern-tile/view.dart';
import 'package:colourlovers_app/widgets/items/color.dart';
import 'package:colourlovers_app/widgets/related-items-preview.dart';
import 'package:colourlovers_app/widgets/stats.dart';
import 'package:colourlovers_app/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ColorDetailsViewCreator extends StatelessWidget {
  final ColourloversColor color;

  const ColorDetailsViewCreator({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return ColorDetailsViewController.fromContext(context, color: color);
      },
      child: BlocBuilder<ColorDetailsViewController, ColorDetailsViewState>(
        builder: (context, state) {
          return ColorDetailsView(
            state: state,
            controller: context.read<ColorDetailsViewController>(),
          );
        },
      ),
    );
  }
}

class ColorDetailsView extends StatelessWidget {
  final ColorDetailsViewState state;
  final ColorDetailsViewController controller;

  const ColorDetailsView({
    super.key,
    required this.state,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarView(
        context,
        title: 'Color',
        actions: [
          ShareItemButton(
            onPressed: () {
              controller.showShareColorView(context);
            },
          ),
        ],
      ),
      body: BackgroundView(
        blobs: state.backgroundBlobs.toList(),
        child:
            state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 32,
                  ),
                  child: Column(
                    spacing: 32,
                    children: [
                      DetailsHeaderView(
                        title: state.title,
                        item: ColorView(hex: state.hex),
                        onItemTap: () {
                          controller.showShareColorView(context);
                        },
                      ),
                      StatsView(
                        stats: [
                          StatsItemViewState(
                            label: 'Views',
                            value: state.numViews,
                          ),
                          StatsItemViewState(
                            label: 'Votes',
                            value: state.numVotes,
                          ),
                          StatsItemViewState(label: 'Rank', value: state.rank),
                        ],
                      ),
                      _ColorValuesView(rgb: state.rgb, hsv: state.hsv),
                      CreatedByView(
                        user: state.user,
                        onUserTap: () {
                          controller.showUserDetailsView(context);
                        },
                      ),
                      if (state.relatedColors.isNotEmpty)
                        RelatedItemsPreviewView(
                          title: 'Related colors',
                          items: state.relatedColors.toList(),
                          itemBuilder: (state) {
                            return ColorTileView(
                              state: state,
                              onTap: () {
                                controller.showColorDetailsView(context, state);
                              },
                            );
                          },
                          onShowMorePressed: () {
                            controller.showRelatedColorsView(context);
                          },
                        ),
                      if (state.relatedPalettes.isNotEmpty)
                        RelatedItemsPreviewView(
                          title: 'Related palettes',
                          items: state.relatedPalettes.toList(),
                          itemBuilder: (state) {
                            return PaletteTileView(
                              state: state,
                              onTap: () {
                                controller.showPaletteDetailsView(
                                  context,
                                  state,
                                );
                              },
                            );
                          },
                          onShowMorePressed: () {
                            controller.showRelatedPalettesView(context);
                          },
                        ),
                      if (state.relatedPatterns.isNotEmpty)
                        RelatedItemsPreviewView(
                          title: 'Related patterns',
                          items: state.relatedPatterns.toList(),
                          itemBuilder: (state) {
                            return PatternTileView(
                              state: state,
                              onTap: () {
                                controller.showPatternDetailsView(
                                  context,
                                  state,
                                );
                              },
                            );
                          },
                          onShowMorePressed: () {
                            controller.showRelatedPatternsView(context);
                          },
                        ),
                      CreditsView(
                        itemName: 'color',
                        itemUrl: '$colourLoversUrl/color/${state.hex}',
                      ),
                    ],
                  ),
                ),
      ),
    );
  }
}

class _ColorValuesView extends StatelessWidget {
  final ColorRgbViewState rgb;
  final ColorHsvViewState hsv;

  const _ColorValuesView({required this.rgb, required this.hsv});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 16,
      children: [
        const H2TextView('Values'),
        Column(
          children: [
            ColorChannelView(
              label: 'R',
              value: rgb.red,
              minValue: 0,
              maxValue: 256,
              trackColors: const [Color(0xFF000000), Color(0xFFFF0000)],
            ),
            ColorChannelView(
              label: 'G',
              value: rgb.green,
              minValue: 0,
              maxValue: 256,
              trackColors: const [Color(0xFF000000), Color(0xFF00FF00)],
            ),
            ColorChannelView(
              label: 'B',
              value: rgb.blue,
              minValue: 0,
              maxValue: 256,
              trackColors: const [Color(0xFF000000), Color(0xFF0000FF)],
            ),
          ],
        ),
        Column(
          children: [
            ColorChannelView(
              label: 'H',
              value: hsv.hue,
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
            ColorChannelView(
              label: 'S',
              value: hsv.saturation,
              minValue: 0,
              maxValue: 100,
              trackColors: [
                const Color(0xFF000000),
                HSVColor.fromAHSV(1, hsv.hue, 1, 1).toColor(),
              ],
            ),
            ColorChannelView(
              label: 'V',
              value: hsv.value,
              minValue: 0,
              maxValue: 100,
              trackColors: const [Color(0xFF000000), Color(0xFFFFFFFF)],
            ),
          ],
        ),
      ],
    );
  }
}
