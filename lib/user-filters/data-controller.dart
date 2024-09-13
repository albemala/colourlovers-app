import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/filters/defines.dart';
import 'package:colourlovers_app/user-filters/data-state.dart';
import 'package:flutter_data_storage/flutter_data_storage.dart';

class UserFiltersDataController extends StoredCubit<UserFiltersDataState> {
  UserFiltersDataController() : super(defaultUserFiltersDataState);

  @override
  Future<void> migrateData() async {}

  @override
  String get storeName => 'user_filters';

  @override
  UserFiltersDataState fromMap(Map<String, dynamic> json) {
    return UserFiltersDataState.fromMap(json);
  }

  @override
  Map<String, dynamic> toMap(UserFiltersDataState state) {
    return state.toMap();
  }

  ContentShowCriteria get showCriteria => state.showCriteria;
  set showCriteria(ContentShowCriteria value) => emit(
        state.copyWith(
          showCriteria: value,
        ),
      );

  ColourloversRequestOrderBy get sortBy => state.sortBy;
  set sortBy(ColourloversRequestOrderBy value) => emit(
        state.copyWith(
          sortBy: value,
        ),
      );

  ColourloversRequestSortBy get sortOrder => state.sortOrder;
  set sortOrder(ColourloversRequestSortBy value) => emit(
        state.copyWith(
          sortOrder: value,
        ),
      );

  String get userName => state.userName;
  set userName(String value) => emit(
        state.copyWith(
          userName: value,
        ),
      );
}
