import 'package:colourlovers_app/user-patterns/view-controller.dart';
import 'package:colourlovers_app/user-patterns/view-state.dart';
import 'package:colourlovers_app/widgets/app-bar.dart';
import 'package:colourlovers_app/widgets/background/view.dart';
import 'package:colourlovers_app/widgets/item-tiles/pattern-tile/view.dart';
import 'package:colourlovers_app/widgets/items-list/view.dart';
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
      child: BlocBuilder<UserPatternsViewController, UserPatternsViewState>(
        builder: (context, state) {
          return UserPatternsView(
            state: state,
            controller: context.read<UserPatternsViewController>(),
          );
        },
      ),
    );
  }
}

class UserPatternsView extends StatelessWidget {
  final UserPatternsViewState state;
  final UserPatternsViewController controller;

  const UserPatternsView({
    super.key,
    required this.state,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarView(
        context,
        title: 'User patterns',
      ),
      body: BackgroundView(
        blobs: state.backgroundBlobs.toList(),
        child: ItemsListView(
          state: state.itemsList,
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
      ),
    );
  }
}
