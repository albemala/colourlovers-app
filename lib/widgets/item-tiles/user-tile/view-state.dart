import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class UserTileViewState extends Equatable {
  final String userName;
  final int numColors;
  final int numPalettes;
  final int numPatterns;

  const UserTileViewState({
    required this.userName,
    required this.numColors,
    required this.numPalettes,
    required this.numPatterns,
  });

  @override
  List<Object?> get props => [userName, numColors, numPalettes, numPatterns];

  UserTileViewState copyWith({
    String? userName,
    int? numColors,
    int? numPalettes,
    int? numPatterns,
  }) {
    return UserTileViewState(
      userName: userName ?? this.userName,
      numColors: numColors ?? this.numColors,
      numPalettes: numPalettes ?? this.numPalettes,
      numPatterns: numPatterns ?? this.numPatterns,
    );
  }

  factory UserTileViewState.fromColourloverUser(
    ColourloversLover user,
  ) {
    return UserTileViewState(
      userName: user.userName ?? '',
      numColors: user.numColors ?? 0,
      numPalettes: user.numPalettes ?? 0,
      numPatterns: user.numPatterns ?? 0,
    );
  }
}

const defaultUserTileViewState = UserTileViewState(
  userName: '',
  numColors: 0,
  numPalettes: 0,
  numPatterns: 0,
);
