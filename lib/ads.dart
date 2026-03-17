import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_utils/flutter_utils.dart';

final List<AdData> allAdsData = [
  exaboxAdData,
  hexeeProAdData,
  paletteConverterAdData,
  wmapAdData,
  iroIroAdData,
  ejimoAdData,
  // luvAdData,
  catIdentifierAdData,
  textmineAdData,
  clarityAdData,
];

AdData selectRandomAdData() {
  final random = Random();
  return allAdsData[random.nextInt(allAdsData.length)];
}

class AdView extends StatelessWidget {
  final AdData adData;

  const AdView({super.key, required this.adData});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 12,
          children: [
            Row(
              // crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 16,
              children: [
                DecoratedBox(
                  decoration: ShapeDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    shape: const CircleBorder(),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: ClipOval(
                      child: Image.asset(
                        adData.iconAssetPath,
                        width: 32,
                        height: 32,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 8,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            adData.overline.toUpperCase(),
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                          Text(
                            adData.title,
                            style: Theme.of(context).textTheme.titleMedium,
                            softWrap: true,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Text(
              adData.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            OutlinedButton(
              onPressed: () => openUrl(adData.url),
              child: const Text('Learn more'),
            ),
          ],
        ),
      ),
    );
  }
}
