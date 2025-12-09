import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/filters/defines.dart';
import 'package:colourlovers_app/widgets/background/defines.dart';
import 'package:colourlovers_app/widgets/item-list/view-state.dart';
import 'package:colourlovers_app/widgets/item-tiles/user-tile/view-state.dart';
import 'package:equatable/equatable.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';

@immutable
class UsersViewState extends Equatable {
  // filters
  final ContentShowCriteria showCriteria;
  final ColourloversRequestOrderBy sortBy;
  final ColourloversRequestSortBy sortOrder;
  final String userName;

  // items
  final ItemListViewState<UserTileViewState> itemsList;
  final IList<BackgroundBlob> backgroundBlobs;

  const UsersViewState({
    required this.showCriteria,
    required this.sortBy,
    required this.sortOrder,
    required this.userName,
    required this.itemsList,
    required this.backgroundBlobs,
  });

  @override
  List<Object> get props => [
    showCriteria,
    sortBy,
    sortOrder,
    userName,
    itemsList,
    backgroundBlobs,
  ];

  UsersViewState copyWith({
    ContentShowCriteria? showCriteria,
    ColourloversRequestOrderBy? sortBy,
    ColourloversRequestSortBy? sortOrder,
    String? userName,
    ItemListViewState<UserTileViewState>? itemsList,
    IList<BackgroundBlob>? backgroundBlobs,
  }) {
    return UsersViewState(
      showCriteria: showCriteria ?? this.showCriteria,
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
      userName: userName ?? this.userName,
      itemsList: itemsList ?? this.itemsList,
      backgroundBlobs: backgroundBlobs ?? this.backgroundBlobs,
    );
  }

  factory UsersViewState.initial() {
    return UsersViewState(
      showCriteria: ContentShowCriteria.newest,
      sortBy: ColourloversRequestOrderBy.dateCreated,
      sortOrder: ColourloversRequestSortBy.DESC,
      userName: '',
      itemsList: ItemListViewState<UserTileViewState>.initial(),
      backgroundBlobs: const IList.empty(),
    );
  }
}
