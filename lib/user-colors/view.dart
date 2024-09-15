import 'package:colourlovers_app/user-colors/view-controller.dart';
import 'package:colourlovers_app/user-colors/view-state.dart';
import 'package:colourlovers_app/widgets/app-bar.dart';
import 'package:colourlovers_app/widgets/background/view.dart';
import 'package:colourlovers_app/widgets/item-tiles/color-tile/view.dart';
import 'package:colourlovers_app/widgets/items-list/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserColorsViewCreator extends StatelessWidget {
  final String userName;

  const UserColorsViewCreator({
    super.key,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UserColorsViewController>(
      create: (context) {
        return UserColorsViewController.fromContext(
          context,
          userName: userName,
        );
      },
      child: BlocBuilder<UserColorsViewController, UserColorsViewState>(
        builder: (context, state) {
          return UserColorsView(
            state: state,
            controller: context.read<UserColorsViewController>(),
          );
        },
      ),
    );
  }
}

class UserColorsView extends StatelessWidget {
  final UserColorsViewState state;
  final UserColorsViewController controller;

  const UserColorsView({
    super.key,
    required this.state,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarView(
        context,
        title: 'User colors',
      ),
      body: BackgroundView(
        blobs: state.backgroundBlobs.toList(),
        child: ItemsListView(
          state: state.itemsList,
          itemTileBuilder: (itemViewState) {
            return ColorTileView(
              state: itemViewState,
              onTap: () {
                controller.showColorDetails(context, itemViewState);
              },
            );
          },
          onLoadMorePressed: controller.loadMore,
        ),
      ),
    );
  }
}
