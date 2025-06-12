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
import 'package:colourlovers_app/filters/color/view-state.dart';
import 'package:colourlovers_app/filters/color/view.dart';
import 'package:colourlovers_app/filters/defines.dart';
import 'package:colourlovers_app/filters/favorites/defines.dart';
import 'package:colourlovers_app/filters/favorites/view-state.dart';
import 'package:colourlovers_app/filters/favorites/view.dart';
import 'package:colourlovers_app/filters/palette/view-state.dart';
import 'package:colourlovers_app/filters/palette/view.dart';
import 'package:colourlovers_app/filters/pattern/view-state.dart';
import 'package:colourlovers_app/filters/pattern/view.dart';
import 'package:colourlovers_app/filters/user/view-state.dart';
import 'package:colourlovers_app/filters/user/view.dart';
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
import 'package:colourlovers_app/share/color/view-state.dart';
import 'package:colourlovers_app/share/color/view.dart';
import 'package:colourlovers_app/share/palette/view-state.dart';
import 'package:colourlovers_app/share/palette/view.dart';
import 'package:colourlovers_app/share/pattern/view-state.dart';
import 'package:colourlovers_app/share/pattern/view.dart';
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

  final shareViews = <ScreenshotData>[
    ScreenshotData(
      view: NavigatorView(
        child: ShareColorView(
          controller: MockShareColorViewController(),
          state: _createShareColorViewState(loadedItems),
        ),
      ),
      fileName: 'share_color_view',
    ),
    ScreenshotData(
      view: NavigatorView(
        child: SharePaletteView(
          controller: MockSharePaletteViewController(),
          state: _createSharePaletteViewState(loadedItems),
        ),
      ),
      fileName: 'share_palette_view',
    ),
    ScreenshotData(
      view: NavigatorView(
        child: SharePatternView(
          controller: MockSharePatternViewController(),
          state: _createSharePatternViewState(loadedItems),
        ),
      ),
      fileName: 'share_pattern_view',
    ),
  ];

  final filterViews = <ScreenshotData>[
    ScreenshotData(
      view: NavigatorView(
        child: ColorFiltersView(
          controller: MockColorFiltersViewController(),
          state: _createColorFiltersViewState(loadedItems),
        ),
      ),
      fileName: 'color_filters_view',
    ),
    ScreenshotData(
      view: NavigatorView(
        child: PaletteFiltersView(
          controller: MockPaletteFiltersViewController(),
          state: _createPaletteFiltersViewState(loadedItems),
        ),
      ),
      fileName: 'palette_filters_view',
    ),
    ScreenshotData(
      view: NavigatorView(
        child: PatternFiltersView(
          controller: MockPatternFiltersViewController(),
          state: _createPatternFiltersViewState(loadedItems),
        ),
      ),
      fileName: 'pattern_filters_view',
    ),
    ScreenshotData(
      view: NavigatorView(
        child: UserFiltersView(
          controller: MockUserFiltersViewController(),
          state: _createUserFiltersViewState(loadedItems),
        ),
      ),
      fileName: 'user_filters_view',
    ),
    ScreenshotData(
      view: NavigatorView(
        child: FavoritesFiltersView(
          controller: MockFavoritesFiltersViewController(),
          state: _createFavoritesFiltersViewState(loadedItems),
        ),
      ),
      fileName: 'favorites_filters_view',
    ),
  ];

  return [
    ...appContentViews,
    ...listViews,
    ...detailsViews,
    ...shareViews,
    // ...filterViews,
  ];
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

  // Update imageUrl for colors
  final updatedColors =
      colors.map((color) {
        return color.copyWith(
          imageUrl: 'asset://assets/items/colors/${color.id}.png',
        );
      }).toList();

  // Update imageUrl for palettes
  final updatedPalettes =
      palettes.map((palette) {
        return palette.copyWith(
          imageUrl: 'asset://assets/items/palettes/${palette.id}.png',
        );
      }).toList();

  // Update imageUrl for patterns
  final updatedPatterns =
      patterns.map((pattern) {
        return pattern.copyWith(
          imageUrl: 'asset://assets/items/patterns/${pattern.id}.png',
        );
      }).toList();

  final lovers =
      loversJson
          .map((e) => ColourloversLover.fromJson(e as Map<String, dynamic>))
          .toList();

  return _LoadedItems(
    colors: updatedColors,
    palettes: updatedPalettes,
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

ShareColorViewState _createShareColorViewState(_LoadedItems loadedItems) {
  final color = loadedItems.colors[3];
  return defaultShareColorViewState.copyWith(
    hex: color.hex,
    imageUrl: 'asset://assets/items/colors/${color.id}.png',
    backgroundBlobs: const IList.empty(),
  );
}

SharePaletteViewState _createSharePaletteViewState(_LoadedItems loadedItems) {
  final palette = loadedItems.palettes[0];
  return defaultSharePaletteViewState.copyWith(
    colors: IList(palette.colors ?? []),
    colorWidths: IList(palette.colorWidths ?? []),
    imageUrl: 'asset://assets/items/palettes/${palette.id}.png',
    backgroundBlobs: const IList.empty(),
  );
}

SharePatternViewState _createSharePatternViewState(_LoadedItems loadedItems) {
  final pattern = loadedItems.patterns[0];
  return defaultSharePatternViewState.copyWith(
    colors: IList(pattern.colors ?? []),
    imageUrl: 'asset://assets/items/patterns/${pattern.id}.png',
    templateUrl: 'asset://assets/items/patterns/${pattern.id}.png',
    backgroundBlobs: const IList.empty(),
  );
}

ColorFiltersViewState _createColorFiltersViewState(_LoadedItems loadedItems) {
  return defaultColorFiltersViewState.copyWith(
    showCriteria: ContentShowCriteria.top,
    sortBy: ColourloversRequestOrderBy.numVotes,
    sortOrder: ColourloversRequestSortBy.ASC,
    hueMin: 100,
    hueMax: 200,
    brightnessMin: 20,
    brightnessMax: 80,
    backgroundBlobs: const IList.empty(),
  );
}

PaletteFiltersViewState _createPaletteFiltersViewState(
  _LoadedItems loadedItems,
) {
  return defaultPaletteFiltersViewState.copyWith(
    showCriteria: ContentShowCriteria.top,
    sortBy: ColourloversRequestOrderBy.numVotes,
    sortOrder: ColourloversRequestSortBy.ASC,
    colorFilter: ColorFilter.hueRanges,
    hueRanges: IList(const [
      ColourloversRequestHueRange.blue,
      ColourloversRequestHueRange.green,
    ]),
    backgroundBlobs: const IList.empty(),
  );
}

PatternFiltersViewState _createPatternFiltersViewState(
  _LoadedItems loadedItems,
) {
  return defaultPatternFiltersViewState.copyWith(
    showCriteria: ContentShowCriteria.top,
    sortBy: ColourloversRequestOrderBy.numVotes,
    sortOrder: ColourloversRequestSortBy.ASC,
    colorFilter: ColorFilter.hueRanges,
    hueRanges: IList(const [
      ColourloversRequestHueRange.red,
      ColourloversRequestHueRange.yellow,
    ]),
    backgroundBlobs: const IList.empty(),
  );
}

UserFiltersViewState _createUserFiltersViewState(_LoadedItems loadedItems) {
  return defaultUserFiltersViewState.copyWith(
    showCriteria: ContentShowCriteria.top,
    sortBy: ColourloversRequestOrderBy.numVotes,
    sortOrder: ColourloversRequestSortBy.ASC,
    backgroundBlobs: const IList.empty(),
  );
}

FavoritesFiltersViewState _createFavoritesFiltersViewState(
  _LoadedItems loadedItems,
) {
  return defaultFavoritesFiltersViewState.copyWith(
    typeFilter: FavoriteItemTypeFilter.palette,
    sortBy: FavoriteSortBy.timeAdded,
    sortOrder: FavoriteSortOrder.ascending,
    backgroundBlobs: const IList.empty(),
  );
}

extension ColourloversColorCopyWith on ColourloversColor {
  ColourloversColor copyWith({
    int? id,
    String? title,
    String? userName,
    int? numViews,
    int? numVotes,
    int? numComments,
    double? numHearts,
    int? rank,
    DateTime? dateCreated,
    String? hex,
    Rgb? rgb,
    Hsv? hsv,
    String? description,
    String? url,
    String? imageUrl,
    String? badgeUrl,
    String? apiUrl,
  }) {
    return ColourloversColor(
      id: id ?? this.id,
      title: title ?? this.title,
      userName: userName ?? this.userName,
      numViews: numViews ?? this.numViews,
      numVotes: numVotes ?? this.numVotes,
      numComments: numComments ?? this.numComments,
      numHearts: numHearts ?? this.numHearts,
      rank: rank ?? this.rank,
      dateCreated: dateCreated ?? this.dateCreated,
      hex: hex ?? this.hex,
      rgb: rgb ?? this.rgb,
      hsv: hsv ?? this.hsv,
      description: description ?? this.description,
      url: url ?? this.url,
      imageUrl: imageUrl ?? this.imageUrl,
      badgeUrl: badgeUrl ?? this.badgeUrl,
      apiUrl: apiUrl ?? this.apiUrl,
    );
  }
}

extension ColourloversPaletteCopyWith on ColourloversPalette {
  ColourloversPalette copyWith({
    int? id,
    String? title,
    String? userName,
    int? numViews,
    int? numVotes,
    int? numComments,
    double? numHearts,
    int? rank,
    DateTime? dateCreated,
    List<String>? colors,
    List<double>? colorWidths,
    String? description,
    String? url,
    String? imageUrl,
    String? badgeUrl,
    String? apiUrl,
  }) {
    return ColourloversPalette(
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
      colorWidths: colorWidths ?? this.colorWidths,
      description: description ?? this.description,
      url: url ?? this.url,
      imageUrl: imageUrl ?? this.imageUrl,
      badgeUrl: badgeUrl ?? this.badgeUrl,
      apiUrl: apiUrl ?? this.apiUrl,
    );
  }
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
