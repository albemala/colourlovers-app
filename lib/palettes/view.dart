import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/filters/defines.dart';
import 'package:colourlovers_app/filters/functions.dart';
import 'package:colourlovers_app/palettes/view-controller.dart';
import 'package:colourlovers_app/palettes/view-state.dart';
import 'package:colourlovers_app/widgets/app-bar.dart';
import 'package:colourlovers_app/widgets/background/view.dart';
import 'package:colourlovers_app/widgets/icon-buttons.dart';
import 'package:colourlovers_app/widgets/item-tiles/palette-tile/view.dart';
import 'package:colourlovers_app/widgets/items-list/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';

class PalettesViewCreator extends StatelessWidget {
  const PalettesViewCreator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PalettesViewController>(
      create: PalettesViewController.fromContext,
      child: BlocBuilder<PalettesViewController, PalettesViewState>(
        builder: (context, state) {
          return PalettesView(
            state: state,
            controller: context.read<PalettesViewController>(),
          );
        },
      ),
    );
  }
}

class PalettesView extends StatelessWidget {
  final PalettesViewState state;
  final PalettesViewController controller;

  const PalettesView({
    super.key,
    required this.state,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarView(
        context,
        title: 'Palettes',
        actions: [
          RandomItemButton(
            onPressed: () {
              controller.showRandomPalette(context);
            },
            tooltip: 'Random palette',
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
                      controller.showPaletteFilters(context);
                    },
                    icon: const Icon(
                      LucideIcons.slidersHorizontal,
                      size: 18,
                    ),
                    tooltip: 'Filters',
                  ),
                  FilterChip(
                    onSelected: (value) {
                      controller.showPaletteFilters(context);
                    },
                    label: Text(
                      getContentShowCriteriaName(state.showCriteria),
                    ),
                    tooltip: 'Show',
                  ),
                  if (state.showCriteria == ContentShowCriteria.all)
                    FilterChip(
                      onSelected: (value) {
                        controller.showPaletteFilters(context);
                      },
                      avatar: state.sortOrder == ColourloversRequestSortBy.ASC
                          ? const Icon(LucideIcons.arrowUp)
                          : const Icon(LucideIcons.arrowDown),
                      label: Text(
                        getColourloversRequestOrderByName(state.sortBy),
                      ),
                      tooltip: 'Sort by',
                    ),
                  if (state.colorFilter == ColorFilter.hueRanges)
                    FilterChip(
                      onSelected: (value) {
                        controller.showPaletteFilters(context);
                      },
                      avatar: const Icon(LucideIcons.rainbow),
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: state.hueRanges.map((hueRange) {
                          return Container(
                            width: 12,
                            height: 12,
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            decoration: BoxDecoration(
                              color:
                                  getColourloversRequestHueRangeColor(hueRange),
                              shape: BoxShape.circle,
                            ),
                          );
                        }).toList(),
                      ),
                      tooltip: 'Hue Ranges',
                    ),
                  if (state.colorFilter == ColorFilter.hex)
                    FilterChip(
                      onSelected: (value) {
                        controller.showPaletteFilters(context);
                      },
                      avatar: const Icon(LucideIcons.palette),
                      label: Container(
                        width: 24,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Color(int.parse('FF${state.hex}', radix: 16)),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      tooltip: 'Color Hex',
                    ),
                  if (state.paletteName.isNotEmpty)
                    FilterChip(
                      onSelected: (value) {
                        controller.showPaletteFilters(context);
                      },
                      avatar: const Icon(LucideIcons.tag),
                      label: Text(state.paletteName),
                      tooltip: 'Palette name',
                    ),
                  if (state.userName.isNotEmpty)
                    FilterChip(
                      onSelected: (value) {
                        controller.showPaletteFilters(context);
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
                  return PaletteTileView(
                    state: itemViewState,
                    onTap: () {
                      controller.showPaletteDetails(context, itemViewState);
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
