import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/share-color/view.dart';
import 'package:colourlovers_app/share-palette/view.dart';
import 'package:colourlovers_app/share-pattern/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@immutable
class ShareItemsViewState {
  final ColourloversColor? color;
  final ColourloversPalette? palette;
  final ColourloversPattern? pattern;
  final ColourloversLover? user;

  const ShareItemsViewState({
    this.color,
    this.palette,
    this.pattern,
    this.user,
  });

  factory ShareItemsViewState.initialState() {
    return const ShareItemsViewState();
  }
}

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

class ShareItemsTestViewCreator extends StatelessWidget {
  const ShareItemsTestViewCreator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: ShareItemsViewController.fromContext,
      child: BlocBuilder<ShareItemsViewController, ShareItemsViewState>(
        builder: (context, state) {
          return ShareItemsTestView(
            state: state,
            controller: context.read<ShareItemsViewController>(),
          );
        },
      ),
    );
  }
}

class ShareItemsTestView extends StatelessWidget {
  final ShareItemsViewState state;
  final ShareItemsViewController controller;

  const ShareItemsTestView({
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
              ? ShareColorViewCreator(color: state.color!)
              : const Center(child: CircularProgressIndicator()),
        ),
        Expanded(
          child: state.palette != null
              ? SharePaletteViewCreator(palette: state.palette!)
              : const Center(child: CircularProgressIndicator()),
        ),
        Expanded(
          child: state.pattern != null
              ? SharePatternViewCreator(pattern: state.pattern!)
              : const Center(child: CircularProgressIndicator()),
        ),
      ],
    );
  }
}
