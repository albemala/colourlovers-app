import 'package:colourlovers_app/user-patterns/view-controller.dart';
import 'package:colourlovers_app/widgets/app-top-bar.dart';
import 'package:colourlovers_app/widgets/item-tiles.dart';
import 'package:colourlovers_app/widgets/items-list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserPatternsViewCreator extends StatelessWidget {
  final String userName;

  const UserPatternsViewCreator({
    super.key,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UserPatternsViewController>(
      create: (context) {
        return UserPatternsViewController.fromContext(
          context,
          userName: userName,
        );
      },
      child: BlocBuilder<UserPatternsViewController,
          ItemsListViewState<PatternTileViewState>>(
        builder: (context, state) {
          return UserPatternsView(
            listViewState: state,
            controller: context.read<UserPatternsViewController>(),
          );
        },
      ),
    );
  }
}

class UserPatternsView extends StatelessWidget {
  final ItemsListViewState<PatternTileViewState> listViewState;
  final UserPatternsViewController controller;

  const UserPatternsView({
    super.key,
    required this.listViewState,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTopBarView(
        context,
        title: 'User patterns',
      ),
      body: ItemsListView(
        state: listViewState,
        itemTileBuilder: (itemViewState) {
          return PatternTileView(
            state: itemViewState,
            onTap: () {
              controller.showPatternDetails(context, itemViewState);
            },
          );
        },
        onLoadMorePressed: controller.loadMore,
      ),
    );
  }
}
