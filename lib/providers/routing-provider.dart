import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum MainRoute {
  explore,
  favorites,
  about,
}

class RoutingProvider extends StateNotifier<MainRoute> {
  RoutingProvider() : super(MainRoute.explore);

  void setRoute(int index) {
    state = MainRoute.values[index];
  }

  void showScreen(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }
}
