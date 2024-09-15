import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/related-colors/view-controller.dart';
import 'package:colourlovers_app/related-colors/view-state.dart';
import 'package:colourlovers_app/widgets/app-bar.dart';
import 'package:colourlovers_app/widgets/background/view.dart';
import 'package:colourlovers_app/widgets/item-tiles/color-tile/view.dart';
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
      child: BlocBuilder<RelatedColorsViewController, RelatedColorsViewState>(
        builder: (context, state) {
          return RelatedColorsView(
            state: state,
            controller: context.read<RelatedColorsViewController>(),
          );
        },
      ),
    );
  }
}

class RelatedColorsView extends StatelessWidget {
  final RelatedColorsViewState state;
  final RelatedColorsViewController controller;

  const RelatedColorsView({
    super.key,
    required this.state,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarView(
        context,
        title: 'Related colors',
      ),
      body: BackgroundView(
        blobs: state.backgroundBlobs.toList(),
        child: ItemsListView(
          state: state.itemsList,
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
      ),
    );
  }
}
