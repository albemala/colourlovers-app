import 'package:colourlovers_app/users/view-controller.dart';
import 'package:colourlovers_app/widgets/app-bar.dart';
import 'package:colourlovers_app/widgets/item-tiles/user-tile/view-state.dart';
import 'package:colourlovers_app/widgets/item-tiles/user-tile/view.dart';
import 'package:colourlovers_app/widgets/items-list/view-state.dart';
import 'package:colourlovers_app/widgets/items-list/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UsersViewCreator extends StatelessWidget {
  const UsersViewCreator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UsersViewController>(
      create: UsersViewController.fromContext,
      child: BlocBuilder<UsersViewController,
          ItemsListViewState<UserTileViewState>>(
        builder: (context, state) {
          return UsersView(
            listViewState: state,
            controller: context.read<UsersViewController>(),
          );
        },
      ),
    );
  }
}

class UsersView extends StatelessWidget {
  final ItemsListViewState<UserTileViewState> listViewState;
  final UsersViewController controller;

  const UsersView({
    super.key,
    required this.listViewState,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarView(
        context,
        title: 'Users',
        actions: [
          // _FilterButton(
          //   onPressed: () {
          //     // TODO
          //   },
          // ),
        ],
      ),
      body: ItemsListView(
        state: listViewState,
        itemTileBuilder: (itemViewState) {
          return UserTileView(
            state: itemViewState,
            onTap: () {
              controller.showUserDetails(context, itemViewState);
            },
          );
        },
        onLoadMorePressed: controller.loadMore,
      ),
    );
  }
}
