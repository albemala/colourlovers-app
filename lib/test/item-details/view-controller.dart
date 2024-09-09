import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/test/item-details/view-state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ItemDetailsViewController extends Cubit<ItemDetailsViewState> {
  final ColourloversApiClient _client;

  factory ItemDetailsViewController.fromContext(BuildContext context) {
    return ItemDetailsViewController(
      ColourloversApiClient(),
    );
  }

  ItemDetailsViewController(
    this._client,
  ) : super(defaultItemDetailsViewState) {
    _init();
  }

  Future<void> _init() async {
    final color = await _client.getColor(hex: '1693A5');
    final palette = await _client.getPalette(id: 629637);
    final pattern = await _client.getPattern(id: 1101098);
    final user = await _client.getLover(userName: 'sunmeadow');

    emit(
      ItemDetailsViewState(
        color: color,
        palette: palette,
        pattern: pattern,
        user: user,
      ),
    );
  }
}
