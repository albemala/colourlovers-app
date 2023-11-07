import 'package:colourlovers_app/widgets/h2-text.dart';
import 'package:colourlovers_app/widgets/item-tiles.dart';
import 'package:flutter/material.dart';

// TODO if they are all the same, can I just use _RelatedItemsView?

class RelatedColorsView extends StatelessWidget {
  // final Hsv hsv;
  final List<ColorTileViewModel> viewModels;

  const RelatedColorsView({
    super.key,
    // required this.hsv,
    required this.viewModels,
  });

  @override
  Widget build(BuildContext context) {
    return _RelatedItemsView<ColorTileViewModel>(
      title: 'Related colors',
      items: viewModels,
      itemBuilder: (viewModel) {
        return ColorTileView(
          viewModel: viewModel,
          onTap: () {
            // TODO
          },
        );
      },
      onShowMorePressed: () {
        // TODO
        // ref.read(routingProvider.notifier).showScreen(
        //       context,
        //       RelatedColorsView(hsv: hsv),
        //     );
      },
    );
  }
}

class RelatedPalettesView extends StatelessWidget {
  // final List<String> hexs;
  final List<PaletteTileViewModel> viewModels;

  const RelatedPalettesView({
    super.key,
    // required this.hexs,
    required this.viewModels,
  });

  @override
  Widget build(BuildContext context) {
    return _RelatedItemsView<PaletteTileViewModel>(
      title: 'Related palettes',
      items: viewModels,
      itemBuilder: (viewModel) {
        return PaletteTileView(
          viewModel: viewModel,
          onTap: () {
            // TODO
          },
        );
      },
      onShowMorePressed: () {
        // TODO
        // ref.read(routingProvider.notifier).showScreen(
        //       context,
        //       RelatedPalettesView(hex: hex),
        //     );
      },
    );
  }
}

class RelatedPatternsView extends StatelessWidget {
  // final List<String> hexs;
  final List<PatternTileViewModel> viewModels;

  const RelatedPatternsView({
    super.key,
    // required this.hexs,
    required this.viewModels,
  });

  @override
  Widget build(BuildContext context) {
    return _RelatedItemsView<PatternTileViewModel>(
      title: 'Related patterns',
      items: viewModels,
      itemBuilder: (viewModel) {
        return PatternTileView(
          viewModel: viewModel,
          onTap: () {
            // TODO
          },
        );
      },
      onShowMorePressed: () {
        // TODO
        // ref.read(routingProvider.notifier).showScreen(
        //       context,
        //       RelatedPatternsView(hex: hex),
        //     );
      },
    );
  }
}

class UserColorsView extends StatelessWidget {
  // final String userName;
  final List<ColorTileViewModel> viewModels;

  const UserColorsView({
    super.key,
    // required this.userName,
    required this.viewModels,
  });

  @override
  Widget build(BuildContext context) {
    return _RelatedItemsView<ColorTileViewModel>(
      title: 'Colors',
      items: viewModels,
      itemBuilder: (viewModel) {
        return ColorTileView(
          viewModel: viewModel,
          onTap: () {
            // TODO
          },
        );
      },
      onShowMorePressed: () {
        // TODO
        // ref.read(routingProvider.notifier).showScreen(
        //       context,
        //       UserColorsView(userName: userName),
        //     );
      },
    );
  }
}

class UserPalettesView extends StatelessWidget {
  // final String userName;
  final List<PaletteTileViewModel> viewModels;

  const UserPalettesView({
    super.key,
    // required this.userName,
    required this.viewModels,
  });

  @override
  Widget build(BuildContext context) {
    return _RelatedItemsView<PaletteTileViewModel>(
      title: 'Palettes',
      items: viewModels,
      itemBuilder: (viewModel) {
        return PaletteTileView(
          viewModel: viewModel,
          onTap: () {
            // TODO
          },
        );
      },
      onShowMorePressed: () {
        // TODO
        // ref.read(routingProvider.notifier).showScreen(
        //       context,
        //       UserPalettesView(userName: userName),
        //     );
      },
    );
  }
}

class UserPatternsView extends StatelessWidget {
  // final String userName;
  final List<PatternTileViewModel> viewModels;

  const UserPatternsView({
    super.key,
    // required this.userName,
    required this.viewModels,
  });

  @override
  Widget build(BuildContext context) {
    return _RelatedItemsView<PatternTileViewModel>(
      title: 'Patterns',
      items: viewModels,
      itemBuilder: (viewModel) {
        return PatternTileView(
          viewModel: viewModel,
          onTap: () {
            // TODO
          },
        );
      },
      onShowMorePressed: () {
        // TODO
        // ref.read(routingProvider.notifier).showScreen(
        //       context,
        //       UserPattersView(userName: userName),
        //     );
      },
    );
  }
}

class _RelatedItemsView<ItemType> extends StatelessWidget {
  final String title;
  final List<ItemType> items;
  final Widget Function(ItemType item) itemBuilder;
  final void Function() onShowMorePressed;

  const _RelatedItemsView({
    super.key,
    required this.title,
    required this.items,
    required this.itemBuilder,
    required this.onShowMorePressed,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return Container();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        H2TextView(title),
        const SizedBox(height: 16),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items.elementAt(index);
            return itemBuilder(item);
          },
          separatorBuilder: (context, index) {
            return const SizedBox(height: 8);
          },
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
