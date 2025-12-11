import 'dart:async';

import 'package:collection/collection.dart';
import 'package:colourlovers_app/app_usage/data-controller.dart';
import 'package:colourlovers_app/favorites/data-state.dart';
import 'package:colourlovers_app/favorites/v1_data_migration.dart';
import 'package:colourlovers_app/review.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_data_storage/flutter_data_storage.dart';

const favoritesDataStoreName = 'favorites';

class FavoritesDataController extends StoredCubit<FavoritesDataState> {
  final AppUsageDataController appUsageDataController;
  factory FavoritesDataController.fromContext(BuildContext context) {
    return FavoritesDataController(
      appUsageDataController: context.read<AppUsageDataController>(),
    );
  }

  FavoritesDataController({required this.appUsageDataController})
    : super(FavoritesDataState.initial());

  @override
  Future<void> migrateData() async {
    if (await dataStore.dataExists) return;

    final v1FavoritesData = await migrateV1FavoritesData();
    if (v1FavoritesData != null) {
      await dataStore.writeImmediately(v1FavoritesData.toMap());
    }
  }

  @override
  String get storeName => favoritesDataStoreName;

  @override
  FavoritesDataState fromMap(Map<String, dynamic> json) {
    return FavoritesDataState.fromMap(json);
  }

  @override
  Map<String, dynamic> toMap(FavoritesDataState state) {
    return state.toMap();
  }

  IList<FavoriteItem> get favorites => state.favorites;
  set favorites(IList<FavoriteItem> value) =>
      emit(state.copyWith(favorites: value));

  bool isFavorite(FavoriteItemType type, String id) {
    return state.favorites.any((item) => item.type == type && item.id == id);
  }

  void addFavorite(
    FavoriteItemType type,
    String id,
    IMap<String, dynamic> data,
  ) {
    if (!isFavorite(type, id)) {
      final newItem = FavoriteItem(
        type: type,
        id: id,
        timeAdded: DateTime.now().millisecondsSinceEpoch,
        data: data,
      );
      favorites = state.favorites.add(newItem);

      // Increment the favorites count
      appUsageDataController.incrementFavoritesCount();
      final shouldShowReviewDialog =
          appUsageDataController.favoritesCount > 0 &&
          appUsageDataController.favoritesCount % 3 == 0;
      if (shouldShowReviewDialog) {
        unawaited(showReviewDialog());
      }
    }
  }

  void removeFavorite(FavoriteItemType type, String id) {
    favorites = state.favorites.removeWhere(
      (item) => item.type == type && item.id == id,
    );
  }

  void toggleFavorite(
    FavoriteItemType type,
    String id,
    IMap<String, dynamic> data,
  ) {
    if (isFavorite(type, id)) {
      removeFavorite(type, id);
    } else {
      addFavorite(type, id, data);
    }
  }

  FavoriteItem? findFavorite(String id, FavoriteItemType type) {
    return favorites.firstWhereOrNull(
      (item) => item.type == type && item.id == id,
    );
  }

  void removeAllFavorites() {
    favorites = const IList.empty();
  }
}
