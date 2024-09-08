import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/app/routing.dart';
import 'package:colourlovers_app/color-details/view.dart';
import 'package:colourlovers_app/user-items.dart';
import 'package:colourlovers_app/widgets/app-top-bar.dart';
import 'package:colourlovers_app/widgets/item-tiles.dart';
import 'package:colourlovers_app/widgets/items-list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserColorsViewBloc extends Cubit<ItemsListViewModel<ColorTileViewModel>> {
  factory UserColorsViewBloc.fromContext(
    BuildContext context, {
    required String userName,
  }) {
    return UserColorsViewBloc(
      userName,
      ColourloversApiClient(),
    );
  }

  final String _userName;
  final ColourloversApiClient _client;
  late final ItemsPagination<ColourloversColor> _pagination;

  UserColorsViewBloc(
    this._userName,
    this._client,
  ) : super(
          ItemsListViewModel.initialState(),
        ) {
    _pagination = ItemsPagination<ColourloversColor>((numResults, offset) {
      return fetchUserColors(_client, numResults, offset, _userName);
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

  void showColorDetails(
    BuildContext context,
    ColorTileViewModel viewModel,
  ) {
    final viewModelIndex = state.items.indexOf(viewModel);
    final color = _pagination.items[viewModelIndex];
    openRoute(context, ColorDetailsViewBuilder(color: color));
  }

  void _updateState() {
    emit(
      ItemsListViewModel(
        isLoading: _pagination.isLoading,
        items: _pagination.items //
            .map(ColorTileViewModel.fromColourloverColor)
            .toList(),
        hasMoreItems: _pagination.hasMoreItems,
      ),
    );
  }
}

class UserColorsViewBuilder extends StatelessWidget {
  final String userName;

  const UserColorsViewBuilder({
    super.key,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UserColorsViewBloc>(
      create: (context) {
        return UserColorsViewBloc.fromContext(
          context,
          userName: userName,
        );
      },
      child: BlocBuilder<UserColorsViewBloc,
          ItemsListViewModel<ColorTileViewModel>>(
        builder: (context, viewModel) {
          return UserColorsView(
            listViewModel: viewModel,
            bloc: context.read<UserColorsViewBloc>(),
          );
        },
      ),
    );
  }
}

class UserColorsView extends StatelessWidget {
  final ItemsListViewModel<ColorTileViewModel> listViewModel;
  final UserColorsViewBloc bloc;

  const UserColorsView({
    super.key,
    required this.listViewModel,
    required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTopBarView(
        context,
        title: 'User colors',
      ),
      body: ItemsListView(
        viewModel: listViewModel,
        itemTileBuilder: (itemViewModel) {
          return ColorTileView(
            viewModel: itemViewModel,
            onTap: () {
              bloc.showColorDetails(context, itemViewModel);
            },
          );
        },
        onLoadMorePressed: bloc.loadMore,
      ),
    );
  }
}
