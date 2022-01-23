import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/providers/providers.dart';
import 'package:colourlovers_app/views/related-items.dart';
import 'package:colourlovers_app/widgets/h2-text.dart';
import 'package:colourlovers_app/widgets/item-tiles.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RelatedColorsWidget extends HookConsumerWidget {
  final Hsv? hsv;
  final List<ClColor> relatedColors;

  const RelatedColorsWidget({
    Key? key,
    required this.hsv,
    required this.relatedColors,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _RelatedItemsWidget<ClColor>(
      title: 'Related colors',
      items: relatedColors,
      itemBuilder: (item) {
        return ColorTileWidget(color: item);
      },
      onShowMorePressed: () {
        ref.read(routingProvider.notifier).showScreen(
              context,
              RelatedColorsView(hsv: hsv),
            );
      },
    );
  }
}

class RelatedPalettesWidget extends HookConsumerWidget {
  final List<String>? hex;
  final List<ClPalette> relatedPalettes;

  const RelatedPalettesWidget({
    Key? key,
    required this.hex,
    required this.relatedPalettes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _RelatedItemsWidget<ClPalette>(
      title: 'Related palettes',
      items: relatedPalettes,
      itemBuilder: (item) {
        return PaletteTileWidget(palette: item);
      },
      onShowMorePressed: () {
        ref.read(routingProvider.notifier).showScreen(
              context,
              RelatedPalettesView(hex: hex),
            );
      },
    );
  }
}

class RelatedPatternsWidget extends HookConsumerWidget {
  final List<String>? hex;
  final List<ClPattern> relatedPatterns;

  const RelatedPatternsWidget({
    Key? key,
    required this.hex,
    required this.relatedPatterns,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _RelatedItemsWidget<ClPattern>(
      title: 'Related patterns',
      items: relatedPatterns,
      itemBuilder: (item) {
        return PatternTileWidget(pattern: item);
      },
      onShowMorePressed: () {
        ref.read(routingProvider.notifier).showScreen(
              context,
              RelatedPatternsView(hex: hex),
            );
      },
    );
  }
}

class UserColorsWidgets extends HookConsumerWidget {
  final String userName;
  final List<ClColor> colors;

  const UserColorsWidgets({
    Key? key,
    required this.userName,
    required this.colors,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _RelatedItemsWidget<ClColor>(
      title: 'Colors',
      items: colors,
      itemBuilder: (item) {
        return ColorTileWidget(color: item);
      },
      onShowMorePressed: () {
        ref.read(routingProvider.notifier).showScreen(
              context,
              UserColorsView(userName: userName),
            );
      },
    );
  }
}

class UserPalettesWidget extends HookConsumerWidget {
  final String userName;
  final List<ClPalette> palettes;

  const UserPalettesWidget({
    Key? key,
    required this.userName,
    required this.palettes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _RelatedItemsWidget<ClPalette>(
      title: 'Palettes',
      items: palettes,
      itemBuilder: (item) {
        return PaletteTileWidget(palette: item);
      },
      onShowMorePressed: () {
        ref.read(routingProvider.notifier).showScreen(
              context,
              UserPalettesView(userName: userName),
            );
      },
    );
  }
}

class UserPatternsWidget extends HookConsumerWidget {
  final String userName;
  final List<ClPattern> patterns;

  const UserPatternsWidget({
    Key? key,
    required this.userName,
    required this.patterns,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _RelatedItemsWidget<ClPattern>(
      title: 'Patterns',
      items: patterns,
      itemBuilder: (item) {
        return PatternTileWidget(pattern: item);
      },
      onShowMorePressed: () {
        ref.read(routingProvider.notifier).showScreen(
              context,
              UserPattersView(userName: userName),
            );
      },
    );
  }
}

class _RelatedItemsWidget<ItemType> extends StatelessWidget {
  final String title;
  final List<ItemType> items;
  final Widget Function(ItemType item) itemBuilder;
  final void Function() onShowMorePressed;

  const _RelatedItemsWidget({
    Key? key,
    required this.title,
    required this.items,
    required this.itemBuilder,
    required this.onShowMorePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return Container();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        H2TextWidget(title),
        const SizedBox(height: 16),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items.elementAt(index);
            return item != null ? itemBuilder(item) : Container();
          },
          separatorBuilder: (context, index) => const SizedBox(height: 8),
        ),
        const SizedBox(height: 8),
        OutlinedButton(
          onPressed: onShowMorePressed,
          child: const Text('Show more'),
        ),
      ],
    );
  }
}
