import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/filters/defines.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class UserFiltersDataState extends Equatable {
  final ContentShowCriteria showCriteria;
  final ColourloversRequestOrderBy sortBy;
  final ColourloversRequestSortBy sortOrder;
  final String userName;

  const UserFiltersDataState({
    required this.showCriteria,
    required this.sortBy,
    required this.sortOrder,
    required this.userName,
  });

  @override
  List<Object> get props => [showCriteria, sortBy, sortOrder, userName];

  UserFiltersDataState copyWith({
    ContentShowCriteria? showCriteria,
    ColourloversRequestOrderBy? sortBy,
    ColourloversRequestSortBy? sortOrder,
    String? userName,
  }) {
    return UserFiltersDataState(
      showCriteria: showCriteria ?? this.showCriteria,
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
      userName: userName ?? this.userName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'showCriteria': showCriteria.name,
      'sortBy': sortBy.name,
      'sortOrder': sortOrder.name,
      'userName': userName,
    };
  }

  factory UserFiltersDataState.fromMap(Map<String, dynamic> map) {
    return switch (map) {
      {
        'showCriteria': final String showCriteria,
        'sortBy': final String sortBy,
        'sortOrder': final String sortOrder,
        'userName': final String userName,
      } =>
        UserFiltersDataState(
          showCriteria: ContentShowCriteria.values.byName(showCriteria),
          sortBy: ColourloversRequestOrderBy.values.byName(sortBy),
          sortOrder: ColourloversRequestSortBy.values.byName(sortOrder),
          userName: userName,
        ),
      _ => defaultUserFiltersDataState,
    };
  }
}

const defaultUserFiltersDataState = UserFiltersDataState(
  showCriteria: ContentShowCriteria.newest,
  sortBy: ColourloversRequestOrderBy.dateCreated,
  sortOrder: ColourloversRequestSortBy.DESC,
  userName: '',
);
