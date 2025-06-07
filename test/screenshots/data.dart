import 'dart:convert';
import 'dart:io';

import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/about/view-state.dart';
import 'package:colourlovers_app/about/view.dart';
import 'package:colourlovers_app/app-content/view-state.dart';
import 'package:colourlovers_app/app-content/view.dart';
import 'package:colourlovers_app/details/color/view-state.dart';
import 'package:colourlovers_app/details/color/view.dart';
import 'package:colourlovers_app/details/palette/view-state.dart';
import 'package:colourlovers_app/details/palette/view.dart';
import 'package:colourlovers_app/details/pattern/view-state.dart';
import 'package:colourlovers_app/details/pattern/view.dart';
import 'package:colourlovers_app/details/user/view-state.dart';
import 'package:colourlovers_app/details/user/view.dart';
import 'package:colourlovers_app/explore/view-state.dart';
import 'package:colourlovers_app/explore/view.dart';
import 'package:colourlovers_app/favorites/view-state.dart';
import 'package:colourlovers_app/favorites/view.dart';
import 'package:colourlovers_app/filters/favorites/defines.dart';
import 'package:colourlovers_app/lists/colors/view-state.dart';
import 'package:colourlovers_app/lists/colors/view.dart';
import 'package:colourlovers_app/lists/palettes/view-state.dart';
import 'package:colourlovers_app/lists/palettes/view.dart';
import 'package:colourlovers_app/lists/patterns/view-state.dart';
import 'package:colourlovers_app/lists/patterns/view.dart';
import 'package:colourlovers_app/lists/users/view-state.dart';
import 'package:colourlovers_app/lists/users/view.dart';
import 'package:colourlovers_app/preferences/view-state.dart';
import 'package:colourlovers_app/preferences/view.dart';
import 'package:colourlovers_app/widgets/item-list/view-state.dart';
import 'package:colourlovers_app/widgets/item-tiles/color-tile/view-state.dart';
import 'package:colourlovers_app/widgets/item-tiles/palette-tile/view-state.dart';
import 'package:colourlovers_app/widgets/item-tiles/pattern-tile/view-state.dart';
import 'package:colourlovers_app/widgets/item-tiles/user-tile/view-state.dart';
import 'package:equatable/equatable.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';

import 'mocks.dart';

class ScreenshotData {
  final Widget view;
  final String fileName;

  const ScreenshotData({required this.view, required this.fileName});
}

class _LoadedItems {
  final List<ColourloversColor> colors;
  final List<ColourloversPalette> palettes;
  final List<ColourloversPattern> patterns;
  final List<ColourloversLover> lovers;

  _LoadedItems({
    required this.colors,
    required this.palettes,
    required this.patterns,
    required this.lovers,
  });
}

Future<List<ScreenshotData>> createScreenshotData() async {
  final loadedItems = await _loadItemsFromAssets();
  if (loadedItems.colors.isEmpty ||
      loadedItems.palettes.isEmpty ||
      loadedItems.patterns.isEmpty ||
      loadedItems.lovers.isEmpty) {
    throw Exception('Loaded items are empty');
  }

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
        state: _createFavoritesViewState(loadedItems),
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

  final appContentViews = <ScreenshotData>[
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

  final listViews = <ScreenshotData>[
    ScreenshotData(
      view: NavigatorView(
        child: ColorsView(
          controller: MockColorsViewController(),
          state: _createColorsListViewState(loadedItems),
        ),
      ),
      fileName: 'colors_list_view',
    ),
    ScreenshotData(
      view: NavigatorView(
        child: PalettesView(
          controller: MockPalettesViewController(),
          state: _createPalettesListViewState(loadedItems),
        ),
      ),
      fileName: 'palettes_list_view',
    ),
    ScreenshotData(
      view: NavigatorView(
        child: PatternsView(
          controller: MockPatternsViewController(),
          state: _createPatternsListViewState(loadedItems),
        ),
      ),
      fileName: 'patterns_list_view',
    ),
    ScreenshotData(
      view: NavigatorView(
        child: UsersView(
          controller: MockUsersViewController(),
          state: _createUsersListViewState(loadedItems),
        ),
      ),
      fileName: 'users_list_view',
    ),
  ];

  final detailsViews = <ScreenshotData>[
    ScreenshotData(
      view: NavigatorView(
        child: ColorDetailsView(
          controller: MockColorDetailsViewController(),
          state: _createColorDetailsViewState(loadedItems),
        ),
      ),
      fileName: 'color_details_view',
    ),
    ScreenshotData(
      view: NavigatorView(
        child: PaletteDetailsView(
          controller: MockPaletteDetailsViewController(),
          state: _createPaletteDetailsViewState(loadedItems),
        ),
      ),
      fileName: 'palette_details_view',
    ),
    ScreenshotData(
      view: NavigatorView(
        child: PatternDetailsView(
          controller: MockPatternDetailsViewController(),
          state: _createPatternDetailsViewState(loadedItems),
        ),
      ),
      fileName: 'pattern_details_view',
    ),
    ScreenshotData(
      view: NavigatorView(
        child: UserDetailsView(
          controller: MockUserDetailsViewController(),
          state: _createUserDetailsViewState(loadedItems),
        ),
      ),
      fileName: 'user_details_view',
    ),
  ];

  return [...appContentViews, ...listViews, ...detailsViews];
}

Future<_LoadedItems> _loadItemsFromAssets() async {
  final colorsFile = File('assets/items/colors.json');
  final palettesFile = File('assets/items/palettes.json');
  final patternsFile = File('assets/items/patterns.json');
  final loversFile = File('assets/items/lovers.json');

  final colorsJson = jsonDecode(await colorsFile.readAsString()) as List;
  final palettesJson = jsonDecode(await palettesFile.readAsString()) as List;
  final patternsJson = jsonDecode(await patternsFile.readAsString()) as List;
  final loversJson = jsonDecode(await loversFile.readAsString()) as List;

  final colors =
      colorsJson
          .map((e) => ColourloversColor.fromJson(e as Map<String, dynamic>))
          .toList();
  final palettes =
      palettesJson
          .map((e) => ColourloversPalette.fromJson(e as Map<String, dynamic>))
          .toList();
  final patterns =
      patternsJson
          .map((e) => ColourloversPattern.fromJson(e as Map<String, dynamic>))
          .toList();

  // Update imageUrl for patterns
  final updatedPatterns =
      patterns.map((pattern) {
        return pattern.copyWith(
          imageUrl: 'asset://assets/patterns/${pattern.id}.png',
        );
      }).toList();

  final lovers =
      loversJson
          .map((e) => ColourloversLover.fromJson(e as Map<String, dynamic>))
          .toList();

  return _LoadedItems(
    colors: colors,
    palettes: palettes,
    patterns: updatedPatterns,
    lovers: lovers,
  );
}

FavoritesViewState _createFavoritesViewState(_LoadedItems loadedItems) {
  final items = <Equatable>[];

  final color = loadedItems.colors[4];
  items.add(ColorTileViewState.fromColourloverColor(color));

  final palette = loadedItems.palettes[4];
  items.add(PaletteTileViewState.fromColourloverPalette(palette));

  final pattern = loadedItems.patterns[4];
  items.add(PatternTileViewState.fromColourloverPattern(pattern));

  final lover = loadedItems.lovers[4];
  items.add(UserTileViewState.fromColourloverUser(lover));

  return FavoritesViewState(
    backgroundBlobs: const IList.empty(),
    items: items.toIList(),
    typeFilter: FavoriteItemTypeFilter.all,
    sortBy: FavoriteSortBy.timeAdded,
    sortOrder: FavoriteSortOrder.descending,
  );
}

ColorDetailsViewState _createColorDetailsViewState(_LoadedItems loadedItems) {
  final color = loadedItems.colors[3];

  return defaultColorDetailsViewState
      .copyWith(
        isLoading: false,
        backgroundBlobs: const IList.empty(),
        isFavorited: false,
      )
      .copyWithColourloversColor(color: color)
      .copyWith(
        user: UserTileViewState.fromColourloverUser(loadedItems.lovers[3]),
        relatedColors:
            loadedItems.colors
                .take(3)
                .map(ColorTileViewState.fromColourloverColor)
                .toIList(),
        relatedPalettes:
            loadedItems.palettes
                .take(3)
                .map(PaletteTileViewState.fromColourloverPalette)
                .toIList(),
        relatedPatterns:
            loadedItems.patterns
                .take(3)
                .map(PatternTileViewState.fromColourloverPattern)
                .toIList(),
      );
}

PaletteDetailsViewState _createPaletteDetailsViewState(
  _LoadedItems loadedItems,
) {
  final palette = loadedItems.palettes[0];

  return defaultPaletteDetailsViewState
      .copyWith(
        isLoading: false,
        backgroundBlobs: const IList.empty(),
        isFavorited: false,
      )
      .copyWithColourloversPalette(palette: palette)
      .copyWith(
        colorViewStates:
            (palette.colors ?? [])
                .map(
                  (hex) => ColorTileViewState(
                    id: hex,
                    title: hex,
                    numViews: 0,
                    numVotes: 0,
                    hex: hex,
                  ),
                )
                .toIList(),
        user: UserTileViewState.fromColourloverUser(loadedItems.lovers[3]),
        relatedPalettes:
            loadedItems.palettes
                .skip(1)
                .take(3)
                .map(PaletteTileViewState.fromColourloverPalette)
                .toIList(),
        relatedPatterns:
            loadedItems.patterns
                .take(3)
                .map(PatternTileViewState.fromColourloverPattern)
                .toIList(),
      );
}

PatternDetailsViewState _createPatternDetailsViewState(
  _LoadedItems loadedItems,
) {
  final pattern = loadedItems.patterns[0];

  return defaultPatternDetailsViewState
      .copyWith(
        isLoading: false,
        backgroundBlobs: const IList.empty(),
        isFavorited: false,
      )
      .copyWithColourloversPattern(pattern: pattern)
      .copyWith(
        colorViewStates:
            (pattern.colors ?? [])
                .map(
                  (hex) => ColorTileViewState(
                    id: hex,
                    title: hex,
                    numViews: 0,
                    numVotes: 0,
                    hex: hex,
                  ),
                )
                .toIList(),
        user: UserTileViewState.fromColourloverUser(loadedItems.lovers[3]),
        relatedPalettes:
            loadedItems.palettes
                .take(3)
                .map(PaletteTileViewState.fromColourloverPalette)
                .toIList(),
        relatedPatterns:
            loadedItems.patterns
                .skip(1)
                .take(3)
                .map(PatternTileViewState.fromColourloverPattern)
                .toIList(),
      );
}

UserDetailsViewState _createUserDetailsViewState(_LoadedItems loadedItems) {
  final lover = loadedItems.lovers[3];

  return defaultUserDetailsViewState
      .copyWith(
        isLoading: false,
        backgroundBlobs: const IList.empty(),
        isFavorited: false,
      )
      .copyWithColourloversLover(user: lover)
      .copyWith(
        userColors:
            loadedItems.colors
                .take(3)
                .map(ColorTileViewState.fromColourloverColor)
                .toIList(),
        userPalettes:
            loadedItems.palettes
                .take(3)
                .map(PaletteTileViewState.fromColourloverPalette)
                .toIList(),
        userPatterns:
            loadedItems.patterns
                .take(3)
                .map(PatternTileViewState.fromColourloverPattern)
                .toIList(),
      );
}

ColorsViewState _createColorsListViewState(_LoadedItems loadedItems) {
  return defaultColorsViewState.copyWith(
    itemsList: defaultColorsListViewState.copyWith(
      items:
          loadedItems.colors
              .map(ColorTileViewState.fromColourloverColor)
              .toIList(),
      isLoading: false,
      hasMoreItems: false,
    ),
  );
}

PalettesViewState _createPalettesListViewState(_LoadedItems loadedItems) {
  return defaultPalettesViewState.copyWith(
    itemsList: defaultPalettesListViewState.copyWith(
      items:
          loadedItems.palettes
              .map(PaletteTileViewState.fromColourloverPalette)
              .toIList(),
      isLoading: false,
      hasMoreItems: false,
    ),
  );
}

PatternsViewState _createPatternsListViewState(_LoadedItems loadedItems) {
  return defaultPatternsViewState.copyWith(
    itemsList: defaultPatternsListViewState.copyWith(
      items:
          loadedItems.patterns
              .map(PatternTileViewState.fromColourloverPattern)
              .toIList(),
      isLoading: false,
      hasMoreItems: false,
    ),
  );
}

UsersViewState _createUsersListViewState(_LoadedItems loadedItems) {
  return defaultUsersViewState.copyWith(
    itemsList: defaultUsersListViewState.copyWith(
      items:
          loadedItems.lovers
              .map(UserTileViewState.fromColourloverUser)
              .toIList(),
      isLoading: false,
      hasMoreItems: false,
    ),
  );
}

extension ColourloversPatternCopyWith on ColourloversPattern {
  ColourloversPattern copyWith({
    int? id,
    String? title,
    String? userName,
    int? numViews,
    int? numVotes,
    int? numComments,
    int? numHearts,
    int? rank,
    DateTime? dateCreated,
    List<String>? colors,
    String? description,
    String? url,
    String? imageUrl,
    String? badgeUrl,
    String? apiUrl,
    ColourloversTemplate? template,
  }) {
    return ColourloversPattern(
      id: id ?? this.id,
      title: title ?? this.title,
      userName: userName ?? this.userName,
      numViews: numViews ?? this.numViews,
      numVotes: numVotes ?? this.numVotes,
      numComments: numComments ?? this.numComments,
      numHearts: numHearts ?? this.numHearts,
      rank: rank ?? this.rank,
      dateCreated: dateCreated ?? this.dateCreated,
      colors: colors ?? this.colors,
      description: description ?? this.description,
      url: url ?? this.url,
      imageUrl: imageUrl ?? this.imageUrl,
      badgeUrl: badgeUrl ?? this.badgeUrl,
      apiUrl: apiUrl ?? this.apiUrl,
      template: template ?? this.template,
    );
  }
}
