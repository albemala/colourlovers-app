import 'package:colourlovers_app/app-content/view-state.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppContentViewController extends Cubit<AppContentViewState> {
  factory AppContentViewController.fromContext(BuildContext context) {
    return AppContentViewController();
  }

  AppContentViewController() : super(AppContentViewState.initial());

  void setCurrentRoute(int index) {
    emit(state.copyWith(currentRoute: MainRoute.values[index]));
  }
}
