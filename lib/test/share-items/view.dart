import 'package:colourlovers_app/share-color/view.dart';
import 'package:colourlovers_app/share-palette/view.dart';
import 'package:colourlovers_app/share-pattern/view.dart';
import 'package:colourlovers_app/test/share-items/view-controller.dart';
import 'package:colourlovers_app/test/share-items/view-state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
