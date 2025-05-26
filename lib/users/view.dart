import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/filters/defines.dart';
import 'package:colourlovers_app/filters/functions.dart';
import 'package:colourlovers_app/users/view-controller.dart';
import 'package:colourlovers_app/users/view-state.dart';
import 'package:colourlovers_app/widgets/app-bar.dart';
import 'package:colourlovers_app/widgets/background/view.dart';
import 'package:colourlovers_app/widgets/item-tiles/user-tile/view.dart';
import 'package:colourlovers_app/widgets/items-list/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';

class UsersViewCreator extends StatelessWidget {
  const UsersViewCreator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UsersViewController>(
      create: UsersViewController.fromContext,
      child: BlocBuilder<UsersViewController, UsersViewState>(
        builder: (context, state) {
          return UsersView(
            state: state,
            controller: context.read<UsersViewController>(),
          );
        },
      ),
    );
  }
}

class UsersView extends StatelessWidget {
  final UsersViewState state;
  final UsersViewController controller;

  const UsersView({super.key, required this.state, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarView(context, title: 'Users'),
      body: BackgroundView(
        blobs: state.backgroundBlobs.toList(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                spacing: 8,
                children: [
                  IconButton.outlined(
                    onPressed: () {
                      controller.showUserFilters(context);
                    },
                    icon: const Icon(LucideIcons.slidersHorizontal, size: 18),
                    tooltip: 'Filters',
                  ),
                  FilterChip(
                    onSelected: (value) {
                      controller.showUserFilters(context);
                    },
                    label: Text(getContentShowCriteriaName(state.showCriteria)),
                    tooltip: 'Show',
                  ),
                  if (state.showCriteria == ContentShowCriteria.all)
                    FilterChip(
                      onSelected: (value) {
                        controller.showUserFilters(context);
                      },
                      avatar:
                          state.sortOrder == ColourloversRequestSortBy.ASC
                              ? const Icon(LucideIcons.arrowUp)
                              : const Icon(LucideIcons.arrowDown),
                      label: Text(
                        getColourloversRequestOrderByName(state.sortBy),
                      ),
                      tooltip: 'Sort by',
                    ),
                  if (state.userName.isNotEmpty)
                    FilterChip(
                      onSelected: (value) {
                        controller.showUserFilters(context);
                      },
                      avatar: const Icon(LucideIcons.userCircle2),
                      label: Text(state.userName),
                      tooltip: 'User name',
                    ),
                ],
              ),
            ),
            Expanded(
              child: ItemsListView(
                state: state.itemsList,
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
            ),
          ],
        ),
      ),
    );
  }
}
