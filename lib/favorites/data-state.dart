import 'package:equatable/equatable.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/foundation.dart';

@immutable
class FavoritesDataState extends Equatable {
  final IList<FavoriteItem> favorites;

  const FavoritesDataState({required this.favorites});

  @override
  List<Object> get props => [favorites];

  FavoritesDataState copyWith({IList<FavoriteItem>? favorites}) {
    return FavoritesDataState(favorites: favorites ?? this.favorites);
  }

  Map<String, dynamic> toMap() {
    return {'favorites': favorites.map((item) => item.toMap()).toList()};
  }

  factory FavoritesDataState.initial() {
    return const FavoritesDataState(favorites: IList.empty());
  }

  factory FavoritesDataState.fromMap(Map<String, dynamic> map) {
    return switch (map) {
      {'favorites': final List<dynamic> favorites} => FavoritesDataState(
        favorites: IList(
          favorites
              .cast<Map<String, dynamic>>()
              .map(FavoriteItem.fromMap)
              .toList(),
        ),
      ),
      _ => FavoritesDataState.initial(),
    };
  }
}

@immutable
class FavoriteItem extends Equatable {
  final FavoriteItemType type;
  final String id;
  final int timeAdded;
  final IMap<String, dynamic> data;

  const FavoriteItem({
    required this.type,
    required this.id,
    required this.timeAdded,
    required this.data,
  });

  @override
  List<Object> get props => [type, id, timeAdded, data];

  FavoriteItem copyWith({
    FavoriteItemType? type,
    String? id,
    int? timeAdded,
    IMap<String, dynamic>? data,
  }) {
    return FavoriteItem(
      type: type ?? this.type,
      id: id ?? this.id,
      timeAdded: timeAdded ?? this.timeAdded,
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type.name,
      'id': id,
      'timeAdded': timeAdded,
      'data': data.unlock,
    };
  }

  factory FavoriteItem.initial() {
    return const FavoriteItem(
      type: FavoriteItemType.unknown,
      id: '',
      timeAdded: 0,
      data: IMap.empty(),
    );
  }

  factory FavoriteItem.fromMap(Map<String, dynamic> map) {
    return switch (map) {
      {
        'type': final String type,
        'id': final String id,
        'timeAdded': final int timeAdded,
        'data': final Map<dynamic, dynamic> data,
      } =>
        FavoriteItem(
          type: FavoriteItemType.values.byName(type),
          id: id,
          timeAdded: timeAdded,
          data: IMap(data.cast<String, dynamic>()),
        ),
      _ => FavoriteItem.initial(),
    };
  }
}

enum FavoriteItemType { color, palette, pattern, user, unknown }
