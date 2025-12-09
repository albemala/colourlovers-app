import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/filters/defines.dart';
import 'package:colourlovers_app/filters/pattern/data-state.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_data_storage/flutter_data_storage.dart';

class PatternFiltersDataController
    extends StoredCubit<PatternFiltersDataState> {
  PatternFiltersDataController() : super(PatternFiltersDataState.initial());

  factory PatternFiltersDataController.fromContext(BuildContext context) {
    return PatternFiltersDataController();
  }

  @override
  Future<void> migrateData() async {}

  @override
  String get storeName => 'pattern_filters';

  @override
  PatternFiltersDataState fromMap(Map<String, dynamic> json) {
    return PatternFiltersDataState.fromMap(json);
  }

  @override
  Map<String, dynamic> toMap(PatternFiltersDataState state) {
    return state.toMap();
  }

  ContentShowCriteria get showCriteria => state.showCriteria;
  set showCriteria(ContentShowCriteria value) =>
      emit(state.copyWith(showCriteria: value));

  ColourloversRequestOrderBy get sortBy => state.sortBy;
  set sortBy(ColourloversRequestOrderBy value) =>
      emit(state.copyWith(sortBy: value));

  ColourloversRequestSortBy get sortOrder => state.sortOrder;
  set sortOrder(ColourloversRequestSortBy value) =>
      emit(state.copyWith(sortOrder: value));

  ColorFilter get colorFilter => state.colorFilter;
  set colorFilter(ColorFilter value) =>
      emit(state.copyWith(colorFilter: value));

  IList<ColourloversRequestHueRange> get hueRanges => state.hueRanges;
  set hueRanges(IList<ColourloversRequestHueRange> value) =>
      emit(state.copyWith(hueRanges: value));

  String get hex => state.hex;
  set hex(String value) => emit(state.copyWith(hex: value));

  String get patternName => state.patternName;
  set patternName(String value) => emit(state.copyWith(patternName: value));

  String get userName => state.userName;
  set userName(String value) => emit(state.copyWith(userName: value));
}
