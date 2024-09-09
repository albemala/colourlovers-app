import 'package:colourlovers_app/user-palettes/view-controller.dart';
import 'package:colourlovers_app/widgets/app-top-bar.dart';
import 'package:colourlovers_app/widgets/item-tiles.dart';
import 'package:colourlovers_app/widgets/items-list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserPalettesViewCreator extends StatelessWidget {
  final String userName;

  const UserPalettesViewCreator({
    super.key,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UserPalettesViewController>(
      create: (context) {
        return UserPalettesViewController.fromContext(
          context,
          userName: userName,
        );
      },
      child: BlocBuilder<UserPalettesViewController,
          ItemsListViewState<PaletteTileViewState>>(
        builder: (context, state) {
          return UserPalettesView(
            listViewState: state,
            controller: context.read<UserPalettesViewController>(),
          );
        },
      ),
    );
  }
}

class UserPalettesView extends StatelessWidget {
  final ItemsListViewState<PaletteTileViewState> listViewState;
  final UserPalettesViewController controller;

  const UserPalettesView({
    super.key,
    required this.listViewState,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTopBarView(
        context,
        title: 'User palettes',
      ),
      body: ItemsListView(
        state: listViewState,
        itemTileBuilder: (itemViewState) {
          return PaletteTileView(
            state: itemViewState,
            onTap: () {
              controller.showPaletteDetails(context, itemViewState);
            },
          );
        },
        onLoadMorePressed: controller.loadMore,
      ),
    );
  }
}
