import 'package:boxicons/boxicons.dart';
import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/providers/items.dart';
import 'package:colourlovers_app/providers/providers.dart';
import 'package:colourlovers_app/views/color-details.dart';
import 'package:colourlovers_app/views/palette-details.dart';
import 'package:colourlovers_app/views/pattern-details.dart';
import 'package:colourlovers_app/widgets/app-bar.dart';
import 'package:colourlovers_app/widgets/background.dart';
import 'package:colourlovers_app/widgets/item-tiles.dart';
import 'package:colourlovers_app/widgets/pagination.dart';
import 'package:colourlovers_app/widgets/user-tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ColorsView extends HookConsumerWidget {
  const ColorsView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _ItemsView<ClColor>(
      appBar: AppBarWidget(
        context,
        titleText: 'Colors',
        actionWidgets: [
          _RandomItemButton(
            onPressed: () async {
              final color = await ClClient().getRandomColor();
              ref.read(routingProvider.notifier).showScreen(context, ColorDetailsView(color: color));
            },
          ),
          // _FilterButton(
          //   onPressed: () {
          //     // TODO
          //   },
          // ),
        ],
      ),
      filters: [
        _FilterWidget(onPressed: () {}, text: 'New'),
        _FilterWidget(onPressed: () {}, text: 'By creation date'),
        _FilterWidget(onPressed: () {}, text: 'Older first'),
        _FilterWidget(onPressed: () {}, text: 'Any name'),
        _FilterWidget(onPressed: () {}, text: 'Any hue'),
        _FilterWidget(onPressed: () {}, text: 'Any brightness'),
        _FilterWidget(onPressed: () {}, text: 'Any user'),
      ],
      provider: colorsProvider,
      itemBuilder: (context, state, index) {
        final color = state.items[index];
        return ColorTileWidget(color: color);
      },
    );
  }
}

class PalettesView extends HookConsumerWidget {
  const PalettesView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _ItemsView<ClPalette>(
      appBar: AppBarWidget(
        context,
        titleText: 'Palettes',
        actionWidgets: [
          _RandomItemButton(
            onPressed: () async {
              final palette = await ClClient().getRandomPalette();
              ref.read(routingProvider.notifier).showScreen(context, PaletteDetailsView(palette: palette));
            },
          ),
          // _FilterButton(
          //   onPressed: () {
          //     // TODO
          //   },
          // ),
        ],
      ),
      filters: [],
      provider: palettesProvider,
      itemBuilder: (context, state, index) {
        final palette = state.items[index];
        return PaletteTileWidget(palette: palette);
      },
    );
  }
}

class PatternsView extends HookConsumerWidget {
  const PatternsView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _ItemsView<ClPattern>(
      appBar: AppBarWidget(
        context,
        titleText: 'Patterns',
        actionWidgets: [
          _RandomItemButton(
            onPressed: () async {
              final pattern = await ClClient().getRandomPattern();
              ref.read(routingProvider.notifier).showScreen(context, PatternDetailsView(pattern: pattern));
            },
          ),
          // _FilterButton(
          //   onPressed: () {
          //     // TODO
          //   },
          // ),
        ],
      ),
      filters: [],
      provider: patternsProvider,
      itemBuilder: (context, state, index) {
        final pattern = state.items[index];
        return PatternTileWidget(pattern: pattern);
      },
    );
  }
}

class UsersView extends StatelessWidget {
  const UsersView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _ItemsView<ClLover>(
      appBar: AppBarWidget(
        context,
        titleText: 'Users',
        // actionWidgets: [
        // _FilterButton(
        //   onPressed: () {
        //     // TODO
        //   },
        // ),
        // ],
      ),
      filters: [],
      provider: usersProvider,
      itemBuilder: (context, state, index) {
        final lover = state.items[index];
        return UserTileWidget(lover: lover);
      },
    );
  }
}

class _ItemsView<ItemType> extends HookConsumerWidget {
  final PreferredSizeWidget appBar;
  final List<Widget> filters;
  final StateNotifierProvider<ItemsProvider<ItemType>, ItemsState<ItemType>> provider;
  final Widget Function(BuildContext, ItemsState<ItemType>, int) itemBuilder;

  const _ItemsView({
    Key? key,
    required this.appBar,
    required this.filters,
    required this.provider,
    required this.itemBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();
    final state = ref.watch(provider);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: appBar,
      body: BackgroundWidget(
        colors: defaultBackgroundColors,
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: 48,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filters.length,
                  itemBuilder: (context, index) {
                    return filters[index];
                  },
                  separatorBuilder: (context, index) => const SizedBox(width: 8),
                ),
              ),
              Expanded(
                child: PaginationWidget(
                  scrollController: scrollController,
                  onLoadMore: () {
                    ref.read(provider.notifier).loadMore();
                  },
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    controller: scrollController,
                    itemCount: state.items.length,
                    itemBuilder: (context, index) => itemBuilder(context, state, index),
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RandomItemButton extends StatelessWidget {
  final void Function() onPressed;

  const _RandomItemButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: const Icon(
        BoxIcons.bx_dice_3_regular,
      ),
    );
  }
}

/*
class _FilterButton extends StatelessWidget {
  final void Function() onPressed;

  const _FilterButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: const Icon(
        BoxIcons.bx_filter_alt_regular,
      ),
    );
  }
}
*/

class _FilterWidget extends StatelessWidget {
  const _FilterWidget({
    Key? key,
    required this.onPressed,
    required this.text,
  }) : super(key: key);

  final Null Function() onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      onPressed: onPressed,
      label: Text(text),
      shape: StadiumBorder(),
    );
  }
}
