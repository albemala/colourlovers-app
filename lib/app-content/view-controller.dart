import 'package:colourlovers_app/app-content/view-state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppContentViewController extends Cubit<AppContentViewState> {
  AppContentViewController() : super(defaultAppContentViewState);

  void setCurrentRoute(int index) {
    emit(
      state.copyWith(
        currentRoute: MainRoute.values[index],
      ),
    );
  }
}
