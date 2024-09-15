import 'package:colourlovers_app/widgets/background/defines.dart';
import 'package:colourlovers_app/widgets/item-tiles/color-tile/view-state.dart';
import 'package:colourlovers_app/widgets/item-tiles/palette-tile/view-state.dart';
import 'package:colourlovers_app/widgets/item-tiles/pattern-tile/view-state.dart';
import 'package:equatable/equatable.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';

@immutable
class UserDetailsViewState extends Equatable {
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
  final IList<ColorTileViewState> userColors;
  final IList<PaletteTileViewState> userPalettes;
  final IList<PatternTileViewState> userPatterns;
  final IList<BackgroundBlob> backgroundBlobs;

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
    required this.backgroundBlobs,
  });

  @override
  List<Object?> get props => [
        isLoading,
        userName,
        numColors,
        numPalettes,
        numPatterns,
        rating,
        numLovers,
        location,
        dateRegistered,
        dateLastActive,
        userColors,
        userPalettes,
        userPatterns,
        backgroundBlobs,
      ];

  UserDetailsViewState copyWith({
    bool? isLoading,
    String? userName,
    String? numColors,
    String? numPalettes,
    String? numPatterns,
    String? rating,
    String? numLovers,
    String? location,
    String? dateRegistered,
    String? dateLastActive,
    IList<ColorTileViewState>? userColors,
    IList<PaletteTileViewState>? userPalettes,
    IList<PatternTileViewState>? userPatterns,
    IList<BackgroundBlob>? backgroundBlobs,
  }) {
    return UserDetailsViewState(
      isLoading: isLoading ?? this.isLoading,
      userName: userName ?? this.userName,
      numColors: numColors ?? this.numColors,
      numPalettes: numPalettes ?? this.numPalettes,
      numPatterns: numPatterns ?? this.numPatterns,
      rating: rating ?? this.rating,
      numLovers: numLovers ?? this.numLovers,
      location: location ?? this.location,
      dateRegistered: dateRegistered ?? this.dateRegistered,
      dateLastActive: dateLastActive ?? this.dateLastActive,
      userColors: userColors ?? this.userColors,
      userPalettes: userPalettes ?? this.userPalettes,
      userPatterns: userPatterns ?? this.userPatterns,
      backgroundBlobs: backgroundBlobs ?? this.backgroundBlobs,
    );
  }
}

const defaultUserDetailsViewState = UserDetailsViewState(
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
  userColors: IList.empty(),
  userPalettes: IList.empty(),
  userPatterns: IList.empty(),
  backgroundBlobs: IList.empty(),
);
