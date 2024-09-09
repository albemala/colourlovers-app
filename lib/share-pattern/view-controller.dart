import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/app/routing.dart';
import 'package:colourlovers_app/clipboard.dart';
import 'package:colourlovers_app/share-pattern/view-state.dart';
import 'package:colourlovers_app/urls/functions.dart';
import 'package:colourlovers_app/widgets/snack-bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SharePatternViewController extends Cubit<SharePatternViewState> {
  factory SharePatternViewController.fromContext(
    BuildContext context, {
    required ColourloversPattern pattern,
  }) {
    return SharePatternViewController(
      pattern,
    );
  }

  final ColourloversPattern _pattern;

  SharePatternViewController(
    this._pattern,
  ) : super(defaultSharePatternViewState) {
    _init();
  }

  Future<void> _init() async {
    emit(
      SharePatternViewState.fromColourloversPattern(_pattern),
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
