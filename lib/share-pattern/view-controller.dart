import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/app/routing.dart';
import 'package:colourlovers_app/clipboard.dart';
import 'package:colourlovers_app/share-pattern/view-state.dart';
import 'package:colourlovers_app/urls/functions.dart';
import 'package:colourlovers_app/widgets/background/functions.dart';
import 'package:colourlovers_app/widgets/snack-bar.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SharePatternViewController extends Cubit<SharePatternViewState> {
  final ColourloversPattern _pattern;

  factory SharePatternViewController.fromContext(
    BuildContext context, {
    required ColourloversPattern pattern,
  }) {
    return SharePatternViewController(
      pattern,
    );
  }

  SharePatternViewController(
    this._pattern,
  ) : super(defaultSharePatternViewState) {
    emit(state.copyWith(
        backgroundBlobs:
            generateBackgroundBlobs(getRandomPalette()).toIList()));
    _init();
  }

  Future<void> _init() async {
    emit(
      state.copyWith(
        colors: IList(_pattern.colors ?? []),
        imageUrl: httpToHttps(_pattern.imageUrl ?? ''),
        templateUrl: httpToHttps(_pattern.template?.url ?? ''),
      ),
    );
  }

  Future<void> copyColorToClipboard(BuildContext context, String color) async {
    await copyToClipboard(color);
    showSnackBar(context, createCopiedToClipboardSnackBar(color));
  }

  void shareImage() {
    openUrl(state.imageUrl);
  }

  void shareTemplate() {
    openUrl(state.templateUrl);
  }
}
