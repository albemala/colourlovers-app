import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/app/routing.dart';
import 'package:colourlovers_app/items-pagination.dart';
import 'package:colourlovers_app/user-details/view.dart';
import 'package:colourlovers_app/widgets/item-tiles/user-tile/view-state.dart';
import 'package:colourlovers_app/widgets/items-list/view-state.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UsersViewController extends Cubit<ItemsListViewState<UserTileViewState>> {
  final ColourloversApiClient _client;
  late final ItemsPagination<ColourloversLover> _pagination;

  factory UsersViewController.fromContext(BuildContext context) {
    return UsersViewController(
      ColourloversApiClient(),
    );
  }

  UsersViewController(
    this._client,
  ) : super(defaultUsersListViewState) {
    _pagination = ItemsPagination<ColourloversLover>((numResults, offset) {
      return _client.getLovers(
        numResults: numResults,
        resultOffset: offset,
        // orderBy: ClRequestOrderBy.numVotes,
        sortBy: ColourloversRequestSortBy.DESC,
      );
    });
    _pagination.addListener(_updateState);
    _pagination.load();
  }

  @override
  Future<void> close() {
    _pagination.removeListener(_updateState);
    return super.close();
  }

  Future<void> loadMore() async {
    await _pagination.loadMore();
  }

  void showUserDetails(
    BuildContext context,
    UserTileViewState tileViewState,
  ) {
    final index = state.items.indexOf(tileViewState);
    final user = _pagination.items[index];
    _showUserDetails(context, user);
  }

  void _showUserDetails(
    BuildContext context,
    ColourloversLover user,
  ) {
    openScreen(context, UserDetailsViewCreator(user: user));
  }

  void _updateState() {
    emit(
      ItemsListViewState(
        isLoading: _pagination.isLoading,
        items: _pagination.items //
            .map(UserTileViewState.fromColourloverUser)
            .toIList(),
        hasMoreItems: _pagination.hasMoreItems,
      ),
    );
  }
}
