import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/related-colors/view-controller.dart';
import 'package:colourlovers_app/widgets/app-bar.dart';
import 'package:colourlovers_app/widgets/item-tiles/color-tile/view-state.dart';
import 'package:colourlovers_app/widgets/item-tiles/color-tile/view.dart';
import 'package:colourlovers_app/widgets/items-list/view-state.dart';
import 'package:colourlovers_app/widgets/items-list/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RelatedColorsViewCreator extends StatelessWidget {
  final Hsv hsv;

  const RelatedColorsViewCreator({
    super.key,
    required this.hsv,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RelatedColorsViewController>(
      create: (context) {
        return RelatedColorsViewController.fromContext(
          context,
          hsv: hsv,
        );
      },
      child: BlocBuilder<RelatedColorsViewController,
          ItemsListViewState<ColorTileViewState>>(
        builder: (context, state) {
          return RelatedColorsView(
            listViewState: state,
            controller: context.read<RelatedColorsViewController>(),
          );
        },
      ),
    );
  }
}

class RelatedColorsView extends StatelessWidget {
  final ItemsListViewState<ColorTileViewState> listViewState;
  final RelatedColorsViewController controller;

  const RelatedColorsView({
    super.key,
    required this.listViewState,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarView(
        context,
        title: 'Related colors',
      ),
      body: ItemsListView(
        state: listViewState,
        itemTileBuilder: (itemViewState) {
          return ColorTileView(
            state: itemViewState,
            onTap: () {
              controller.showColorDetails(context, itemViewState);
            },
          );
        },
        onLoadMorePressed: controller.loadMore,
      ),
    );
  }
}
