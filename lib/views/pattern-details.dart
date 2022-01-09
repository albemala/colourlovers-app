import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/assets/urls.dart';
import 'package:colourlovers_app/providers/colors-provider.dart';
import 'package:colourlovers_app/providers/related-item-providers.dart';
import 'package:colourlovers_app/providers/user-provider.dart';
import 'package:colourlovers_app/widgets/app-bar.dart';
import 'package:colourlovers_app/widgets/background.dart';
import 'package:colourlovers_app/widgets/color-tile.dart';
import 'package:colourlovers_app/widgets/h2-text.dart';
import 'package:colourlovers_app/widgets/link.dart';
import 'package:colourlovers_app/widgets/palette-tile.dart';
import 'package:colourlovers_app/widgets/pattern-tile.dart';
import 'package:colourlovers_app/widgets/pattern.dart';
import 'package:colourlovers_app/widgets/related-items.dart';
import 'package:colourlovers_app/widgets/stats.dart';
import 'package:colourlovers_app/widgets/user-tile.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PatternDetailsView extends HookConsumerWidget {
  final ClPattern? pattern;

  const PatternDetailsView({
    Key? key,
    required this.pattern,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = getColors(pattern?.colors);
    final user = getUser(pattern?.userName);
    final relatedPalettes = getRelatedPalettes(pattern?.colors);
    final relatedPatterns = getRelatedPatterns(pattern?.colors);

    return Scaffold(
      appBar: AppBarWidget(
        context,
        titleText: 'Pattern',
      ),
      body: BackgroundWidget(
        colors: pattern?.colors?.map(HexColor.new).toList() ?? [],
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Text(
                  pattern?.title ?? '',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 56,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: PatternWidget(imageUrl: pattern?.imageUrl ?? ''),
                ),
              ),
              const SizedBox(height: 32),
              StatsWidget(
                stats: {
                  'Views': pattern?.numViews.toString() ?? '',
                  'Votes': pattern?.numVotes.toString() ?? '',
                  'Rank': pattern?.rank.toString() ?? '',
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
                text: 'This pattern on COLOURlovers.com',
                onTap: () {
                  URLs.open('http://www.colourlovers.com/pattern/${pattern?.id}');
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
