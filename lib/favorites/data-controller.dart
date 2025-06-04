import 'package:collection/collection.dart';
import 'package:colourlovers_app/favorites/data-state.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_data_storage/flutter_data_storage.dart';

const favoritesDataStoreName = 'favorites';

class FavoritesDataController extends StoredCubit<FavoritesDataState> {
  factory FavoritesDataController.fromContext(BuildContext context) {
    return FavoritesDataController();
  }

  FavoritesDataController({@visibleForTesting DataStore? dataStore})
    : super(defaultFavoritesDataState, dataStore: dataStore);

  @override
  Future<void> migrateData() async {}

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
