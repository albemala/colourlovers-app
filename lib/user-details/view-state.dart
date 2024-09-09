import 'package:colourlovers_app/widgets/item-tiles.dart';
import 'package:flutter/material.dart';

@immutable
class UserDetailsViewState {
  final bool isLoading;
  final String userName;
  final String numColors;
  final String numPalettes;
  final String numPatterns;
  final String rating;
  final String numLovers;
  final String location;
  final String dateRegistered;
  final String dateLastActive;
  final List<ColorTileViewState> userColors;
  final List<PaletteTileViewState> userPalettes;
  final List<PatternTileViewState> userPatterns;

  const UserDetailsViewState({
    required this.isLoading,
    required this.userName,
    required this.numColors,
    required this.numPalettes,
    required this.numPatterns,
    required this.rating,
    required this.numLovers,
    required this.location,
    required this.dateRegistered,
    required this.dateLastActive,
    required this.userColors,
    required this.userPalettes,
    required this.userPatterns,
  });

  factory UserDetailsViewState.empty() {
    return const UserDetailsViewState(
      isLoading: true,
      userName: '',
      numColors: '',
      numPalettes: '',
      numPatterns: '',
      rating: '',
      numLovers: '',
      location: '',
      dateRegistered: '',
      dateLastActive: '',
      userColors: [],
      userPalettes: [],
      userPatterns: [],
    );
  }
}
