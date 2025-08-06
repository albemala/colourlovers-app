import 'dart:async';

import 'package:colourlovers_app/app/view-state.dart';
import 'package:colourlovers_app/app_usage/data-controller.dart';
import 'package:colourlovers_app/preferences/data-controller.dart';
import 'package:colourlovers_app/preferences/data-state.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppViewController extends Cubit<AppViewState> {
  final AppUsageDataController appUsageDataController;
  final PreferencesDataController _preferencesDataController;

  StreamSubscription<PreferencesDataState>?
  _preferencesDataControllerSubscription;

  factory AppViewController.fromContext(BuildContext context) {
    return AppViewController(
      context.read<AppUsageDataController>(),
      context.read<PreferencesDataController>(),
    );
  }

  AppViewController(
    this.appUsageDataController,
    this._preferencesDataController,
  ) : super(defaultAppViewState) {
    _preferencesDataControllerSubscription = _preferencesDataController.stream
        .listen((_) {
          _updateState();
        });
    _updateState();

    // Wait for data controllers initialization
    _waitForInitialization();
  }

  @override
  Future<void> close() {
    _preferencesDataControllerSubscription?.cancel();
    return super.close();
  }

  Future<void> _waitForInitialization() async {
    await Future.wait([appUsageDataController.initializationComplete]);

    // Increment usage count after initialization is complete
    appUsageDataController.incrementUsageCount();

    _updateState();
  }

  void _updateState() {
    emit(
      state.copyWith(
        themeMode: _preferencesDataController.state.themeMode,
        flexScheme: _preferencesDataController.state.flexScheme,
        isLoading: !appUsageDataController.isInitialized.value,
      ),
    );
  }
}
