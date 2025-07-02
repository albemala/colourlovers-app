import 'dart:math';

import 'package:colourlovers_app/urls/defines.dart';
import 'package:colourlovers_app/urls/functions.dart';
import 'package:flutter/material.dart';

enum AdType { ejimo, hexee, wmap, iroiro, upc, none }

AdType selectRandomAdType({required bool includeNoneType}) {
  final maxIndex =
      includeNoneType ? AdType.values.length : AdType.values.length - 1;
  final index = Random().nextInt(maxIndex);
  return AdType.values[index];
}

class AdView extends StatelessWidget {
  final AdType adType;

  const AdView({super.key, required this.adType});

  @override
  Widget build(BuildContext context) {
    switch (adType) {
      case AdType.ejimo:
        return const EjimoAdView();
      case AdType.hexee:
        return const HexeeProAdView();
      case AdType.wmap:
        return const WMapAdView();
      case AdType.iroiro:
        return const IroIronAdView();
      case AdType.upc:
        return const UpcAdView();
      case AdType.none:
        return Container(); // Return an empty container for none type
    }
  }
}

class HexeeProAdView extends StatelessWidget {
  const HexeeProAdView({super.key});

  @override
  Widget build(BuildContext context) {
    return _BaseAdView(
      iconAssetPath: 'assets/images/hexee-pro-icon.png',
      overline: 'Are you a designer or artist?',
      title: 'Hexee Pro: Advanced palette & color tools',
      description: '''
Hexee Pro is the ultimate palette editor and color tool for designers and artists. If you're tired of switching between multiple apps to work with colors, Hexee Pro is the perfect solution for you.''',
      onLearnMore: () {
        openUrl(hexeeWebsiteUrl);
      },
    );
  }
}

class WMapAdView extends StatelessWidget {
  const WMapAdView({super.key});

  @override
  Widget build(BuildContext context) {
    return _BaseAdView(
      iconAssetPath: 'assets/images/wmap-icon.png',
      overline: 'Your world, your wallpaper',
      title: 'WMap: Map Wallpapers & Backgrounds',
      description: '''
Create beautiful, minimal, custom map wallpapers and backgrounds for your phone or tablet.''',
      onLearnMore: () {
        openUrl(wmapWebsiteUrl);
      },
    );
  }
}

class IroIronAdView extends StatelessWidget {
  const IroIronAdView({super.key});

  @override
  Widget build(BuildContext context) {
    return _BaseAdView(
      iconAssetPath: 'assets/images/iro-iro-icon.png',
      overline: 'Color sorting game',
      title: 'Iro-Iro: Relaxing Color Puzzle',
      description: '''
Arrange colors to form amazing patterns in this relaxing colour puzzle game!''',
      onLearnMore: () {
        openUrl(iroIroWebsiteUrl);
      },
    );
  }
}

class EjimoAdView extends StatelessWidget {
  const EjimoAdView({super.key});

  @override
  Widget build(BuildContext context) {
    return _BaseAdView(
      iconAssetPath: 'assets/images/ejimo-icon.png',
      overline: 'All your characters, one app',
      title: 'Ejimo',
      description: '''
Find and copy unicode characters, emoji, kaomoji and symbols with Ejimo.''',
      onLearnMore: () {
        openUrl(ejimoWebsiteUrl);
      },
    );
  }
}

class UpcAdView extends StatelessWidget {
  const UpcAdView({super.key});

  @override
  Widget build(BuildContext context) {
    return _BaseAdView(
      iconAssetPath: 'assets/images/upc-icon.png',
      overline: 'Color palettes, simplified',
      title: 'Universal Palette Converter',
      description: '''
Universal Palette Converter is the ultimate solution for managing and converting color palettes across various formats.''',
      onLearnMore: () {
        openUrl(upcWebsiteUrl);
      },
    );
  }
}

class _BaseAdView extends StatelessWidget {
  final String iconAssetPath;
  final String overline;
  final String title;
  final String description;
  final void Function() onLearnMore;

  const _BaseAdView({
    required this.iconAssetPath,
    required this.overline,
    required this.title,
    required this.description,
    required this.onLearnMore,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          Container(
            decoration: ShapeDecoration(
              color: Theme.of(context).colorScheme.inverseSurface,
              shape: const CircleBorder(),
            ),
            padding: const EdgeInsets.all(8),
            child: ClipOval(
              child: Image.asset(iconAssetPath, width: 32, height: 32),
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
                      overline.toUpperCase(),
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge,
                      softWrap: true,
                    ),
                  ],
                ),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                OutlinedButton(
                  onPressed: onLearnMore,
                  child: const Text('Learn more'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
