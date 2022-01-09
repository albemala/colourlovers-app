import 'package:boxicons/boxicons.dart';
import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/assets/urls.dart';
import 'package:colourlovers_app/providers/colors-provider.dart';
import 'package:colourlovers_app/providers/providers.dart';
import 'package:colourlovers_app/providers/related-item-providers.dart';
import 'package:colourlovers_app/providers/user-provider.dart';
import 'package:colourlovers_app/utils/url.dart';
import 'package:colourlovers_app/views/share-palette.dart';
import 'package:colourlovers_app/widgets/app-bar.dart';
import 'package:colourlovers_app/widgets/background.dart';
import 'package:colourlovers_app/widgets/color-tile.dart';
import 'package:colourlovers_app/widgets/h2-text.dart';
import 'package:colourlovers_app/widgets/item-button.dart';
import 'package:colourlovers_app/widgets/link.dart';
import 'package:colourlovers_app/widgets/palette-tile.dart';
import 'package:colourlovers_app/widgets/palette.dart';
import 'package:colourlovers_app/widgets/pattern-tile.dart';
import 'package:colourlovers_app/widgets/related-items.dart';
import 'package:colourlovers_app/widgets/stats.dart';
import 'package:colourlovers_app/widgets/user-tile.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PaletteDetailsView extends HookConsumerWidget {
  final ClPalette? palette;

  const PaletteDetailsView({
    Key? key,
    required this.palette,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = getColors(palette?.colors);
    final user = getUser(palette?.userName);
    final relatedPalettes = getRelatedPalettes(palette?.colors);
    final relatedPatterns = getRelatedPatterns(palette?.colors);

    return Scaffold(
      appBar: AppBarWidget(
        context,
        titleText: 'Palette',
        actionWidgets: [
          IconButton(
            onPressed: () async {
              ref.read(routingProvider.notifier).showScreen(context, SharePaletteView(palette: palette));
            },
            icon: const Icon(
              BoxIcons.bx_export_regular,
            ),
          ),
        ],
      ),
      body: BackgroundWidget(
        colors: palette?.colors?.map(HexColor.new).toList() ?? [],
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Text(
                  palette?.title ?? '',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              const SizedBox(height: 16),
              ItemButtonWidget(
                onTap: () async {
                  ref.read(routingProvider.notifier).showScreen(context, SharePaletteView(palette: palette));
                },
                child: PaletteWidget(colors: palette?.colors ?? []),
              ),
              const SizedBox(height: 32),
              StatsWidget(
                stats: {
                  'Views': palette?.numViews.toString() ?? '',
                  'Votes': palette?.numVotes.toString() ?? '',
                  'Rank': palette?.rank.toString() ?? '',
                },
              ),
              const SizedBox(height: 32),
              const H2TextWidget('Colors'),
              const SizedBox(height: 16),
              colors.isNotEmpty
                  ? ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: colors.length,
                      itemBuilder: (context, index) {
                        final color = colors.elementAt(index);
                        return color != null ? ColorTileWidget(color: color) : Container();
                      },
                      separatorBuilder: (context, index) => const SizedBox(height: 8),
                    )
                  : Container(),
              const SizedBox(height: 32),
              const H2TextWidget('Created by'),
              const SizedBox(height: 16),
              user != null
                  ? UserTileWidget(
                      lover: user,
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
                text: 'This palette on COLOURlovers.com',
                onTap: () {
                  openUrl('http://www.colourlovers.com/palette/${palette?.id}');
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
