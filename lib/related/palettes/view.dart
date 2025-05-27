import 'package:colourlovers_app/related/palettes/view-controller.dart';
import 'package:colourlovers_app/related/palettes/view-state.dart';
import 'package:colourlovers_app/widgets/app-bar.dart';
import 'package:colourlovers_app/widgets/background/view.dart';
import 'package:colourlovers_app/widgets/item-list/view.dart';
import 'package:colourlovers_app/widgets/item-tiles/palette-tile/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RelatedPalettesViewCreator extends StatelessWidget {
  final List<String> hex;

  const RelatedPalettesViewCreator({super.key, required this.hex});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RelatedPalettesViewController>(
      create: (context) {
        return RelatedPalettesViewController.fromContext(context, hex: hex);
      },
      child:
          BlocBuilder<RelatedPalettesViewController, RelatedPalettesViewState>(
            builder: (context, state) {
              return RelatedPalettesView(
                state: state,
                controller: context.read<RelatedPalettesViewController>(),
              );
            },
          ),
    );
  }
}

class RelatedPalettesView extends StatelessWidget {
  final RelatedPalettesViewState state;
  final RelatedPalettesViewController controller;

  const RelatedPalettesView({
    super.key,
    required this.state,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarView(context, title: 'Related palettes'),
      body: BackgroundView(
        blobs: state.backgroundBlobs.toList(),
        child: ItemListView(
          state: state.itemsList,
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
      ),
    );
  }
}
