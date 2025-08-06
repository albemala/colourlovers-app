import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class AppUsageDataState extends Equatable {
  final int usageCount;
  final int favoritesCount;

  const AppUsageDataState({
    required this.usageCount,
    required this.favoritesCount,
  });

  @override
  List<Object> get props => [usageCount, favoritesCount];

  AppUsageDataState copyWith({int? usageCount, int? favoritesCount}) {
    return AppUsageDataState(
      usageCount: usageCount ?? this.usageCount,
      favoritesCount: favoritesCount ?? this.favoritesCount,
    );
  }

  Map<String, dynamic> toMap() {
    return {'usageCount': usageCount, 'favoritesCount': favoritesCount};
  }

  factory AppUsageDataState.fromMap(Map<String, dynamic> map) {
    return switch (map) {
      {
        'usageCount': final int usageCount,
        'favoritesCount': final int favoritesCount,
      } =>
        AppUsageDataState(
          usageCount: usageCount,
          favoritesCount: favoritesCount,
        ),
      _ => defaultAppUsageDataState,
    };
  }
}

const defaultAppUsageDataState = AppUsageDataState(
  usageCount: 0,
  favoritesCount: 0,
);
