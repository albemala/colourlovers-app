import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/colors/view-controller.dart';
import 'package:colourlovers_app/colors/view-state.dart';
import 'package:colourlovers_app/filters/defines.dart';
import 'package:colourlovers_app/filters/functions.dart';
import 'package:colourlovers_app/widgets/app-bar.dart';
import 'package:colourlovers_app/widgets/background/view.dart';
import 'package:colourlovers_app/widgets/color-values-range-indicator.dart';
import 'package:colourlovers_app/widgets/icon-buttons.dart';
import 'package:colourlovers_app/widgets/item-tiles/color-tile/view.dart';
import 'package:colourlovers_app/widgets/items-list/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ColorsViewCreator extends StatelessWidget {
  const ColorsViewCreator({super.key});

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

  const ColorsView({super.key, required this.state, required this.controller});

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
                      controller.showColorFilters(context);
                    },
                    icon: const Icon(LucideIcons.slidersHorizontal, size: 18),
                    tooltip: 'Filters',
                  ),
                  FilterChip(
                    onSelected: (value) {
                      controller.showColorFilters(context);
                    },
                    label: Text(getContentShowCriteriaName(state.showCriteria)),
                    tooltip: 'Show',
                  ),
                  if (state.showCriteria == ContentShowCriteria.all)
                    FilterChip(
                      onSelected: (value) {
                        controller.showColorFilters(context);
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
                  FilterChip(
                    onSelected: (value) {
                      controller.showColorFilters(context);
                    },
                    avatar: const Icon(LucideIcons.rainbow),
                    label: SizedBox(
                      width: 128,
                      height: 8,
                      child: ColorValueRangeIndicatorView(
                        min: 0,
                        max: 359,
                        lowerValue: state.hueMin.toDouble(),
                        upperValue: state.hueMax.toDouble(),
                        getColor: (value) {
                          return HSVColor.fromAHSV(1, value, 1, 1).toColor();
                        },
                      ),
                    ),
                  ),
                  FilterChip(
                    onSelected: (value) {
                      controller.showColorFilters(context);
                    },
                    avatar: const Icon(LucideIcons.sun),
                    label: SizedBox(
                      width: 128,
                      height: 8,
                      child: ColorValueRangeIndicatorView(
                        min: 0,
                        max: 99,
                        lowerValue: state.brightnessMin.toDouble(),
                        upperValue: state.brightnessMax.toDouble(),
                        getColor: (value) {
                          return HSVColor.fromAHSV(
                            1,
                            0,
                            0,
                            value / 100,
                          ).toColor();
                        },
                      ),
                    ),
                  ),
                  if (state.colorName.isNotEmpty)
                    FilterChip(
                      onSelected: (value) {
                        controller.showColorFilters(context);
                      },
                      avatar: const Icon(LucideIcons.tag),
                      label: Text(state.colorName),
                      tooltip: 'Color name',
                    ),
                  if (state.userName.isNotEmpty)
                    FilterChip(
                      onSelected: (value) {
                        controller.showColorFilters(context);
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
      ),
    );
  }
}
