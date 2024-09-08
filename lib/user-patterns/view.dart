import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/app/routing.dart';
import 'package:colourlovers_app/pattern-details/view.dart';
import 'package:colourlovers_app/user-items.dart';
import 'package:colourlovers_app/widgets/app-top-bar.dart';
import 'package:colourlovers_app/widgets/item-tiles.dart';
import 'package:colourlovers_app/widgets/items-list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserPatternsViewBloc
    extends Cubit<ItemsListViewModel<PatternTileViewModel>> {
  factory UserPatternsViewBloc.fromContext(
    BuildContext context, {
    required String userName,
  }) {
    return UserPatternsViewBloc(
      userName,
      ColourloversApiClient(),
    );
  }

  final String _userName;
  final ColourloversApiClient _client;
  late final ItemsPagination<ColourloversPattern> _pagination;

  UserPatternsViewBloc(
    this._userName,
    this._client,
  ) : super(
          ItemsListViewModel.initialState(),
        ) {
    _pagination = ItemsPagination<ColourloversPattern>((numResults, offset) {
      return fetchUserPatterns(_client, numResults, offset, _userName);
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

  void showPatternDetails(
    BuildContext context,
    PatternTileViewModel viewModel,
  ) {
    final viewModelIndex = state.items.indexOf(viewModel);
    final pattern = _pagination.items[viewModelIndex];
    openRoute(context, PatternDetailsViewBuilder(pattern: pattern));
  }

  void _updateState() {
    emit(
      ItemsListViewModel(
        isLoading: _pagination.isLoading,
        items: _pagination.items //
            .map(PatternTileViewModel.fromColourloverPattern)
            .toList(),
        hasMoreItems: _pagination.hasMoreItems,
      ),
    );
  }
}

class UserPatternsViewBuilder extends StatelessWidget {
  final String userName;

  const UserPatternsViewBuilder({
    super.key,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UserPatternsViewBloc>(
      create: (context) {
        return UserPatternsViewBloc.fromContext(
          context,
          userName: userName,
        );
      },
      child: BlocBuilder<UserPatternsViewBloc,
          ItemsListViewModel<PatternTileViewModel>>(
        builder: (context, viewModel) {
          return UserPatternsView(
            listViewModel: viewModel,
            bloc: context.read<UserPatternsViewBloc>(),
          );
        },
      ),
    );
  }
}

class UserPatternsView extends StatelessWidget {
  final ItemsListViewModel<PatternTileViewModel> listViewModel;
  final UserPatternsViewBloc bloc;

  const UserPatternsView({
    super.key,
    required this.listViewModel,
    required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTopBarView(
        context,
        title: 'User patterns',
      ),
      body: ItemsListView(
        viewModel: listViewModel,
        itemTileBuilder: (itemViewModel) {
          return PatternTileView(
            viewModel: itemViewModel,
            onTap: () {
              bloc.showPatternDetails(context, itemViewModel);
            },
          );
        },
        onLoadMorePressed: bloc.loadMore,
      ),
    );
  }
}
