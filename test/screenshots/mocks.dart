import 'package:colourlovers_app/about/view-controller.dart';
import 'package:colourlovers_app/about/view-state.dart';
import 'package:colourlovers_app/app-content/view-controller.dart';
import 'package:colourlovers_app/app-content/view-state.dart';
import 'package:colourlovers_app/explore/view-controller.dart';
import 'package:colourlovers_app/explore/view-state.dart';
import 'package:colourlovers_app/favorites/view-controller.dart';
import 'package:colourlovers_app/favorites/view-state.dart';
import 'package:colourlovers_app/preferences/data-controller.dart';
import 'package:colourlovers_app/preferences/data-state.dart';
import 'package:colourlovers_app/preferences/view-controller.dart';
import 'package:colourlovers_app/preferences/view-state.dart';
import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';

class MockBuildContext //
    extends Mock
    implements BuildContext {}

class MockPreferencesDataController //
    extends Mock
    implements PreferencesDataController {
  @override
  Stream<PreferencesDataState> get stream {
    return Stream.value(defaultPreferencesDataState);
  }

  @override
  PreferencesDataState get state {
    return defaultPreferencesDataState;
  }
}

class MockAppContentViewController extends Mock
    implements AppContentViewController {
  @override
  Stream<AppContentViewState> get stream {
    return Stream.value(defaultAppContentViewState);
  }

  @override
  AppContentViewState get state {
    return defaultAppContentViewState;
  }
}

class MockExploreViewController extends Mock implements ExploreViewController {
  @override
  Stream<ExploreViewState> get stream => Stream.value(defaultExploreViewState);

  @override
  ExploreViewState get state => defaultExploreViewState;
}

class MockFavoritesViewController extends Mock
    implements FavoritesViewController {
  @override
  Stream<FavoritesViewState> get stream =>
      Stream.value(defaultFavoritesViewState);

  @override
  FavoritesViewState get state => defaultFavoritesViewState;
}

class MockPreferencesViewController extends Mock
    implements PreferencesViewController {
  @override
  Stream<PreferencesViewState> get stream =>
      Stream.value(defaultPreferencesViewState);

  @override
  PreferencesViewState get state => defaultPreferencesViewState;
}

class MockAboutViewController extends Mock implements AboutViewController {
  @override
  Stream<AboutViewState> get stream => Stream.value(defaultAboutViewState);

  @override
  AboutViewState get state => defaultAboutViewState;
}
