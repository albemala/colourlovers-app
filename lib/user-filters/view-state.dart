import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/filters/defines.dart';
import 'package:colourlovers_app/widgets/background/defines.dart';
import 'package:equatable/equatable.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';

@immutable
class UserFiltersViewState extends Equatable {
  final ContentShowCriteria showCriteria;
  final ColourloversRequestOrderBy sortBy;
  final ColourloversRequestSortBy sortOrder;
  final IList<BackgroundBlob> backgroundBlobs;

  const UserFiltersViewState({
    required this.showCriteria,
    required this.sortBy,
    required this.sortOrder,
    required this.backgroundBlobs,
  });

  @override
  List<Object?> get props => [showCriteria, sortBy, sortOrder, backgroundBlobs];

  UserFiltersViewState copyWith({
    ContentShowCriteria? showCriteria,
    ColourloversRequestOrderBy? sortBy,
    ColourloversRequestSortBy? sortOrder,
    IList<BackgroundBlob>? backgroundBlobs,
  }) {
    return UserFiltersViewState(
      showCriteria: showCriteria ?? this.showCriteria,
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
      backgroundBlobs: backgroundBlobs ?? this.backgroundBlobs,
    );
  }
}

const defaultUserFiltersViewState = UserFiltersViewState(
  showCriteria: ContentShowCriteria.newest,
  sortBy: ColourloversRequestOrderBy.dateCreated,
  sortOrder: ColourloversRequestSortBy.DESC,
  backgroundBlobs: IList.empty(),
);
