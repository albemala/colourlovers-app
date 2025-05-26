import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/color-filters/data-state.dart';
import 'package:colourlovers_app/filters/defines.dart';
import 'package:flutter_data_storage/flutter_data_storage.dart';

class ColorFiltersDataController extends StoredCubit<ColorFiltersDataState> {
  ColorFiltersDataController() : super(defaultColorFiltersDataState);

  @override
  Future<void> migrateData() async {}

  @override
  String get storeName => 'color_filters';

  @override
  ColorFiltersDataState fromMap(Map<String, dynamic> json) {
    return ColorFiltersDataState.fromMap(json);
  }

  @override
  Map<String, dynamic> toMap(ColorFiltersDataState state) {
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

  int get hueMin => state.hueMin;
  set hueMin(int value) => emit(state.copyWith(hueMin: value));

  int get hueMax => state.hueMax;
  set hueMax(int value) => emit(state.copyWith(hueMax: value));

  int get brightnessMin => state.brightnessMin;
  set brightnessMin(int value) => emit(state.copyWith(brightnessMin: value));

  int get brightnessMax => state.brightnessMax;
  set brightnessMax(int value) => emit(state.copyWith(brightnessMax: value));

  String get colorName => state.colorName;
  set colorName(String value) => emit(state.copyWith(colorName: value));

  String get userName => state.userName;
  set userName(String value) => emit(state.copyWith(userName: value));
}
