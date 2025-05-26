import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/filters/defines.dart';
import 'package:colourlovers_app/filters/functions.dart';
import 'package:colourlovers_app/pattern-filters/view-controller.dart';
import 'package:colourlovers_app/pattern-filters/view-state.dart';
import 'package:colourlovers_app/routing.dart';
import 'package:colourlovers_app/widgets/app-bar.dart';
import 'package:colourlovers_app/widgets/background/view.dart';
import 'package:colourlovers_app/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PatternFiltersViewCreator extends StatelessWidget {
  const PatternFiltersViewCreator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PatternFiltersViewController>(
      create: (context) {
        return PatternFiltersViewController.fromContext(context);
      },
      child: BlocBuilder<PatternFiltersViewController, PatternFiltersViewState>(
        builder: (context, state) {
          return PatternFiltersView(
            state: state,
            controller: context.read<PatternFiltersViewController>(),
          );
        },
      ),
    );
  }
}

class PatternFiltersView extends StatelessWidget {
  final PatternFiltersViewState state;
  final PatternFiltersViewController controller;

  const PatternFiltersView({
    super.key,
    required this.state,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarView(context, title: 'Filter Patterns'),
      body: BackgroundView(
        blobs: state.backgroundBlobs.toList(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 32,
                  children: [
                    _ShowView(state: state, controller: controller),
                    if (state.showCriteria == ContentShowCriteria.all)
                      _SortByView(state: state, controller: controller),
                    _ColorFilterView(state: state, controller: controller),
                    if (state.colorFilter == ColorFilter.hueRanges)
                      _HueRangesView(state: state, controller: controller),
                    if (state.colorFilter == ColorFilter.hex)
                      _HexView(state: state, controller: controller),
                    _PatternNameView(controller: controller),
                    _UserNameView(controller: controller),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: 16,
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
      ),
    );
  }
}

class _ShowView extends StatelessWidget {
  final PatternFiltersViewState state;
  final PatternFiltersViewController controller;

  const _ShowView({required this.state, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        const H1TextView('Show'),
        Row(
          spacing: 8,
          children:
              ContentShowCriteria.values.map((showCriteria) {
                return ChoiceChip(
                  label: Text(getContentShowCriteriaName(showCriteria)),
                  selected: state.showCriteria == showCriteria,
                  onSelected: (bool value) {
                    controller.setShowCriteria(showCriteria);
                  },
                );
              }).toList(),
        ),
      ],
    );
  }
}

class _SortByView extends StatelessWidget {
  final PatternFiltersViewState state;
  final PatternFiltersViewController controller;

  const _SortByView({required this.state, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        const H1TextView('Sort By'),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            spacing: 8,
            children:
                ColourloversRequestOrderBy.values.map((sortBy) {
                  return ChoiceChip(
                    label: Text(getColourloversRequestOrderByName(sortBy)),
                    selected: state.sortBy == sortBy,
                    onSelected: (bool value) {
                      controller.setSortBy(sortBy);
                    },
                  );
                }).toList(),
          ),
        ),
        Row(
          spacing: 8,
          children:
              ColourloversRequestSortBy.values.map((sortOrder) {
                return ChoiceChip(
                  label: Text(getColourloversRequestSortByName(sortOrder)),
                  selected: state.sortOrder == sortOrder,
                  onSelected: (bool value) {
                    controller.setOrder(sortOrder);
                  },
                );
              }).toList(),
        ),
      ],
    );
  }
}

class _ColorFilterView extends StatelessWidget {
  final PatternFiltersViewState state;
  final PatternFiltersViewController controller;

  const _ColorFilterView({required this.state, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        const H1TextView('Color Filter'),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            spacing: 8,
            children:
                ColorFilter.values.map((colorFilter) {
                  return ChoiceChip(
                    label: Text(getColorFilterName(colorFilter)),
                    selected: state.colorFilter == colorFilter,
                    onSelected: (bool value) {
                      controller.setColorFilter(colorFilter);
                    },
                  );
                }).toList(),
          ),
        ),
      ],
    );
  }
}

class _HueRangesView extends StatelessWidget {
  final PatternFiltersViewState state;
  final PatternFiltersViewController controller;

  const _HueRangesView({required this.state, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children:
          ColourloversRequestHueRange.values.map((hueRange) {
            return ChoiceChip(
              avatar: Container(
                decoration: BoxDecoration(
                  color: getColourloversRequestHueRangeColor(hueRange),
                  shape: BoxShape.circle,
                ),
                width: 18,
                height: 18,
              ),
              label: Text(getColourloversRequestHueRangeName(hueRange)),
              selected: state.hueRanges.contains(hueRange),
              onSelected: (bool selected) {
                if (selected) {
                  controller.addHueRange(context, hueRange);
                } else {
                  controller.removeHueRange(hueRange);
                }
              },
            );
          }).toList(),
    );
  }
}

class _HexView extends StatelessWidget {
  final PatternFiltersViewState state;
  final PatternFiltersViewController controller;

  const _HexView({required this.state, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller.hexController,
      decoration: InputDecoration(
        prefixText: '#',
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 8,
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

class _PatternNameView extends StatelessWidget {
  final PatternFiltersViewController controller;

  const _PatternNameView({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        const H1TextView('Pattern name'),
        TextField(controller: controller.patternNameController),
      ],
    );
  }
}

class _UserNameView extends StatelessWidget {
  final PatternFiltersViewController controller;

  const _UserNameView({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        const H1TextView('User name'),
        TextField(controller: controller.userNameController),
      ],
    );
  }
}
