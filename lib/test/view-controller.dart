import 'dart:async';

import 'package:colourlovers_app/favorites/data-controller.dart';
import 'package:colourlovers_app/routing.dart';
import 'package:colourlovers_app/test/details/view.dart';
import 'package:colourlovers_app/test/filters/view.dart';
import 'package:colourlovers_app/test/items/view.dart';
import 'package:colourlovers_app/test/share/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TestViewController extends Cubit<void> {
  final FavoritesDataController _favoritesDataController;

  factory TestViewController.fromContext(BuildContext context) {
    return TestViewController(context.read<FavoritesDataController>());
  }

  TestViewController(this._favoritesDataController) : super(null);

  void showItemsTestView(BuildContext context) {
    unawaited(openScreen<void>(context, const ItemsTestView()));
  }

  void showItemDetailsTestView(BuildContext context) {
    unawaited(openScreen<void>(context, const ItemDetailsTestViewCreator()));
  }

  void showShareItemsTestView(BuildContext context) {
    unawaited(openScreen<void>(context, const ShareItemsTestViewCreator()));
  }

  void showFiltersTestView(BuildContext context) {
    unawaited(openScreen<void>(context, const FiltersTestView()));
  }

  void removeAllFavorites(BuildContext context) {
    _favoritesDataController.removeAllFavorites();
  }
}
