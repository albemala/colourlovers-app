import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/clipboard.dart';
import 'package:colourlovers_app/routing.dart';
import 'package:colourlovers_app/share-palette/view-state.dart';
import 'package:colourlovers_app/urls/functions.dart';
import 'package:colourlovers_app/widgets/background/functions.dart';
import 'package:colourlovers_app/widgets/snack-bar.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SharePaletteViewController extends Cubit<SharePaletteViewState> {
  final ColourloversPalette _palette;

  factory SharePaletteViewController.fromContext(
    BuildContext context, {
    required ColourloversPalette palette,
  }) {
    return SharePaletteViewController(palette);
  }

  SharePaletteViewController(this._palette)
    : super(defaultSharePaletteViewState) {
    emit(
      state.copyWith(
        backgroundBlobs: generateBackgroundBlobs(getRandomPalette()).toIList(),
      ),
    );
    _init();
  }

  Future<void> _init() async {
    emit(
      state.copyWith(
        colors: IList(_palette.colors ?? []),
        colorWidths: IList(_palette.colorWidths ?? []),
        imageUrl: httpToHttps(_palette.imageUrl ?? ''),
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
}
