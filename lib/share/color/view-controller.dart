import 'dart:async';

import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/clipboard.dart';
import 'package:colourlovers_app/routing.dart';
import 'package:colourlovers_app/share/color/view-state.dart';
import 'package:colourlovers_app/urls.dart';
import 'package:colourlovers_app/widgets/background/functions.dart';
import 'package:colourlovers_app/widgets/snack-bar.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShareColorViewController extends Cubit<ShareColorViewState> {
  final ColourloversColor _color;

  factory ShareColorViewController.fromContext(
    BuildContext _, {
    required ColourloversColor color,
  }) {
    return ShareColorViewController(color);
  }

  ShareColorViewController(this._color) : super(ShareColorViewState.initial()) {
    emit(
      state.copyWith(
        backgroundBlobs: generateBackgroundBlobs(getRandomPalette()).toIList(),
      ),
    );
    unawaited(_init());
  }

  Future<void> _init() async {
    emit(
      state.copyWith(
        hex: _color.hex ?? '',
        imageUrl: httpToHttps(_color.imageUrl ?? ''),
      ),
    );
  }

  Future<void> copyHexToClipboard(BuildContext context) async {
    await copyToClipboard(state.hex);
    if (!context.mounted) return;
    showSnackBar(context, createCopiedToClipboardSnackBar(state.hex));
  }

  void shareImage() {
    unawaited(openUrl(state.imageUrl));
  }
}
