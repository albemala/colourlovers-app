import 'dart:async';

import 'package:colourlovers_app/app/view-state.dart';
import 'package:colourlovers_app/preferences/data-controller.dart';
import 'package:colourlovers_app/preferences/data-state.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppViewController extends Cubit<AppViewState> {
  final PreferencesDataController _preferencesDataController;

  StreamSubscription<PreferencesDataState>?
  _preferencesDataControllerSubscription;

  factory AppViewController.fromContext(BuildContext context) {
    return AppViewController(context.read<PreferencesDataController>());
  }

  AppViewController(this._preferencesDataController)
    : super(defaultAppViewState) {
    _preferencesDataControllerSubscription = _preferencesDataController.stream
        .listen((_) {
          _updateState();
        });
    _updateState();
  }

  @override
  Future<void> close() {
    _preferencesDataControllerSubscription?.cancel();
    return super.close();
  }

  void _updateState() {
    emit(
      AppViewState(
        themeMode: _preferencesDataController.state.themeMode,
        flexScheme: _preferencesDataController.state.flexScheme,
      ),
    );
  }
}
