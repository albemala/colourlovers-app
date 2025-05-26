import 'package:colourlovers_app/favorites/view-state.dart';
import 'package:colourlovers_app/widgets/background/functions.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoritesViewController extends Cubit<FavoritesViewState> {
  factory FavoritesViewController.fromContext(BuildContext context) {
    return FavoritesViewController();
  }

  FavoritesViewController() : super(defaultFavoritesViewState) {
    emit(
      state.copyWith(
        backgroundBlobs: generateBackgroundBlobs(getRandomPalette()).toIList(),
      ),
    );
  }
}
