import 'package:colourlovers_app/related-patterns/view-controller.dart';
import 'package:colourlovers_app/widgets/app-bar.dart';
import 'package:colourlovers_app/widgets/item-tiles/pattern-tile/view-state.dart';
import 'package:colourlovers_app/widgets/item-tiles/pattern-tile/view.dart';
import 'package:colourlovers_app/widgets/items-list/view-state.dart';
import 'package:colourlovers_app/widgets/items-list/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RelatedPatternsViewCreator extends StatelessWidget {
  final List<String> hex;

  const RelatedPatternsViewCreator({
    super.key,
    required this.hex,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RelatedPatternsViewController>(
      create: (context) {
        return RelatedPatternsViewController.fromContext(
          context,
          hex: hex,
        );
      },
      child: BlocBuilder<RelatedPatternsViewController,
          ItemsListViewState<PatternTileViewState>>(
        builder: (context, state) {
          return RelatedPatternsView(
            listViewState: state,
            controller: context.read<RelatedPatternsViewController>(),
          );
        },
      ),
    );
  }
}

class RelatedPatternsView extends StatelessWidget {
  final ItemsListViewState<PatternTileViewState> listViewState;
  final RelatedPatternsViewController controller;

  const RelatedPatternsView({
    super.key,
    required this.listViewState,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarView(
        context,
        title: 'Related patterns',
      ),
      body: ItemsListView(
        state: listViewState,
        itemTileBuilder: (itemViewState) {
          return PatternTileView(
            state: itemViewState,
            onTap: () {
              controller.showPatternDetails(context, itemViewState);
            },
          );
        },
        onLoadMorePressed: controller.loadMore,
      ),
    );
  }
}
