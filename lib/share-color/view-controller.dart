import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/app/routing.dart';
import 'package:colourlovers_app/clipboard.dart';
import 'package:colourlovers_app/share-color/view-state.dart';
import 'package:colourlovers_app/urls/functions.dart';
import 'package:colourlovers_app/widgets/snack-bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShareColorViewController extends Cubit<ShareColorViewState> {
  factory ShareColorViewController.fromContext(
    BuildContext context, {
    required ColourloversColor color,
  }) {
    return ShareColorViewController(
      color,
    );
  }

  final ColourloversColor _color;
  ShareColorViewController(
    this._color,
  ) : super(
          ShareColorViewState.initialState(),
        ) {
    _init();
  }

  Future<void> _init() async {
    emit(
      ShareColorViewState.fromColourloversColor(_color),
    );
  }

  Future<void> copyHexToClipboard(BuildContext context) async {
    await copyToClipboard(state.hex);
    showSnackBar(context, createCopiedToClipboardSnackBar(state.hex));
  }

  void shareImage() {
    openUrl(state.imageUrl);
  }
}
