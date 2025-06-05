import 'dart:convert';
import 'dart:io';

import 'package:colourlovers_app/favorites/data-state.dart';
import 'package:crypto/crypto.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';

/// Migrates favorites data from v1 format to v2 format
Future<FavoritesDataState?> migrateV1FavoritesData() async {
  final rawData = await _readRawFavoritesData();
  if (rawData == null) return null;

  return _parseV1FavoritesData(rawData);
}

/// Reads raw favorites data from either MD5 hashed file or manifest.json
Future<String?> _readRawFavoritesData() async {
  final appDocumentsDirectory = await getApplicationDocumentsDirectory();
  final rctAsyncLocalStorageV1Path =
      '${appDocumentsDirectory.path}/RCTAsyncLocalStorage_V1';
  const favoritesKey = 'me.albemala.luv.Favorites';
  final favoritesKeyMd5 = md5.convert(utf8.encode(favoritesKey)).toString();

  // Try MD5 hashed file first
  final md5File = File('$rctAsyncLocalStorageV1Path/$favoritesKeyMd5');
  if (md5File.existsSync()) {
    try {
      return md5File.readAsStringSync();
    } catch (e) {
      debugPrint('Error reading MD5 hashed file: $e');
    }
  }

  // Fallback to manifest.json
  final manifestFile = File('$rctAsyncLocalStorageV1Path/manifest.json');
  if (manifestFile.existsSync()) {
    try {
      final manifestContent = manifestFile.readAsStringSync();
      final manifestJson = jsonDecode(manifestContent) as Map<String, dynamic>;
      final favoritesValue = manifestJson[favoritesKey];

      return favoritesValue is String ? favoritesValue : null;
    } catch (e) {
      debugPrint('Error reading manifest.json: $e');
    }
  }

  return null;
}

/// Parses v1 favorites data and converts to v2 format
FavoritesDataState _parseV1FavoritesData(String rawData) {
  try {
    final parsedData = jsonDecode(rawData) as Map<String, dynamic>;
    final items = parsedData['items'] as Map<String, dynamic>;

    final favorites =
        items.entries
            .map(
              (entry) => _createFavoriteItem(
                entry.key,
                entry.value as Map<String, dynamic>,
              ),
            )
            .toList();

    return FavoritesDataState(favorites: IList(favorites));
  } catch (e) {
    debugPrint('Error parsing v1 favorites data: $e');
    return defaultFavoritesDataState;
  }
}

/// Creates a FavoriteItem from v1 data
FavoriteItem _createFavoriteItem(String key, Map<String, dynamic> itemData) {
  final (type, id) = _parseItemKey(key);

  return FavoriteItem(
    type: type,
    id: id,
    timeAdded: DateTime.now().millisecondsSinceEpoch,
    data: IMap(itemData),
  );
}

/// Parses item key and returns type and id as a record
(FavoriteItemType, String) _parseItemKey(String key) {
  final match = RegExp(r'^(Color|Palette|Pattern|Lover)-(.+)$').firstMatch(key);
  if (match == null) return (FavoriteItemType.unknown, '');

  return (
    switch (match.group(1)) {
      'Color' => FavoriteItemType.color,
      'Palette' => FavoriteItemType.palette,
      'Pattern' => FavoriteItemType.pattern,
      'Lover' => FavoriteItemType.user,
      _ => FavoriteItemType.unknown,
    },
    match.group(2)!,
  );
}
