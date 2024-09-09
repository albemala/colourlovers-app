import 'package:colourlovers_app/app/routing.dart';
import 'package:colourlovers_app/colors/view.dart';
import 'package:colourlovers_app/palettes/view.dart';
import 'package:colourlovers_app/patterns/view.dart';
import 'package:colourlovers_app/users/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// TODO create view model and pass tiles data to view from controller

class ExploreViewController extends Cubit<void> {
  factory ExploreViewController.fromContext(BuildContext context) {
    return ExploreViewController();
  }

  ExploreViewController() : super(null);

  void showColorsView(BuildContext context) {
    openScreen(context, const ColorsViewCreator());
  }

  void showPalettesView(BuildContext context) {
    openScreen(context, const PalettesViewCreator());
  }

  void showPatternsView(BuildContext context) {
    openScreen(context, const PatternsViewCreator());
  }

  void showUsersView(BuildContext context) {
    openScreen(context, const UsersViewCreator());
  }
}
