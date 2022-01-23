import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/assets/urls.dart';
import 'package:colourlovers_app/loaders/user-items.dart';
import 'package:colourlovers_app/utils/url.dart';
import 'package:colourlovers_app/widgets/app-bar.dart';
import 'package:colourlovers_app/widgets/background.dart';
import 'package:colourlovers_app/widgets/label-value.dart';
import 'package:colourlovers_app/widgets/link.dart';
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
    final userName = lover?.userName ?? '';

    final colors = loadUserColors(userName);
    final palettes = loadUserPalettes(userName);
    final patterns = loadUserPatterns(userName);

    return Scaffold(
      appBar: AppBarWidget(
        context,
        titleText: 'User',
      ),
      body: BackgroundWidget(
        colors: defaultBackgroundColors,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Text(
                  userName,
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
              Padding(
                padding: const EdgeInsets.only(top: 32),
                child: UserColorsWidgets(userName: userName, colors: colors),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 32),
                child: UserPalettesWidget(userName: userName, palettes: palettes),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 32),
                child: UserPatternsWidget(userName: userName, patterns: patterns),
              ),
              const SizedBox(height: 32),
              LinkWidget(
                text: 'This user on COLOURlovers.com',
                onTap: () {
                  openUrl('http://www.colourlovers.com/lover/${lover?.userName}');
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

String _formatDate(DateTime? date) {
  if (date == null) return '';
  return '${date.year}/${date.month}/${date.day}';
}
