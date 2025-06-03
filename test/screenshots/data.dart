import 'package:colourlovers_app/about/view-state.dart';
import 'package:colourlovers_app/about/view.dart';
import 'package:colourlovers_app/app-content/view-state.dart';
import 'package:colourlovers_app/app-content/view.dart';
import 'package:colourlovers_app/explore/view-state.dart';
import 'package:colourlovers_app/explore/view.dart';
import 'package:colourlovers_app/favorites/view-state.dart';
import 'package:colourlovers_app/favorites/view.dart';
import 'package:colourlovers_app/preferences/view-state.dart';
import 'package:colourlovers_app/preferences/view.dart';
import 'package:flutter/material.dart';

import 'mocks.dart';

class ScreenshotData {
  final Widget view;
  final String fileName;

  const ScreenshotData({required this.view, required this.fileName});
}

Future<List<ScreenshotData>> createScreenshotData() async {
  final customViews = <Widget>[
    NavigatorView(
      child: ExploreView(
        controller: MockExploreViewController(),
        state: defaultExploreViewState,
      ),
    ),
    NavigatorView(
      child: FavoritesView(
        controller: MockFavoritesViewController(),
        state: defaultFavoritesViewState,
      ),
    ),
    NavigatorView(
      child: PreferencesView(
        controller: MockPreferencesViewController(),
        state: defaultPreferencesViewState,
      ),
    ),
    NavigatorView(
      child: AboutView(
        controller: MockAboutViewController(),
        state: defaultAboutViewState,
      ),
    ),
  ];

  final customDestinations = <NavigationDestination>[
    exploreDestination,
    favoritesDestination,
    preferencesDestination,
    aboutDestination,
  ];

  return [
    ScreenshotData(
      view: AppContentView(
        controller: MockAppContentViewController(),
        state: const AppContentViewState(currentRoute: MainRoute.explore),
        views: customViews,
        destinations: customDestinations,
      ),
      fileName: 'explore_view',
    ),
    ScreenshotData(
      view: AppContentView(
        controller: MockAppContentViewController(),
        state: const AppContentViewState(currentRoute: MainRoute.favorites),
        views: customViews,
        destinations: customDestinations,
      ),
      fileName: 'favorites_view',
    ),
    ScreenshotData(
      view: AppContentView(
        controller: MockAppContentViewController(),
        state: const AppContentViewState(currentRoute: MainRoute.preferences),
        views: customViews,
        destinations: customDestinations,
      ),
      fileName: 'preferences_view',
    ),
    ScreenshotData(
      view: AppContentView(
        controller: MockAppContentViewController(),
        state: const AppContentViewState(currentRoute: MainRoute.about),
        views: customViews,
        destinations: customDestinations,
      ),
      fileName: 'about_view',
    ),
  ];
}

/*
class ScreenshotDialogView extends StatelessWidget {
  final Widget child;

  const ScreenshotDialogView({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.black54,
      child: Center(
        child: AlertDialog(
          contentPadding: const EdgeInsets.all(32),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: child,
          ),
        ),
      ),
    );
  }
}
*/
