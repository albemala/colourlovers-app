import 'package:colourlovers_app/user-colors/view-controller.dart';
import 'package:colourlovers_app/widgets/app-top-bar.dart';
import 'package:colourlovers_app/widgets/item-tiles.dart';
import 'package:colourlovers_app/widgets/items-list.dart';
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
      child: BlocBuilder<UserColorsViewController,
          ItemsListViewState<ColorTileViewState>>(
        builder: (context, state) {
          return UserColorsView(
            listViewState: state,
            controller: context.read<UserColorsViewController>(),
          );
        },
      ),
    );
  }
}

class UserColorsView extends StatelessWidget {
  final ItemsListViewState<ColorTileViewState> listViewState;
  final UserColorsViewController controller;

  const UserColorsView({
    super.key,
    required this.listViewState,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTopBarView(
        context,
        title: 'User colors',
      ),
      body: ItemsListView(
        state: listViewState,
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
    );
  }
}
