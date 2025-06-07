import 'package:colourlovers_app/about/view-controller.dart';
import 'package:colourlovers_app/app-content/view-controller.dart';
import 'package:colourlovers_app/app-content/view-state.dart';
import 'package:colourlovers_app/details/color/view-controller.dart';
import 'package:colourlovers_app/details/palette/view-controller.dart';
import 'package:colourlovers_app/details/pattern/view-controller.dart';
import 'package:colourlovers_app/details/user/view-controller.dart';
import 'package:colourlovers_app/explore/view-controller.dart';
import 'package:colourlovers_app/favorites/view-controller.dart';
import 'package:colourlovers_app/lists/colors/view-controller.dart';
import 'package:colourlovers_app/lists/palettes/view-controller.dart';
import 'package:colourlovers_app/lists/patterns/view-controller.dart';
import 'package:colourlovers_app/lists/users/view-controller.dart';
import 'package:colourlovers_app/preferences/data-controller.dart';
import 'package:colourlovers_app/preferences/data-state.dart';
import 'package:colourlovers_app/preferences/view-controller.dart';
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

class MockExploreViewController extends Mock implements ExploreViewController {}

class MockFavoritesViewController extends Mock
    implements FavoritesViewController {}

class MockPreferencesViewController extends Mock
    implements PreferencesViewController {}

class MockAboutViewController extends Mock implements AboutViewController {}

class MockColorsViewController extends Mock implements ColorsViewController {}

class MockPalettesViewController extends Mock
    implements PalettesViewController {}

class MockPatternsViewController extends Mock
    implements PatternsViewController {}

class MockUsersViewController extends Mock implements UsersViewController {}

class MockColorDetailsViewController extends Mock
    implements ColorDetailsViewController {}

class MockPaletteDetailsViewController extends Mock
    implements PaletteDetailsViewController {}

class MockPatternDetailsViewController extends Mock
    implements PatternDetailsViewController {}

class MockUserDetailsViewController extends Mock
    implements UserDetailsViewController {}
