import 'package:another_xlider/another_xlider.dart';
import 'package:another_xlider/models/handler.dart';
import 'package:another_xlider/models/tooltip/tooltip.dart';
import 'package:another_xlider/models/tooltip/tooltip_box.dart';
import 'package:another_xlider/models/trackbar.dart';
import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/color-filters/view-controller.dart';
import 'package:colourlovers_app/color-filters/view-state.dart';
import 'package:colourlovers_app/item-filters/defines.dart';
import 'package:colourlovers_app/item-filters/functions.dart';
import 'package:colourlovers_app/widgets/app-top-bar.dart';
import 'package:colourlovers_app/widgets/h1-text.dart';
import 'package:flextras/flextras.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ColorFiltersViewCreator extends StatelessWidget {
  final ColorFiltersViewState initialState;
  final void Function(ColorFiltersViewState) onApply;

  const ColorFiltersViewCreator({
    super.key,
    required this.initialState,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ColorFiltersViewController>(
      create: (context) {
        return ColorFiltersViewController.fromContext(
          context,
          initialState: initialState,
          onApply: onApply,
        );
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
      appBar: AppTopBarView(
        context,
        title: 'Filter Colors',
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
                  if (state.filter == ItemsFilter.all)
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
            child: FilledButton(
              onPressed: () {
                controller.onApply(state);
              },
              child: const Text('Apply'),
            ),
          ),
        ],
      ),
    );
  }
}

const handlerWidth = 24.0;

class _ShowView extends StatelessWidget {
  final ColorFiltersViewState state;
  final ColorFiltersViewController controller;

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
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: ItemsFilter.values
              .map(
                (e) => ChoiceChip(
                  label: Text(
                    getItemFilterName(e),
                  ),
                  selected: state.filter == e,
                  onSelected: (bool value) {
                    controller.setFilter(e);
                  },
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _SortByView extends StatelessWidget {
  final ColorFiltersViewState state;
  final ColorFiltersViewController controller;

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
        Wrap(
          spacing: 4,
          runSpacing: 4,
          children: ColourloversRequestOrderBy.values
              .map(
                (e) => ChoiceChip(
                  label: Text(
                    getColourloversRequestOrderByName(e),
                  ),
                  selected: state.sortBy == e,
                  onSelected: (bool value) {
                    controller.setSortBy(e);
                  },
                ),
              )
              .toList(),
        ),
        Wrap(
          spacing: 4,
          runSpacing: 4,
          children: ColourloversRequestSortBy.values
              .map(
                (e) => ChoiceChip(
                  label: Text(
                    getColourloversRequestSortByName(e),
                  ),
                  selected: state.order == e,
                  onSelected: (bool value) {
                    controller.setOrder(e);
                  },
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _HueView extends StatelessWidget {
  final ColorFiltersViewState state;
  final ColorFiltersViewController controller;

  const _HueView({
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
        const H1TextView('Hue'),
        FlutterSlider(
          rangeSlider: true,
          min: 0,
          max: 359,
          values: [
            state.hueMin.toDouble(),
            state.hueMax.toDouble(),
          ],
          onDragging: (handlerIndex, lowerValue, upperValue) {
            controller
              ..setHueMin((lowerValue as double).toInt())
              ..setHueMax((upperValue as double).toInt());
          },
          handlerWidth: handlerWidth,
          handler: buildFlutterSliderHandler(
            context,
            color: HSVColor.fromAHSV(
              1,
              state.hueMin.toDouble(),
              1,
              1,
            ).toColor(),
            handlerWidth: handlerWidth,
          ),
          rightHandler: buildFlutterSliderHandler(
            context,
            color: HSVColor.fromAHSV(
              1,
              state.hueMax.toDouble(),
              1,
              1,
            ).toColor(),
            handlerWidth: handlerWidth,
          ),
          trackBar: buildFlutterSliderTrackBar(
            context,
            colors: List.generate(
              state.hueMax - state.hueMin,
              (index) => HSVColor.fromAHSV(
                1,
                (state.hueMin + index).toDouble(),
                1,
                1,
              ).toColor(),
            ),
          ),
          tooltip: buildFlutterSliderTooltip(context),
        ),
      ],
    );
  }
}

class _BrightnessView extends StatelessWidget {
  final ColorFiltersViewState state;
  final ColorFiltersViewController controller;

  const _BrightnessView({
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
        const H1TextView('Brightness'),
        FlutterSlider(
          rangeSlider: true,
          min: 0,
          max: 99,
          values: [
            state.brightnessMin.toDouble(),
            state.brightnessMax.toDouble(),
          ],
          onDragging: (handlerIndex, lowerValue, upperValue) {
            controller
              ..setBrightnessMin((lowerValue as double).toInt())
              ..setBrightnessMax((upperValue as double).toInt());
          },
          handlerWidth: handlerWidth,
          handler: buildFlutterSliderHandler(
            context,
            color: HSVColor.fromAHSV(
              1,
              0,
              0,
              state.brightnessMin / 100,
            ).toColor(),
            handlerWidth: handlerWidth,
          ),
          rightHandler: buildFlutterSliderHandler(
            context,
            color: HSVColor.fromAHSV(
              1,
              0,
              0,
              state.brightnessMax / 100,
            ).toColor(),
            handlerWidth: handlerWidth,
          ),
          trackBar: buildFlutterSliderTrackBar(
            context,
            colors: List.generate(
              state.brightnessMax - state.brightnessMin,
              (index) => HSVColor.fromAHSV(
                1,
                0,
                0,
                (state.brightnessMin + index) / 100,
              ).toColor(),
            ),
          ),
          tooltip: buildFlutterSliderTooltip(context),
        ),
      ],
    );
  }
}

class _ColorNameView extends StatelessWidget {
  final ColorFiltersViewController controller;

  const _ColorNameView({
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
        const H1TextView('Color name'),
        TextField(
          controller: controller.colorNameController,
          onChanged: controller.setColorName,
        ),
      ],
    );
  }
}

class _UserNameView extends StatelessWidget {
  final ColorFiltersViewController controller;

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
          onChanged: controller.setUserName,
        ),
      ],
    );
  }
}

FlutterSliderHandler buildFlutterSliderHandler(
  BuildContext context, {
  required Color color,
  required double handlerWidth,
}) {
  const padding = 6;
  return FlutterSliderHandler(
    child: Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        shape: BoxShape.circle,
      ),
      child: Container(
        width: handlerWidth - padding,
        height: handlerWidth - padding,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    ),
  );
}

FlutterSliderTrackBar buildFlutterSliderTrackBar(
  BuildContext context, {
  required List<Color> colors,
}) {
  return FlutterSliderTrackBar(
    activeTrackBarHeight: 8,
    activeTrackBar: BoxDecoration(
      color: Theme.of(context).colorScheme.primary,
      gradient: colors.length > 2
          ? LinearGradient(
              colors: colors,
            )
          : null,
    ),
    inactiveTrackBar: const BoxDecoration(
      color: Colors.transparent,
    ),
  );
}

FlutterSliderTooltip buildFlutterSliderTooltip(BuildContext context) {
  return FlutterSliderTooltip(
    textStyle: Theme.of(context).textTheme.bodyMedium,
    boxStyle: FlutterSliderTooltipBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(32),
      ),
    ),
    format: (value) {
      return double.tryParse(value)?.toInt().toString() ?? '';
    },
  );
}
