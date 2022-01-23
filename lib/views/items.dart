import 'package:colourlovers_app/providers/items.dart';
import 'package:colourlovers_app/widgets/background.dart';
import 'package:colourlovers_app/widgets/pagination.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ItemsView<ItemType> extends HookConsumerWidget {
  final PreferredSizeWidget appBar;
  final StateNotifierProvider<ItemsProvider<ItemType>, ItemsState<ItemType>> provider;
  final Widget Function(BuildContext, ItemsState<ItemType>, int) itemBuilder;

  const ItemsView({
    Key? key,
    required this.appBar,
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
