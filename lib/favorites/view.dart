import 'package:colourlovers_app/favorites/view-controller.dart';
import 'package:colourlovers_app/favorites/view-state.dart';
import 'package:colourlovers_app/widgets/app-bar.dart';
import 'package:colourlovers_app/widgets/background/view.dart';
import 'package:colourlovers_app/widgets/item-tiles/color-tile/view-state.dart';
import 'package:colourlovers_app/widgets/item-tiles/color-tile/view.dart';
import 'package:colourlovers_app/widgets/item-tiles/palette-tile/view-state.dart';
import 'package:colourlovers_app/widgets/item-tiles/palette-tile/view.dart';
import 'package:colourlovers_app/widgets/item-tiles/pattern-tile/view-state.dart';
import 'package:colourlovers_app/widgets/item-tiles/pattern-tile/view.dart';
import 'package:colourlovers_app/widgets/item-tiles/user-tile/view-state.dart';
import 'package:colourlovers_app/widgets/item-tiles/user-tile/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoritesViewCreator extends StatelessWidget {
  const FavoritesViewCreator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FavoritesViewController>(
      create: (context) {
        return FavoritesViewController.fromContext(context);
      },
      child: BlocBuilder<FavoritesViewController, FavoritesViewState>(
        builder: (context, state) {
          return FavoritesView(
            controller: context.read<FavoritesViewController>(),
            state: state,
          );
        },
      ),
    );
  }
}

class FavoritesView extends StatelessWidget {
  final FavoritesViewController controller;
  final FavoritesViewState state;

  const FavoritesView({
    required this.controller,
    required this.state,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarView(context, title: 'Favorites', actions: const []),
      body: BackgroundView(
        blobs: state.backgroundBlobs.toList(),
        child:
            state.items.isEmpty
                ? const Center(
                  child: Text(
                    'No favorites yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
                : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.items.length,
                  itemBuilder: (context, index) {
                    final item = state.items[index];
                    return _buildTileForItem(context, item);
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(height: 12);
                  },
                ),
      ),
    );
  }

  Widget _buildTileForItem(BuildContext context, dynamic item) {
    return switch (item.runtimeType) {
      const (ColorTileViewState) => ColorTileView(
        onTap: () => controller.showColorDetails(context, item),
        state: item as ColorTileViewState,
      ),
      const (PaletteTileViewState) => PaletteTileView(
        onTap: () => controller.showPaletteDetails(context, item),
        state: item as PaletteTileViewState,
      ),
      const (PatternTileViewState) => PatternTileView(
        onTap: () => controller.showPatternDetails(context, item),
        state: item as PatternTileViewState,
      ),
      const (UserTileViewState) => UserTileView(
        onTap: () => controller.showUserDetails(context, item),
        state: item as UserTileViewState,
      ),
      _ => const SizedBox.shrink(),
    };
  }
}
