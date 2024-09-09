import 'package:colourlovers_app/patterns/view-controller.dart';
import 'package:colourlovers_app/widgets/app-top-bar.dart';
import 'package:colourlovers_app/widgets/item-tiles.dart';
import 'package:colourlovers_app/widgets/items-list.dart';
import 'package:colourlovers_app/widgets/random-item-button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PatternsViewCreator extends StatelessWidget {
  const PatternsViewCreator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PatternsViewController>(
      create: PatternsViewController.fromContext,
      child: BlocBuilder<PatternsViewController,
          ItemsListViewState<PatternTileViewState>>(
        builder: (context, state) {
          return PatternsView(
            listViewState: state,
            controller: context.read<PatternsViewController>(),
          );
        },
      ),
    );
  }
}

class PatternsView extends StatelessWidget {
  final ItemsListViewState<PatternTileViewState> listViewState;
  final PatternsViewController controller;

  const PatternsView({
    super.key,
    required this.listViewState,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTopBarView(
        context,
        title: 'Patterns',
        actions: [
          RandomItemButton(
            onPressed: () {
              controller.showRandomPattern(context);
            },
            tooltip: 'Random pattern',
          ),
          // _FilterButton(
          //   onPressed: () {
          //     // TODO
          //   },
          // ),
        ],
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
