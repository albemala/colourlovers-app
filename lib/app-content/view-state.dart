import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

enum MainRoute {
  explore,
  favorites,
  preferences,
  about,
  test,
}

@immutable
class AppContentViewState extends Equatable {
  final MainRoute currentRoute;

  const AppContentViewState({
    required this.currentRoute,
  });

  @override
  List<Object> get props => [
        currentRoute,
      ];

  AppContentViewState copyWith({
    MainRoute? currentRoute,
  }) {
    return AppContentViewState(
      currentRoute: currentRoute ?? this.currentRoute,
    );
  }
}

const defaultAppContentViewState = AppContentViewState(
  currentRoute: MainRoute.explore,
);
