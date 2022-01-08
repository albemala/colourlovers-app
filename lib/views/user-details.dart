import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/assets/urls.dart';
import 'package:colourlovers_app/providers/user-item-providers.dart';
import 'package:colourlovers_app/widgets/app-bar.dart';
import 'package:colourlovers_app/widgets/background.dart';
import 'package:colourlovers_app/widgets/color-tile.dart';
import 'package:colourlovers_app/widgets/label-value.dart';
import 'package:colourlovers_app/widgets/link.dart';
import 'package:colourlovers_app/widgets/palette-tile.dart';
import 'package:colourlovers_app/widgets/pattern-tile.dart';
import 'package:colourlovers_app/widgets/related-items.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class UserDetailsView extends HookConsumerWidget {
  final ClLover? lover;

  const UserDetailsView({
    Key? key,
    required this.lover,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = getUserColors(lover?.userName ?? '');
    final palettes = getUserPalettes(lover?.userName ?? '');
    final patterns = getUserPatterns(lover?.userName ?? '');

    return Scaffold(
      appBar: AppBarWidget(
        context,
        titleText: 'User',
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
                  lover?.userName ?? '',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              const SizedBox(height: 32),
              LabelValueWidget(label: 'Colors', value: lover?.numColors.toString() ?? ''),
              LabelValueWidget(label: 'Palettes', value: lover?.numPalettes.toString() ?? ''),
              LabelValueWidget(label: 'Patterns', value: lover?.numPatterns.toString() ?? ''),
              const SizedBox(height: 8),
              LabelValueWidget(label: 'Rating', value: lover?.rating.toString() ?? ''),
              LabelValueWidget(label: 'Lovers', value: lover?.numLovers.toString() ?? ''),
              const SizedBox(height: 8),
              LabelValueWidget(label: 'Location', value: lover?.location ?? ''),
              LabelValueWidget(label: 'Registered', value: _formatDate(lover?.dateRegistered)),
              LabelValueWidget(label: 'Last Active', value: _formatDate(lover?.dateLastActive)),
              colors.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(top: 32),
                      child: RelatedItemsWidget<ClColor>(
                        title: 'Colors',
                        items: colors,
                        itemBuilder: (item) {
                          return ColorTileWidget(color: item);
                        },
                      ),
                    )
                  : Container(),
              palettes.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(top: 32),
                      child: RelatedItemsWidget<ClPalette>(
                        title: 'Palettes',
                        items: palettes,
                        itemBuilder: (item) {
                          return PaletteTileWidget(palette: item);
                        },
                      ),
                    )
                  : Container(),
              patterns.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(top: 32),
                      child: RelatedItemsWidget<ClPattern>(
                        title: 'Patterns',
                        items: patterns,
                        itemBuilder: (item) {
                          return PatternTileWidget(pattern: item);
                        },
                      ),
                    )
                  : Container(),
              const SizedBox(height: 32),
              LinkWidget(
                text: 'This user on COLOURlovers.com',
                onTap: () {
                  URLs.open('http://www.colourlovers.com/lover/${lover?.userName}');
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

String _formatDate(DateTime? date) {
  if (date == null) return '';
  return '${date.year}/${date.month}/${date.day}';
}
