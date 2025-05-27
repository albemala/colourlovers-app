import 'dart:async';

import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/details/user/view.dart';
import 'package:colourlovers_app/filters/defines.dart';
import 'package:colourlovers_app/filters/user/data-controller.dart';
import 'package:colourlovers_app/filters/user/data-state.dart';
import 'package:colourlovers_app/filters/user/view.dart';
import 'package:colourlovers_app/items-pagination.dart';
import 'package:colourlovers_app/lists/users/view-state.dart';
import 'package:colourlovers_app/routing.dart';
import 'package:colourlovers_app/widgets/background/functions.dart';
import 'package:colourlovers_app/widgets/item-tiles/user-tile/view-state.dart';
import 'package:colourlovers_app/widgets/items-list/view-state.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UsersViewController extends Cubit<UsersViewState> {
  final ColourloversApiClient _client;
  final UserFiltersDataController _dataController;

  late final ItemsPagination<ColourloversLover> _pagination;

  StreamSubscription<UserFiltersDataState>? _dataControllerSubscription;

  factory UsersViewController.fromContext(BuildContext context) {
    return UsersViewController(
      ColourloversApiClient(),
      context.read<UserFiltersDataController>(),
    );
  }

  UsersViewController(this._client, this._dataController)
    : super(defaultUsersViewState) {
    _dataControllerSubscription = _dataController.stream.listen((state) {
      _pagination.reset();
      _updateState();
      _pagination.load();
    });

    _pagination = ItemsPagination<ColourloversLover>((numResults, offset) {
      final userName = _dataController.userName;
      switch (_dataController.showCriteria) {
        case ContentShowCriteria.newest:
          return _client.getNewLovers(
            numResults: numResults,
            resultOffset: offset,
          );
        case ContentShowCriteria.top:
          return _client.getTopLovers(
            numResults: numResults,
            resultOffset: offset,
          );
        case ContentShowCriteria.all:
          return _client.getLovers(
            sortBy: _dataController.sortOrder,
            orderBy: _dataController.sortBy,
            numResults: numResults,
            resultOffset: offset,
          );
      }
    });
    _pagination
      ..addListener(_updateState)
      ..load();

    emit(
      state.copyWith(
        backgroundBlobs: generateBackgroundBlobs(getRandomPalette()).toIList(),
      ),
    );
  }

  @override
  Future<void> close() {
    _dataControllerSubscription?.cancel();
    _pagination.removeListener(_updateState);
    return super.close();
  }

  Future<void> loadMore() async {
    await _pagination.loadMore();
  }

  void showUserFilters(BuildContext context) {
    openScreen<void>(
      context,
      const UserFiltersViewCreator(),
      fullscreenDialog: true,
    );
  }

  void showUserDetails(BuildContext context, UserTileViewState tileViewState) {
    final index = state.itemsList.items.indexOf(tileViewState);
    final user = _pagination.items[index];
    _showUserDetails(context, user);
  }

  void _showUserDetails(BuildContext context, ColourloversLover user) {
    openScreen<void>(context, UserDetailsViewCreator(user: user));
  }

  void _updateState() {
    emit(
      state.copyWith(
        showCriteria: _dataController.showCriteria,
        sortBy: _dataController.sortBy,
        sortOrder: _dataController.sortOrder,
        userName: _dataController.userName,
        itemsList: ItemsListViewState(
          isLoading: _pagination.isLoading,
          items:
              _pagination.items
                  .map(UserTileViewState.fromColourloverUser)
                  .toIList(),
          hasMoreItems: _pagination.hasMoreItems,
        ),
      ),
    );
  }
}
