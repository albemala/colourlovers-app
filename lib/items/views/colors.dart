import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/app/routing.dart';
import 'package:colourlovers_app/common/widgets/app-top-bar.dart';
import 'package:colourlovers_app/common/widgets/color-value-indicator.dart';
import 'package:colourlovers_app/common/widgets/item-tiles.dart';
import 'package:colourlovers_app/common/widgets/items-list.dart';
import 'package:colourlovers_app/item-details/views/color-details.dart';
import 'package:colourlovers_app/item-filters/defines/filters.dart';
import 'package:colourlovers_app/item-filters/functions/filters.dart';
import 'package:colourlovers_app/item-filters/views/color-filters.dart';
import 'package:colourlovers_app/items/widgets/random-item-button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';

@immutable
class ColorsViewModel {
  final ColorFiltersViewModel filters;
  final ItemsListViewModel<ColorTileViewModel> itemsList;

  const ColorsViewModel({
    required this.filters,
    required this.itemsList,
  });

  factory ColorsViewModel.initialState() {
    return ColorsViewModel(
      filters: ColorFiltersViewModel.initialState(),
      itemsList: ItemsListViewModel.initialState(),
    );
  }
}

class ColorsViewBloc extends Cubit<ColorsViewModel> {
  factory ColorsViewBloc.fromContext(BuildContext context) {
    return ColorsViewBloc(
      ColourloversApiClient(),
    );
  }

  final ColourloversApiClient _client;
  late ColorFiltersViewModel _filters;
  late final ItemsPagination<ColourloversColor> _pagination;

  ColorsViewBloc(
    this._client,
  ) : super(
          ColorsViewModel.initialState(),
        ) {
    _filters = state.filters;

    _pagination = ItemsPagination<ColourloversColor>((numResults, offset) {
      switch (_filters.filter) {
        case ItemsFilter.newest:
          return _client.getNewColors(
            lover: _filters.userName,
            hueMin: _filters.hueMin,
            hueMax: _filters.hueMax,
            brightnessMin: _filters.brightnessMin,
            brightnessMax: _filters.brightnessMax,
            keywords: _filters.colorName,
            numResults: numResults,
            resultOffset: offset,
          );
        case ItemsFilter.top:
          return _client.getTopColors(
            lover: _filters.userName,
            hueMin: _filters.hueMin,
            hueMax: _filters.hueMax,
            brightnessMin: _filters.brightnessMin,
            brightnessMax: _filters.brightnessMax,
            keywords: _filters.colorName,
          );
        case ItemsFilter.all:
          return _client.getColors(
            lover: _filters.userName,
            hueMin: _filters.hueMin,
            hueMax: _filters.hueMax,
            brightnessMin: _filters.brightnessMin,
            brightnessMax: _filters.brightnessMax,
            keywords: _filters.colorName,
            sortBy: _filters.order,
            orderBy: _filters.sortBy,
          );
      }
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

  void showColorFilters(
    BuildContext context,
  ) {
    openRoute(
      context,
      ColorFiltersViewBuilder(
        initialState: _filters,
        onApply: (filters) {
          closeCurrentRoute(context);
          _filters = filters;
          _pagination.reset();
          _updateState();
          _pagination.load();
        },
      ),
      fullscreenDialog: true,
    );
  }

  void showColorDetails(
    BuildContext context,
    ColorTileViewModel viewModel,
  ) {
    final viewModelIndex = state.itemsList.items.indexOf(viewModel);
    final color = _pagination.items[viewModelIndex];
    _showColorDetails(context, color);
  }

  Future<void> showRandomColor(
    BuildContext context,
  ) async {
    final color = await _client.getRandomColor();
    if (color == null) return;
    _showColorDetails(context, color);
  }

  void _showColorDetails(
    BuildContext context,
    ColourloversColor color,
  ) {
    openRoute(context, ColorDetailsViewBuilder(color: color));
  }

  void _updateState() {
    emit(
      ColorsViewModel(
        filters: _filters,
        itemsList: ItemsListViewModel(
          isLoading: _pagination.isLoading,
          items: _pagination.items //
              .map(ColorTileViewModel.fromColourloverColor)
              .toList(),
          hasMoreItems: _pagination.hasMoreItems,
        ),
      ),
    );
  }
}

class ColorsViewBuilder extends StatelessWidget {
  const ColorsViewBuilder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ColorsViewBloc>(
      create: ColorsViewBloc.fromContext,
      child: BlocBuilder<ColorsViewBloc, ColorsViewModel>(
        builder: (context, viewModel) {
          return ColorsView(
            viewModel: viewModel,
            bloc: context.read<ColorsViewBloc>(),
          );
        },
      ),
    );
  }
}

class ColorsView extends StatelessWidget {
  final ColorsViewModel viewModel;
  final ColorsViewBloc bloc;

  const ColorsView({
    super.key,
    required this.viewModel,
    required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTopBarView(
        context,
        title: 'Colors',
        actions: [
          RandomItemButton(
            onPressed: () {
              bloc.showRandomColor(context);
            },
            tooltip: 'Random color',
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Wrap(
              spacing: 8,
              children: [
                IconButton.outlined(
                  onPressed: () {
                    bloc.showColorFilters(context);
                  },
                  icon: const Icon(
                    LucideIcons.slidersHorizontal,
                  ),
                  tooltip: 'Filters',
                ),
                FilterChip(
                  onSelected: (value) {
                    bloc.showColorFilters(context);
                  },
                  label: Text(
                    getItemFilterName(viewModel.filters.filter),
                  ),
                  tooltip: 'Show',
                ),
                if (viewModel.filters.filter == ItemsFilter.all)
                  FilterChip(
                    onSelected: (value) {
                      bloc.showColorFilters(context);
                    },
                    avatar:
                        viewModel.filters.order == ColourloversRequestSortBy.ASC
                            ? Icon(
                                LucideIcons.arrowUp,
                                color: Theme.of(context).colorScheme.secondary,
                              )
                            : Icon(
                                LucideIcons.arrowDown,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                    label: Text(
                      getColourloversRequestOrderByName(
                          viewModel.filters.sortBy),
                    ),
                    tooltip: 'Sort by',
                  ),
                FilterChip(
                  onSelected: (value) {
                    bloc.showColorFilters(context);
                  },
                  avatar: Icon(
                    LucideIcons.rainbow,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  label: SizedBox(
                    width: 128,
                    height: 8,
                    child: ColorChannelTrackView(
                      trackColors: List.generate(
                        viewModel.filters.hueMax - viewModel.filters.hueMin,
                        (index) => HSVColor.fromAHSV(
                          1,
                          (viewModel.filters.hueMin + index).toDouble(),
                          1,
                          1,
                        ).toColor(),
                      ),
                    ),
                  ),
                ),
                FilterChip(
                  onSelected: (value) {
                    bloc.showColorFilters(context);
                  },
                  avatar: Icon(
                    LucideIcons.sun,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  label: SizedBox(
                    width: 128,
                    height: 8,
                    child: ColorChannelTrackView(
                      trackColors: List.generate(
                        viewModel.filters.brightnessMax -
                            viewModel.filters.brightnessMin,
                        (index) => HSVColor.fromAHSV(
                          1,
                          0,
                          0,
                          (viewModel.filters.brightnessMin + index) / 100,
                        ).toColor(),
                      ),
                    ),
                  ),
                ),
                if (viewModel.filters.colorName.isNotEmpty)
                  FilterChip(
                    onSelected: (value) {
                      bloc.showColorFilters(context);
                    },
                    avatar: Icon(
                      LucideIcons.tag,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    label: Text(viewModel.filters.colorName),
                    tooltip: 'Color name',
                  ),
                if (viewModel.filters.userName.isNotEmpty)
                  FilterChip(
                    onSelected: (value) {
                      bloc.showColorFilters(context);
                    },
                    avatar: Icon(
                      LucideIcons.userCircle2,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    label: Text(viewModel.filters.userName),
                    tooltip: 'User name',
                  ),
              ],
            ),
          ),
          Expanded(
            child: ItemsListView(
              viewModel: viewModel.itemsList,
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
          ),
        ],
      ),
    );
  }
}
