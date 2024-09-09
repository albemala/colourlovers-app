import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/color-details/view.dart';
import 'package:colourlovers_app/palette-details/view.dart';
import 'package:colourlovers_app/pattern-details/view.dart';
import 'package:colourlovers_app/user-details/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@immutable
class ItemDetailsViewState {
  final ColourloversColor? color;
  final ColourloversPalette? palette;
  final ColourloversPattern? pattern;
  final ColourloversLover? user;

  const ItemDetailsViewState({
    this.color,
    this.palette,
    this.pattern,
    this.user,
  });

  factory ItemDetailsViewState.initialState() {
    return const ItemDetailsViewState();
  }
}

class ItemDetailsViewController extends Cubit<ItemDetailsViewState> {
  factory ItemDetailsViewController.fromContext(BuildContext context) {
    return ItemDetailsViewController(
      ColourloversApiClient(),
    );
  }

  final ColourloversApiClient _client;

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

class ItemDetailsTestViewCreator extends StatelessWidget {
  const ItemDetailsTestViewCreator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: ItemDetailsViewController.fromContext,
      child: BlocBuilder<ItemDetailsViewController, ItemDetailsViewState>(
        builder: (context, state) {
          return ItemDetailsTestView(
            state: state,
            controller: context.read<ItemDetailsViewController>(),
          );
        },
      ),
    );
  }
}

class ItemDetailsTestView extends StatelessWidget {
  final ItemDetailsViewState state;
  final ItemDetailsViewController controller;

  const ItemDetailsTestView({
    super.key,
    required this.state,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: state.color != null
              ? ColorDetailsViewCreator(color: state.color!)
              : const Center(child: CircularProgressIndicator()),
        ),
        Expanded(
          child: state.palette != null
              ? PaletteDetailsViewCreator(palette: state.palette!)
              : const Center(child: CircularProgressIndicator()),
        ),
        Expanded(
          child: state.pattern != null
              ? PatternDetailsViewCreator(pattern: state.pattern!)
              : const Center(child: CircularProgressIndicator()),
        ),
        Expanded(
          child: state.user != null
              ? UserDetailsViewCreator(user: state.user!)
              : const Center(child: CircularProgressIndicator()),
        ),
      ],
    );
  }
}
