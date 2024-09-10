import 'package:colourlovers_app/palettes/view-controller.dart';
import 'package:colourlovers_app/widgets/app-bar.dart';
import 'package:colourlovers_app/widgets/icon-buttons.dart';
import 'package:colourlovers_app/widgets/item-tiles/palette-tile/view-state.dart';
import 'package:colourlovers_app/widgets/item-tiles/palette-tile/view.dart';
import 'package:colourlovers_app/widgets/items-list/view-state.dart';
import 'package:colourlovers_app/widgets/items-list/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PalettesViewCreator extends StatelessWidget {
  const PalettesViewCreator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PalettesViewController>(
      create: PalettesViewController.fromContext,
      child: BlocBuilder<PalettesViewController,
          ItemsListViewState<PaletteTileViewState>>(
        builder: (context, state) {
          return PalettesView(
            listViewState: state,
            controller: context.read<PalettesViewController>(),
          );
        },
      ),
    );
  }
}

class PalettesView extends StatelessWidget {
  final ItemsListViewState<PaletteTileViewState> listViewState;
  final PalettesViewController controller;

  const PalettesView({
    super.key,
    required this.listViewState,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarView(
        context,
        title: 'Palettes',
        actions: [
          RandomItemButton(
            onPressed: () {
              controller.showRandomPalette(context);
            },
            tooltip: 'Random palette',
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
