import 'dart:async';

import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/test/share/view-state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShareItemsViewController extends Cubit<ShareItemsViewState> {
  final ColourloversApiClient _client;

  factory ShareItemsViewController.fromContext(BuildContext _) {
    return ShareItemsViewController(ColourloversApiClient());
  }

  ShareItemsViewController(this._client)
    : super(ShareItemsViewState.initial()) {
    unawaited(_init());
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
