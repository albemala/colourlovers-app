import 'package:colourlovers_app/favorites/view-controller.dart';
import 'package:colourlovers_app/favorites/view-state.dart';
import 'package:colourlovers_app/widgets/app-bar.dart';
import 'package:colourlovers_app/widgets/background/view.dart';
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
        child: const Center(child: Text('Favorites')),
      ),
    );
  }
}
