import 'package:colourlovers_app/app/routing.dart';
import 'package:colourlovers_app/test/filters/view.dart';
import 'package:colourlovers_app/test/item-details/view.dart';
import 'package:colourlovers_app/test/items/view.dart';
import 'package:colourlovers_app/test/share-items/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TestViewController extends Cubit<void> {
  factory TestViewController.fromContext(BuildContext context) {
    return TestViewController();
  }

  TestViewController() : super(null);

  void showItemsTestView(BuildContext context) {
    openScreen(context, const ItemsTestView());
  }

  void showItemDetailsTestView(BuildContext context) {
    openScreen(context, const ItemDetailsTestViewCreator());
  }

  void showShareItemsTestView(BuildContext context) {
    openScreen(context, const ShareItemsTestViewCreator());
  }

  void showFiltersTestView(BuildContext context) {
    openScreen(context, const FiltersTestView());
  }
}
