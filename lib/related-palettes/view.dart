import 'package:colourlovers_app/related-palettes/view-controller.dart';
import 'package:colourlovers_app/widgets/app-top-bar.dart';
import 'package:colourlovers_app/widgets/item-tiles.dart';
import 'package:colourlovers_app/widgets/items-list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RelatedPalettesViewCreator extends StatelessWidget {
  final List<String> hex;

  const RelatedPalettesViewCreator({
    super.key,
    required this.hex,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RelatedPalettesViewController>(
      create: (context) {
        return RelatedPalettesViewController.fromContext(
          context,
          hex: hex,
        );
      },
      child: BlocBuilder<RelatedPalettesViewController,
          ItemsListViewState<PaletteTileViewState>>(
        builder: (context, state) {
          return RelatedPalettesView(
            listViewState: state,
            controller: context.read<RelatedPalettesViewController>(),
          );
        },
      ),
    );
  }
}

class RelatedPalettesView extends StatelessWidget {
  final ItemsListViewState<PaletteTileViewState> listViewState;
  final RelatedPalettesViewController controller;

  const RelatedPalettesView({
    super.key,
    required this.listViewState,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTopBarView(
        context,
        title: 'Related palettes',
      ),
      body: ItemsListView(
        state: listViewState,
        itemTileBuilder: (itemViewState) {
          return PaletteTileView(
            state: itemViewState,
            onTap: () {
              controller.showPaletteDetails(context, itemViewState);
            },
          );
        },
        onLoadMorePressed: controller.loadMore,
      ),
    );
  }
}
