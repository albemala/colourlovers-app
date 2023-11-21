import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/app/routing.dart';
import 'package:colourlovers_app/common/widgets/app-top-bar.dart';
import 'package:colourlovers_app/common/widgets/item-tiles.dart';
import 'package:colourlovers_app/common/widgets/items-list.dart';
import 'package:colourlovers_app/item-details/views/user-details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UsersViewBloc extends Cubit<ItemsListViewModel<UserTileViewModel>> {
  factory UsersViewBloc.fromContext(BuildContext context) {
    return UsersViewBloc(
      ColourloversApiClient(),
    );
  }

  final ColourloversApiClient _client;
  late final ItemsPagination<ColourloversLover> _pagination;

  UsersViewBloc(
    this._client,
  ) : super(
          ItemsListViewModel.initialState(),
        ) {
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
    UserTileViewModel viewModel,
  ) {
    final viewModelIndex = state.items.indexOf(viewModel);
    final user = _pagination.items[viewModelIndex];
    _showUserDetails(context, user);
  }

  void _showUserDetails(
    BuildContext context,
    ColourloversLover user,
  ) {
    openRoute(context, UserDetailsViewBuilder(user: user));
  }

  void _updateState() {
    emit(
      ItemsListViewModel(
        isLoading: _pagination.isLoading,
        items: _pagination.items //
            .map(UserTileViewModel.fromColourloverUser)
            .toList(),
        hasMoreItems: _pagination.hasMoreItems,
      ),
    );
  }
}

class UsersViewBuilder extends StatelessWidget {
  const UsersViewBuilder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UsersViewBloc>(
      create: UsersViewBloc.fromContext,
      child: BlocBuilder<UsersViewBloc, ItemsListViewModel<UserTileViewModel>>(
        builder: (context, viewModel) {
          return UsersView(
            listViewModel: viewModel,
            bloc: context.read<UsersViewBloc>(),
          );
        },
      ),
    );
  }
}

class UsersView extends StatelessWidget {
  final ItemsListViewModel<UserTileViewModel> listViewModel;
  final UsersViewBloc bloc;

  const UsersView({
    super.key,
    required this.listViewModel,
    required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      appBar: AppTopBarView(
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
        viewModel: listViewModel,
        itemTileBuilder: (itemViewModel) {
          return UserTileView(
            viewModel: itemViewModel,
            onTap: () {
              bloc.showUserDetails(context, itemViewModel);
            },
          );
        },
        onLoadMorePressed: bloc.loadMore,
      ),
    );
  }
}
