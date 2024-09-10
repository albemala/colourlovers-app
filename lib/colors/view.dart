import 'package:colourlovers_app/colors/view-controller.dart';
import 'package:colourlovers_app/colors/view-state.dart';
import 'package:colourlovers_app/widgets/app-bar.dart';
import 'package:colourlovers_app/widgets/icon-buttons.dart';
import 'package:colourlovers_app/widgets/item-tiles/color-tile/view.dart';
import 'package:colourlovers_app/widgets/items-list/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ColorsViewCreator extends StatelessWidget {
  const ColorsViewCreator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ColorsViewController>(
      create: ColorsViewController.fromContext,
      child: BlocBuilder<ColorsViewController, ColorsViewState>(
        builder: (context, state) {
          return ColorsView(
            state: state,
            controller: context.read<ColorsViewController>(),
          );
        },
      ),
    );
  }
}

class ColorsView extends StatelessWidget {
  final ColorsViewState state;
  final ColorsViewController controller;

  const ColorsView({
    super.key,
    required this.state,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarView(
        context,
        title: 'Colors',
        actions: [
          RandomItemButton(
            onPressed: () {
              controller.showRandomColor(context);
            },
            tooltip: 'Random color',
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
/*
  SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Wrap(
              spacing: 8,
              children: [
                IconButton.outlined(
                  onPressed: () {
                    controller.showColorFilters(context);
                  },
                  icon: const Icon(
                    LucideIcons.slidersHorizontal,
                  ),
                  tooltip: 'Filters',
                ),
                FilterChip(
                  onSelected: (value) {
                    controller.showColorFilters(context);
                  },
                  label: Text(
                    getItemFilterName(state.filters.filter),
                  ),
                  tooltip: 'Show',
                ),
                if (state.filters.filter == ItemsFilter.all)
                  FilterChip(
                    onSelected: (value) {
                      controller.showColorFilters(context);
                    },
                    avatar: state.filters.order == ColourloversRequestSortBy.ASC
                        ? Icon(
                            LucideIcons.arrowUp,
                            color: Theme.of(context).colorScheme.secondary,
                          )
                        : Icon(
                            LucideIcons.arrowDown,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                    label: Text(
                      getColourloversRequestOrderByName(state.filters.sortBy),
                    ),
                    tooltip: 'Sort by',
                  ),
                FilterChip(
                  onSelected: (value) {
                    controller.showColorFilters(context);
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
                        state.filters.hueMax - state.filters.hueMin,
                        (index) => HSVColor.fromAHSV(
                          1,
                          (state.filters.hueMin + index).toDouble(),
                          1,
                          1,
                        ).toColor(),
                      ),
                    ),
                  ),
                ),
                FilterChip(
                  onSelected: (value) {
                    controller.showColorFilters(context);
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
                        state.filters.brightnessMax -
                            state.filters.brightnessMin,
                        (index) => HSVColor.fromAHSV(
                          1,
                          0,
                          0,
                          (state.filters.brightnessMin + index) / 100,
                        ).toColor(),
                      ),
                    ),
                  ),
                ),
                if (state.filters.colorName.isNotEmpty)
                  FilterChip(
                    onSelected: (value) {
                      controller.showColorFilters(context);
                    },
                    avatar: Icon(
                      LucideIcons.tag,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    label: Text(state.filters.colorName),
                    tooltip: 'Color name',
                  ),
                if (state.filters.userName.isNotEmpty)
                  FilterChip(
                    onSelected: (value) {
                      controller.showColorFilters(context);
                    },
                    avatar: Icon(
                      LucideIcons.userCircle2,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    label: Text(state.filters.userName),
                    tooltip: 'User name',
                  ),
              ],
            ),
          )
        ,
          */
          Expanded(
            child: ItemsListView(
              state: state.itemsList,
              itemTileBuilder: (itemViewState) {
                return ColorTileView(
                  state: itemViewState,
                  onTap: () {
                    controller.showColorDetails(context, itemViewState);
                  },
                );
              },
              onLoadMorePressed: controller.loadMore,
            ),
          ),
        ],
      ),
    );
  }
}
