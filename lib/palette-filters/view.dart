import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/app/routing.dart';
import 'package:colourlovers_app/filters/defines.dart';
import 'package:colourlovers_app/filters/functions.dart';
import 'package:colourlovers_app/palette-filters/view-controller.dart';
import 'package:colourlovers_app/palette-filters/view-state.dart';
import 'package:colourlovers_app/widgets/app-bar.dart';
import 'package:colourlovers_app/widgets/text.dart';
import 'package:flextras/flextras.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaletteFiltersViewCreator extends StatelessWidget {
  const PaletteFiltersViewCreator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PaletteFiltersViewController>(
      create: (context) {
        return PaletteFiltersViewController.fromContext(context);
      },
      child: BlocBuilder<PaletteFiltersViewController, PaletteFiltersViewState>(
        builder: (context, state) {
          return PaletteFiltersView(
            state: state,
            controller: context.read<PaletteFiltersViewController>(),
          );
        },
      ),
    );
  }
}

class PaletteFiltersView extends StatelessWidget {
  final PaletteFiltersViewState state;
  final PaletteFiltersViewController controller;

  const PaletteFiltersView({
    super.key,
    required this.state,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarView(
        context,
        title: 'Filter Palettes',
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: SeparatedColumn(
                crossAxisAlignment: CrossAxisAlignment.start,
                separatorBuilder: () {
                  return const SizedBox(height: 32);
                },
                children: [
                  _ShowView(state: state, controller: controller),
                  if (state.showCriteria == ContentShowCriteria.all)
                    _SortByView(state: state, controller: controller),
                  _ColorFilterView(state: state, controller: controller),
                  if (state.colorFilter == ColorFilter.hueRanges)
                    _HueRangesView(state: state, controller: controller),
                  if (state.colorFilter == ColorFilter.hex)
                    _HexView(state: state, controller: controller),
                  _PaletteNameView(controller: controller),
                  _UserNameView(controller: controller),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SeparatedRow(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              separatorBuilder: () => const SizedBox(width: 16),
              children: [
                OutlinedButton(
                  onPressed: controller.resetFilters,
                  child: const Text('Reset filters'),
                ),
                FilledButton(
                  onPressed: () {
                    controller.applyFilters();
                    closeCurrentView<void>(context);
                  },
                  child: const Text('Apply'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ShowView extends StatelessWidget {
  final PaletteFiltersViewState state;
  final PaletteFiltersViewController controller;

  const _ShowView({
    required this.state,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SeparatedColumn(
      crossAxisAlignment: CrossAxisAlignment.start,
      separatorBuilder: () {
        return const SizedBox(height: 12);
      },
      children: [
        const H1TextView('Show'),
        SeparatedRow(
          separatorBuilder: () => const SizedBox(width: 8),
          children: ContentShowCriteria.values.map(
            (showCriteria) {
              return ChoiceChip(
                label: Text(
                  getContentShowCriteriaName(showCriteria),
                ),
                selected: state.showCriteria == showCriteria,
                onSelected: (bool value) {
                  controller.setShowCriteria(showCriteria);
                },
              );
            },
          ).toList(),
        ),
      ],
    );
  }
}

class _SortByView extends StatelessWidget {
  final PaletteFiltersViewState state;
  final PaletteFiltersViewController controller;

  const _SortByView({
    required this.state,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SeparatedColumn(
      crossAxisAlignment: CrossAxisAlignment.start,
      separatorBuilder: () {
        return const SizedBox(height: 12);
      },
      children: [
        const H1TextView('Sort By'),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SeparatedRow(
            separatorBuilder: () => const SizedBox(width: 8),
            children: ColourloversRequestOrderBy.values.map(
              (sortBy) {
                return ChoiceChip(
                  label: Text(
                    getColourloversRequestOrderByName(sortBy),
                  ),
                  selected: state.sortBy == sortBy,
                  onSelected: (bool value) {
                    controller.setSortBy(sortBy);
                  },
                );
              },
            ).toList(),
          ),
        ),
        SeparatedRow(
          separatorBuilder: () => const SizedBox(width: 8),
          children: ColourloversRequestSortBy.values.map(
            (sortOrder) {
              return ChoiceChip(
                label: Text(
                  getColourloversRequestSortByName(sortOrder),
                ),
                selected: state.sortOrder == sortOrder,
                onSelected: (bool value) {
                  controller.setOrder(sortOrder);
                },
              );
            },
          ).toList(),
        ),
      ],
    );
  }
}

class _ColorFilterView extends StatelessWidget {
  final PaletteFiltersViewState state;
  final PaletteFiltersViewController controller;

  const _ColorFilterView({
    required this.state,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SeparatedColumn(
      crossAxisAlignment: CrossAxisAlignment.start,
      separatorBuilder: () {
        return const SizedBox(height: 12);
      },
      children: [
        const H1TextView('Color Filter'),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SeparatedRow(
            separatorBuilder: () => const SizedBox(width: 8),
            children: ColorFilter.values.map(
              (colorFilter) {
                return ChoiceChip(
                  label: Text(
                    getColorFilterName(colorFilter),
                  ),
                  selected: state.colorFilter == colorFilter,
                  onSelected: (bool value) {
                    controller.setColorFilter(colorFilter);
                  },
                );
              },
            ).toList(),
          ),
        ),
      ],
    );
  }
}

class _HueRangesView extends StatelessWidget {
  final PaletteFiltersViewState state;
  final PaletteFiltersViewController controller;

  const _HueRangesView({
    required this.state,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: ColourloversRequestHueRange.values.map(
        (hueRange) {
          return ChoiceChip(
            avatar: Container(
              decoration: BoxDecoration(
                color: getColourloversRequestHueRangeColor(hueRange),
                shape: BoxShape.circle,
              ),
              width: 18,
              height: 18,
            ),
            label: Text(
              getColourloversRequestHueRangeName(hueRange),
            ),
            selected: state.hueRanges.contains(hueRange),
            onSelected: (bool selected) {
              if (selected) {
                controller.addHueRange(context, hueRange);
              } else {
                controller.removeHueRange(hueRange);
              }
            },
          );
        },
      ).toList(),
    );
  }
}

class _HexView extends StatelessWidget {
  final PaletteFiltersViewState state;
  final PaletteFiltersViewController controller;

  const _HexView({
    required this.state,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller.hexController,
      decoration: InputDecoration(
        prefixText: '#',
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 8),
          child: SeparatedRow(
            mainAxisSize: MainAxisSize.min,
            separatorBuilder: () => const SizedBox(width: 8),
            children: [
              ListenableBuilder(
                listenable: controller.hexController,
                builder: (context, child) {
                  return Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(
                        int.tryParse(
                              'FF${controller.hexController.text}',
                              radix: 16,
                            ) ??
                            0x00000000,
                      ),
                    ),
                  );
                },
              ),
/* // TODO restore
              IconButton.outlined(
                icon: Icon(
                  LucideIcons.pipette,
                  color: Theme.of(context).colorScheme.onBackground,
                  size: 18,
                ),
                onPressed: () {
                  controller.pickHex(context);
                },
              ),
*/
            ],
          ),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a hex color';
        }
        if (!RegExp(r'^[0-9A-Fa-f]{6}$').hasMatch(value)) {
          return 'Please enter a valid 6-digit hex color';
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.always,
    );
  }
}

class _PaletteNameView extends StatelessWidget {
  final PaletteFiltersViewController controller;

  const _PaletteNameView({
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SeparatedColumn(
      crossAxisAlignment: CrossAxisAlignment.start,
      separatorBuilder: () {
        return const SizedBox(height: 12);
      },
      children: [
        const H1TextView('Palette name'),
        TextField(
          controller: controller.paletteNameController,
        ),
      ],
    );
  }
}

class _UserNameView extends StatelessWidget {
  final PaletteFiltersViewController controller;

  const _UserNameView({
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SeparatedColumn(
      crossAxisAlignment: CrossAxisAlignment.start,
      separatorBuilder: () {
        return const SizedBox(height: 12);
      },
      children: [
        const H1TextView('User name'),
        TextField(
          controller: controller.userNameController,
        ),
      ],
    );
  }
}
