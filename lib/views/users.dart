import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/functions/routing.dart';
import 'package:colourlovers_app/views/user-details.dart';
import 'package:colourlovers_app/widgets/app-top-bar.dart';
import 'package:colourlovers_app/widgets/item-tiles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@immutable
class UsersViewModel {
  final bool isLoading;
  final List<UserTileViewModel> users;

  const UsersViewModel({
    required this.isLoading,
    required this.users,
  });

  factory UsersViewModel.initialState() {
    return const UsersViewModel(
      isLoading: false,
      users: <UserTileViewModel>[],
    );
  }
}

class UsersViewBloc extends Cubit<UsersViewModel> {
  factory UsersViewBloc.fromContext(BuildContext context) {
    return UsersViewBloc(
      ColourloversApiClient(),
    );
  }

  final ColourloversApiClient _client;
  bool _isLoading = false;
  List<ColourloversLover> _users = <ColourloversLover>[];
  int _page = 0;

  UsersViewBloc(
    this._client,
  ) : super(
          UsersViewModel.initialState(),
        ) {
    load();
  }

  Future<void> load() async {
    _isLoading = true;
    _emitState();

    const numResults = 20;
    final items = await _client.getLovers(
          numResults: numResults,
          resultOffset: _page * numResults,
          // orderBy: ClRequestOrderBy.numVotes,
          sortBy: ColourloversRequestSortBy.DESC,
        ) ??
        [];

    _isLoading = false;
    _users = [
      ..._users,
      ...items,
    ];
    _emitState();
  }

  Future<void> loadMore() async {
    _page++;
    await load();
  }

  void showUserDetails(
    BuildContext context,
    int userIndex,
  ) {
    final user = _users[userIndex];
    _showUserDetails(context, user);
  }

  void _showUserDetails(
    BuildContext context,
    ColourloversLover user,
  ) {
    openRoute(context, UserDetailsViewBuilder(user: user));
  }

  void _emitState() {
    emit(
      UsersViewModel(
        isLoading: _isLoading,
        users: _users //
            .map(UserTileViewModel.fromColourloverUser)
            .toList(),
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
      child: BlocBuilder<UsersViewBloc, UsersViewModel>(
        builder: (context, viewModel) {
          return UsersView(
            viewModel: viewModel,
            bloc: context.read<UsersViewBloc>(),
          );
        },
      ),
    );
  }
}

class UsersView extends StatelessWidget {
  final UsersViewModel viewModel;
  final UsersViewBloc bloc;

  const UsersView({
    super.key,
    required this.viewModel,
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
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        // controller: scrollController,
        itemCount: viewModel.users.length + 1,
        itemBuilder: (context, index) {
          if (index == viewModel.users.length) {
            if (viewModel.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              // TODO dont show if no more items
              return OutlinedButton(
                onPressed: bloc.loadMore,
                child: const Text('Load more'),
              );
            }
          } else {
            final user = viewModel.users[index];
            return UserTileView(
              viewModel: user,
              onTap: () {
                bloc.showUserDetails(context, index);
              },
            );
          }
        },
        separatorBuilder: (context, index) {
          return const SizedBox(height: 12);
        },
      ),
    );
  }
}
