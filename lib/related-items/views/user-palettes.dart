import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/app/routing.dart';
import 'package:colourlovers_app/common/widgets/app-top-bar.dart';
import 'package:colourlovers_app/common/widgets/item-tiles.dart';
import 'package:colourlovers_app/common/widgets/items-list.dart';
import 'package:colourlovers_app/item-details/views/palette-details.dart';
import 'package:colourlovers_app/related-items/functions/user-items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserPalettesViewBloc
    extends Cubit<ItemsListViewModel<PaletteTileViewModel>> {
  factory UserPalettesViewBloc.fromContext(
    BuildContext context, {
    required String userName,
  }) {
    return UserPalettesViewBloc(
      userName,
      ColourloversApiClient(),
    );
  }

  final String _userName;
  final ColourloversApiClient _client;
  late final ItemsPagination<ColourloversPalette> _pagination;

  UserPalettesViewBloc(
    this._userName,
    this._client,
  ) : super(
          ItemsListViewModel.initialState(),
        ) {
    _pagination = ItemsPagination<ColourloversPalette>((numResults, offset) {
      return fetchUserPalettes(_client, numResults, offset, _userName);
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

  void showPaletteDetails(
    BuildContext context,
    PaletteTileViewModel viewModel,
  ) {
    final viewModelIndex = state.items.indexOf(viewModel);
    final palette = _pagination.items[viewModelIndex];
    openRoute(context, PaletteDetailsViewBuilder(palette: palette));
  }

  void _updateState() {
    emit(
      ItemsListViewModel(
        isLoading: _pagination.isLoading,
        items: _pagination.items //
            .map(PaletteTileViewModel.fromColourloverPalette)
            .toList(),
        hasMoreItems: _pagination.hasMoreItems,
      ),
    );
  }
}

class UserPalettesViewBuilder extends StatelessWidget {
  final String userName;

  const UserPalettesViewBuilder({
    super.key,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UserPalettesViewBloc>(
      create: (context) {
        return UserPalettesViewBloc.fromContext(
          context,
          userName: userName,
        );
      },
      child: BlocBuilder<UserPalettesViewBloc,
          ItemsListViewModel<PaletteTileViewModel>>(
        builder: (context, viewModel) {
          return UserPalettesView(
            listViewModel: viewModel,
            bloc: context.read<UserPalettesViewBloc>(),
          );
        },
      ),
    );
  }
}

class UserPalettesView extends StatelessWidget {
  final ItemsListViewModel<PaletteTileViewModel> listViewModel;
  final UserPalettesViewBloc bloc;

  const UserPalettesView({
    super.key,
    required this.listViewModel,
    required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTopBarView(
        context,
        title: 'User palettes',
      ),
      body: ItemsListView(
        viewModel: listViewModel,
        itemTileBuilder: (itemViewModel) {
          return PaletteTileView(
            viewModel: itemViewModel,
            onTap: () {
              bloc.showPaletteDetails(context, itemViewModel);
            },
          );
        },
        onLoadMorePressed: bloc.loadMore,
      ),
    );
  }
}
