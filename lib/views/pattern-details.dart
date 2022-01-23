import 'package:boxicons/boxicons.dart';
import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/assets/urls.dart';
import 'package:colourlovers_app/loaders/colors.dart';
import 'package:colourlovers_app/loaders/related-items.dart';
import 'package:colourlovers_app/loaders/user.dart';
import 'package:colourlovers_app/providers/providers.dart';
import 'package:colourlovers_app/utils/url.dart';
import 'package:colourlovers_app/views/share-pattern.dart';
import 'package:colourlovers_app/widgets/app-bar.dart';
import 'package:colourlovers_app/widgets/background.dart';
import 'package:colourlovers_app/widgets/h2-text.dart';
import 'package:colourlovers_app/widgets/item-button.dart';
import 'package:colourlovers_app/widgets/item-tiles.dart';
import 'package:colourlovers_app/widgets/link.dart';
import 'package:colourlovers_app/widgets/pattern.dart';
import 'package:colourlovers_app/widgets/related-items.dart';
import 'package:colourlovers_app/widgets/stats.dart';
import 'package:colourlovers_app/widgets/user-tile.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PatternDetailsView extends HookConsumerWidget {
  final ClPattern? pattern;

  const PatternDetailsView({
    Key? key,
    required this.pattern,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hex = pattern?.colors;

    final colors = loadColors(hex);
    final user = loadUser(pattern?.userName);
    final relatedPalettes = loadRelatedPalettes(hex);
    final relatedPatterns = loadRelatedPatterns(hex);

    return Scaffold(
      appBar: AppBarWidget(
        context,
        titleText: 'Pattern',
        actionWidgets: [
          IconButton(
            onPressed: () async {
              ref.read(routingProvider.notifier).showScreen(context, SharePatternView(pattern: pattern));
            },
            icon: const Icon(
              BoxIcons.bx_export_regular,
            ),
          ),
        ],
      ),
      body: BackgroundWidget(
        colors: hex?.map(HexColor.new).toList() ?? [],
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
              ItemButtonWidget(
                onTap: () {
                  ref.read(routingProvider.notifier).showScreen(context, SharePatternView(pattern: pattern));
                },
                child: PatternWidget(imageUrl: pattern?.imageUrl ?? ''),
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
                text: 'This pattern on COLOURlovers.com',
                onTap: () {
                  openUrl('https://www.colourlovers.com/pattern/${pattern?.id}');
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
