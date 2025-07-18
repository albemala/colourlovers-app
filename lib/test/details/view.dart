import 'package:colourlovers_app/details/color/view.dart';
import 'package:colourlovers_app/details/palette/view.dart';
import 'package:colourlovers_app/details/pattern/view.dart';
import 'package:colourlovers_app/details/user/view.dart';
import 'package:colourlovers_app/test/details/view-controller.dart';
import 'package:colourlovers_app/test/details/view-state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ItemDetailsTestViewCreator extends StatelessWidget {
  const ItemDetailsTestViewCreator({super.key});

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
          child:
              state.color != null
                  ? ColorDetailsViewCreator(color: state.color!)
                  : const Center(child: CircularProgressIndicator()),
        ),
        Expanded(
          child:
              state.palette != null
                  ? PaletteDetailsViewCreator(palette: state.palette!)
                  : const Center(child: CircularProgressIndicator()),
        ),
        Expanded(
          child:
              state.pattern != null
                  ? PatternDetailsViewCreator(pattern: state.pattern!)
                  : const Center(child: CircularProgressIndicator()),
        ),
        Expanded(
          child:
              state.user != null
                  ? UserDetailsViewCreator(user: state.user!)
                  : const Center(child: CircularProgressIndicator()),
        ),
      ],
    );
  }
}
