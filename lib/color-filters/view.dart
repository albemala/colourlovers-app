import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/color-filters/view-controller.dart';
import 'package:colourlovers_app/color-filters/view-state.dart';
import 'package:colourlovers_app/filters/defines.dart';
import 'package:colourlovers_app/filters/functions.dart';
import 'package:colourlovers_app/routing.dart';
import 'package:colourlovers_app/widgets/app-bar.dart';
import 'package:colourlovers_app/widgets/background/view.dart';
import 'package:colourlovers_app/widgets/color-values-range-selector.dart';
import 'package:colourlovers_app/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ColorFiltersViewCreator extends StatelessWidget {
  const ColorFiltersViewCreator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ColorFiltersViewController>(
      create: (context) {
        return ColorFiltersViewController.fromContext(context);
      },
      child: BlocBuilder<ColorFiltersViewController, ColorFiltersViewState>(
        builder: (context, state) {
          return ColorFiltersView(
            state: state,
            controller: context.read<ColorFiltersViewController>(),
          );
        },
      ),
    );
  }
}

class ColorFiltersView extends StatelessWidget {
  final ColorFiltersViewState state;
  final ColorFiltersViewController controller;

  const ColorFiltersView({
    super.key,
    required this.state,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarView(context, title: 'Filter Colors'),
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
                    _HueView(state: state, controller: controller),
                    _BrightnessView(state: state, controller: controller),
                    _ColorNameView(controller: controller),
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
  final ColorFiltersViewState state;
  final ColorFiltersViewController controller;

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
  final ColorFiltersViewState state;
  final ColorFiltersViewController controller;

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

class _HueView extends StatelessWidget {
  final ColorFiltersViewState state;
  final ColorFiltersViewController controller;

  const _HueView({required this.state, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        const H1TextView('Hue'),
        ColorValueRangeSelectorView(
          min: 0,
          max: 359,
          lowerValue: state.hueMin.toDouble(),
          upperValue: state.hueMax.toDouble(),
          onChanged: (lower, upper) {
            controller
              ..setHueMin(lower.toInt())
              ..setHueMax(upper.toInt());
          },
          getColor: (value) {
            return HSVColor.fromAHSV(1, value, 1, 1).toColor();
          },
        ),
      ],
    );
  }
}

class _BrightnessView extends StatelessWidget {
  final ColorFiltersViewState state;
  final ColorFiltersViewController controller;

  const _BrightnessView({required this.state, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        const H1TextView('Brightness'),
        ColorValueRangeSelectorView(
          min: 0,
          max: 99,
          lowerValue: state.brightnessMin.toDouble(),
          upperValue: state.brightnessMax.toDouble(),
          onChanged: (lower, upper) {
            controller
              ..setBrightnessMin(lower.toInt())
              ..setBrightnessMax(upper.toInt());
          },
          getColor: (value) {
            return HSVColor.fromAHSV(1, 0, 0, value / 100).toColor();
          },
        ),
      ],
    );
  }
}

class _ColorNameView extends StatelessWidget {
  final ColorFiltersViewController controller;

  const _ColorNameView({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        const H1TextView('Color name'),
        TextField(controller: controller.colorNameController),
      ],
    );
  }
}

class _UserNameView extends StatelessWidget {
  final ColorFiltersViewController controller;

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
