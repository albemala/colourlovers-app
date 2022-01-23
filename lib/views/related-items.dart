import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/providers/items.dart';
import 'package:colourlovers_app/utils/related-items.dart';
import 'package:colourlovers_app/utils/user-items.dart';
import 'package:colourlovers_app/widgets/app-bar.dart';
import 'package:colourlovers_app/widgets/background.dart';
import 'package:colourlovers_app/widgets/item-tiles.dart';
import 'package:colourlovers_app/widgets/pagination.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RelatedColorsView extends StatelessWidget {
  final Hsv? hsv;

  const RelatedColorsView({
    Key? key,
    required this.hsv,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final relatedColorsProvider = StateNotifierProvider<ItemsProvider<ClColor>, ItemsState<ClColor>>((ref) {
      return ItemsProvider(
        (client, numResults, resultOffset) async {
          return getRelatedColors(client, numResults, resultOffset, hsv);
        },
      );
    });
    return _RelatedItemsView<ClColor>(
      appBarTitle: 'Related colors',
      provider: relatedColorsProvider,
      itemBuilder: (context, state, index) {
        final color = state.items[index];
        return ColorTileWidget(color: color);
      },
    );
  }
}

class RelatedPalettesView extends StatelessWidget {
  final List<String>? hex;

  const RelatedPalettesView({
    Key? key,
    required this.hex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final relatedPalettesProvider = StateNotifierProvider<ItemsProvider<ClPalette>, ItemsState<ClPalette>>((ref) {
      return ItemsProvider(
        (client, numResults, resultOffset) async {
          return getRelatedPalettes(client, numResults, resultOffset, hex);
        },
      );
    });
    return _RelatedItemsView<ClPalette>(
      appBarTitle: 'Related palettes',
      provider: relatedPalettesProvider,
      itemBuilder: (context, state, index) {
        final palette = state.items[index];
        return PaletteTileWidget(palette: palette);
      },
    );
  }
}

class RelatedPatternsView extends StatelessWidget {
  final List<String>? hex;

  const RelatedPatternsView({
    Key? key,
    required this.hex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final relatedPatternsProvider = StateNotifierProvider<ItemsProvider<ClPattern>, ItemsState<ClPattern>>((ref) {
      return ItemsProvider(
        (client, numResults, resultOffset) async {
          return getRelatedPatterns(client, numResults, resultOffset, hex);
        },
      );
    });
    return _RelatedItemsView<ClPattern>(
      appBarTitle: 'Related patterns',
      provider: relatedPatternsProvider,
      itemBuilder: (context, state, index) {
        final pattern = state.items[index];
        return PatternTileWidget(pattern: pattern);
      },
    );
  }
}

class UserColorsView extends StatelessWidget {
  final String userName;

  const UserColorsView({
    Key? key,
    required this.userName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userColorsProvider = StateNotifierProvider<ItemsProvider<ClColor>, ItemsState<ClColor>>((ref) {
      return ItemsProvider(
        (client, numResults, resultOffset) async {
          return getUserColors(client, numResults, resultOffset, userName);
        },
      );
    });
    return _RelatedItemsView<ClColor>(
      appBarTitle: "$userName's colors",
      provider: userColorsProvider,
      itemBuilder: (context, state, index) {
        final color = state.items[index];
        return ColorTileWidget(color: color);
      },
    );
  }
}

class UserPalettesView extends StatelessWidget {
  final String userName;

  const UserPalettesView({
    Key? key,
    required this.userName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userPalettesProvider = StateNotifierProvider<ItemsProvider<ClPalette>, ItemsState<ClPalette>>((ref) {
      return ItemsProvider(
        (client, numResults, resultOffset) async {
          return getUserPalettes(client, numResults, resultOffset, userName);
        },
      );
    });
    return _RelatedItemsView<ClPalette>(
      appBarTitle: "$userName's palettes",
      provider: userPalettesProvider,
      itemBuilder: (context, state, index) {
        final palette = state.items[index];
        return PaletteTileWidget(palette: palette);
      },
    );
  }
}

class UserPattersView extends StatelessWidget {
  final String userName;

  const UserPattersView({
    Key? key,
    required this.userName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userPatternsProvider = StateNotifierProvider<ItemsProvider<ClPattern>, ItemsState<ClPattern>>((ref) {
      return ItemsProvider(
        (client, numResults, resultOffset) async {
          return getUserPatterns(client, numResults, resultOffset, userName);
        },
      );
    });
    return _RelatedItemsView<ClPattern>(
      appBarTitle: "$userName's patterns",
      provider: userPatternsProvider,
      itemBuilder: (context, state, index) {
        final pattern = state.items[index];
        return PatternTileWidget(pattern: pattern);
      },
    );
  }
}

class _RelatedItemsView<ItemType> extends HookConsumerWidget {
  final String appBarTitle;
  final StateNotifierProvider<ItemsProvider<ItemType>, ItemsState<ItemType>> provider;
  final Widget Function(BuildContext, ItemsState<ItemType>, int) itemBuilder;

  const _RelatedItemsView({
    Key? key,
    required this.appBarTitle,
    required this.provider,
    required this.itemBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();
    final state = ref.watch(provider);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBarWidget(
        context,
        titleText: appBarTitle,
      ),
      body: PaginationWidget(
        scrollController: scrollController,
        onLoadMore: () {
          ref.read(provider.notifier).loadMore();
        },
        child: BackgroundWidget(
          colors: defaultBackgroundColors,
          child: SafeArea(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              controller: scrollController,
              itemCount: state.items.length,
              itemBuilder: (context, index) => itemBuilder(context, state, index),
              separatorBuilder: (context, index) => const SizedBox(height: 12),
            ),
          ),
        ),
      ),
    );
  }
}
