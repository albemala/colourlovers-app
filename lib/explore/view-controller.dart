import 'package:colourlovers_app/colors/view.dart';
import 'package:colourlovers_app/explore/view-state.dart';
import 'package:colourlovers_app/palettes/view.dart';
import 'package:colourlovers_app/patterns/view.dart';
import 'package:colourlovers_app/routing.dart';
import 'package:colourlovers_app/users/view.dart';
import 'package:colourlovers_app/widgets/background/functions.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// TODO create view model and pass tiles data to view from controller

class ExploreViewController extends Cubit<ExploreViewState> {
  factory ExploreViewController.fromContext(BuildContext context) {
    return ExploreViewController();
  }

  ExploreViewController() : super(defaultExploreViewState) {
    emit(
      state.copyWith(
        backgroundBlobs: generateBackgroundBlobs(getRandomPalette()).toIList(),
      ),
    );
  }

  void showColorsView(BuildContext context) {
    openScreen<void>(context, const ColorsViewCreator());
  }

  void showPalettesView(BuildContext context) {
    openScreen<void>(context, const PalettesViewCreator());
  }

  void showPatternsView(BuildContext context) {
    openScreen<void>(context, const PatternsViewCreator());
  }

  void showUsersView(BuildContext context) {
    openScreen<void>(context, const UsersViewCreator());
  }
}
