import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class UserTileViewState extends Equatable {
  final String id;
  final String userName;
  final int numColors;
  final int numPalettes;
  final int numPatterns;

  const UserTileViewState({
    required this.id,
    required this.userName,
    required this.numColors,
    required this.numPalettes,
    required this.numPatterns,
  });

  @override
  List<Object> get props => [id, userName, numColors, numPalettes, numPatterns];

  UserTileViewState copyWith({
    String? id,
    String? userName,
    int? numColors,
    int? numPalettes,
    int? numPatterns,
  }) {
    return UserTileViewState(
      id: id ?? this.id,
      userName: userName ?? this.userName,
      numColors: numColors ?? this.numColors,
      numPalettes: numPalettes ?? this.numPalettes,
      numPatterns: numPatterns ?? this.numPatterns,
    );
  }

  factory UserTileViewState.fromColourloverUser(ColourloversLover? user) {
    if (user == null) return defaultUserTileViewState;
    return UserTileViewState(
      id: user.userName ?? '',
      userName: user.userName ?? '',
      numColors: user.numColors ?? 0,
      numPalettes: user.numPalettes ?? 0,
      numPatterns: user.numPatterns ?? 0,
    );
  }
}

const defaultUserTileViewState = UserTileViewState(
  id: '',
  userName: '',
  numColors: 0,
  numPalettes: 0,
  numPatterns: 0,
);
