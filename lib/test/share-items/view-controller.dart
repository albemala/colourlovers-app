import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/share-color/view.dart';
import 'package:colourlovers_app/share-palette/view.dart';
import 'package:colourlovers_app/share-pattern/view.dart';
import 'package:colourlovers_app/test/share-items/view-state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShareItemsViewController extends Cubit<ShareItemsViewState> {
  factory ShareItemsViewController.fromContext(BuildContext context) {
    return ShareItemsViewController(
      ColourloversApiClient(),
    );
  }

  final ColourloversApiClient _client;

  ShareItemsViewController(
    this._client,
  ) : super(defaultShareItemsViewState) {
    _init();
  }

  Future<void> _init() async {
    final color = await _client.getColor(hex: '1693A5');
    final palette = await _client.getPalette(id: 629637);
    final pattern = await _client.getPattern(id: 1101098);
    final user = await _client.getLover(userName: 'sunmeadow');

    emit(
      ShareItemsViewState(
        color: color,
        palette: palette,
        pattern: pattern,
        user: user,
      ),
    );
  }
}
