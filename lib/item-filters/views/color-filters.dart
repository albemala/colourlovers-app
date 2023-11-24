import 'package:another_xlider/another_xlider.dart';
import 'package:another_xlider/models/handler.dart';
import 'package:another_xlider/models/tooltip/tooltip.dart';
import 'package:another_xlider/models/tooltip/tooltip_box.dart';
import 'package:another_xlider/models/trackbar.dart';
import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/common/widgets/app-top-bar.dart';
import 'package:colourlovers_app/common/widgets/h1-text.dart';
import 'package:colourlovers_app/item-filters/defines/filters.dart';
import 'package:colourlovers_app/item-filters/functions/filters.dart';
import 'package:flextras/flextras.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@immutable
class ColorFiltersViewModel {
  final ItemsFilter filter;
  final ColourloversRequestOrderBy sortBy;
  final ColourloversRequestSortBy order;
  final int hueMin;
  final int hueMax;
  final int brightnessMin;
  final int brightnessMax;
  final String colorName;
  final String userName;

  const ColorFiltersViewModel({
    required this.filter,
    required this.sortBy,
    required this.order,
    required this.hueMin,
    required this.hueMax,
    required this.brightnessMin,
    required this.brightnessMax,
    required this.colorName,
    required this.userName,
  });

  factory ColorFiltersViewModel.initialState() {
    return const ColorFiltersViewModel(
      filter: ItemsFilter.newest,
      sortBy: ColourloversRequestOrderBy.numVotes,
      order: ColourloversRequestSortBy.DESC,
      hueMin: 0,
      hueMax: 359,
      brightnessMin: 0,
      brightnessMax: 99,
      colorName: '',
      userName: '',
    );
  }
}

class ColorFiltersViewBloc extends Cubit<ColorFiltersViewModel> {
  factory ColorFiltersViewBloc.fromContext(
    BuildContext context, {
    required ColorFiltersViewModel initialState,
    required void Function(ColorFiltersViewModel) onApply,
  }) {
    return ColorFiltersViewBloc(
      initialState,
      onApply,
    );
  }

  final void Function(ColorFiltersViewModel) onApply;

  late ItemsFilter _filter;
  late ColourloversRequestOrderBy _sortBy;
  late ColourloversRequestSortBy _order;
  late int _hueMin;
  late int _hueMax;
  late int _brightnessMin;
  late int _brightnessMax;
  final colorNameController = TextEditingController();
  final userNameController = TextEditingController();

  ColorFiltersViewBloc(
    super.initialState,
    this.onApply,
  ) {
    _filter = state.filter;
    _sortBy = state.sortBy;
    _order = state.order;
    _hueMin = state.hueMin;
    _hueMax = state.hueMax;
    _brightnessMin = state.brightnessMin;
    _brightnessMax = state.brightnessMax;
    colorNameController.value = TextEditingValue(
      text: state.colorName,
      selection: colorNameController.selection,
    );
    userNameController.value = TextEditingValue(
      text: state.userName,
      selection: userNameController.selection,
    );
  }

  @override
  Future<void> close() {
    colorNameController.dispose();
    userNameController.dispose();
    return super.close();
  }

  void setFilter(ItemsFilter value) {
    _filter = value;
    _updateState();
  }

  void setSortBy(ColourloversRequestOrderBy value) {
    _sortBy = value;
    _updateState();
  }

  void setOrder(ColourloversRequestSortBy value) {
    _order = value;
    _updateState();
  }

  void setHueMin(int value) {
    _hueMin = value;
    _updateState();
  }

  void setHueMax(int value) {
    _hueMax = value;
    _updateState();
  }

  void setBrightnessMin(int value) {
    _brightnessMin = value;
    _updateState();
  }

  void setBrightnessMax(int value) {
    _brightnessMax = value;
    _updateState();
  }

  void setColorName(String value) {
    colorNameController.value = TextEditingValue(
      text: value,
      selection: colorNameController.selection,
    );
    _updateState();
  }

  void setUserName(String value) {
    userNameController.value = TextEditingValue(
      text: value,
      selection: userNameController.selection,
    );
    _updateState();
  }

  void _updateState() {
    emit(
      ColorFiltersViewModel(
        filter: _filter,
        sortBy: _sortBy,
        order: _order,
        hueMin: _hueMin,
        hueMax: _hueMax,
        brightnessMin: _brightnessMin,
        brightnessMax: _brightnessMax,
        colorName: colorNameController.text,
        userName: userNameController.text,
      ),
    );
  }
}

class ColorFiltersViewBuilder extends StatelessWidget {
  final ColorFiltersViewModel initialState;
  final void Function(ColorFiltersViewModel) onApply;

  const ColorFiltersViewBuilder({
    super.key,
    required this.initialState,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ColorFiltersViewBloc>(
      create: (context) => ColorFiltersViewBloc.fromContext(
        context,
        initialState: initialState,
        onApply: onApply,
      ),
      child: BlocBuilder<ColorFiltersViewBloc, ColorFiltersViewModel>(
        builder: (context, viewModel) {
          return ColorFiltersView(
            viewModel: viewModel,
            bloc: context.read<ColorFiltersViewBloc>(),
          );
        },
      ),
    );
  }
}

class ColorFiltersView extends StatelessWidget {
  final ColorFiltersViewModel viewModel;
  final ColorFiltersViewBloc bloc;

  const ColorFiltersView({
    super.key,
    required this.viewModel,
    required this.bloc,
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
                  _ShowView(viewModel: viewModel, bloc: bloc),
                  if (viewModel.filter == ItemsFilter.all)
                    _SortByView(viewModel: viewModel, bloc: bloc),
                  _HueView(viewModel: viewModel, bloc: bloc),
                  _BrightnessView(viewModel: viewModel, bloc: bloc),
                  _ColorNameView(bloc: bloc),
                  _UserNameView(bloc: bloc),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: FilledButton(
              onPressed: () {
                bloc.onApply(viewModel);
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
  final ColorFiltersViewModel viewModel;
  final ColorFiltersViewBloc bloc;

  const _ShowView({
    required this.viewModel,
    required this.bloc,
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
                  selected: viewModel.filter == e,
                  onSelected: (bool value) {
                    bloc.setFilter(e);
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
  final ColorFiltersViewModel viewModel;
  final ColorFiltersViewBloc bloc;

  const _SortByView({
    required this.viewModel,
    required this.bloc,
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
                  selected: viewModel.sortBy == e,
                  onSelected: (bool value) {
                    bloc.setSortBy(e);
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
                  selected: viewModel.order == e,
                  onSelected: (bool value) {
                    bloc.setOrder(e);
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
  final ColorFiltersViewModel viewModel;
  final ColorFiltersViewBloc bloc;

  const _HueView({
    required this.viewModel,
    required this.bloc,
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
            viewModel.hueMin.toDouble(),
            viewModel.hueMax.toDouble(),
          ],
          onDragging: (handlerIndex, lowerValue, upperValue) {
            bloc
              ..setHueMin((lowerValue as double).toInt())
              ..setHueMax((upperValue as double).toInt());
          },
          handlerWidth: handlerWidth,
          handler: buildFlutterSliderHandler(
            context,
            color: HSVColor.fromAHSV(
              1,
              viewModel.hueMin.toDouble(),
              1,
              1,
            ).toColor(),
            handlerWidth: handlerWidth,
          ),
          rightHandler: buildFlutterSliderHandler(
            context,
            color: HSVColor.fromAHSV(
              1,
              viewModel.hueMax.toDouble(),
              1,
              1,
            ).toColor(),
            handlerWidth: handlerWidth,
          ),
          trackBar: buildFlutterSliderTrackBar(
            context,
            colors: List.generate(
              viewModel.hueMax - viewModel.hueMin,
              (index) => HSVColor.fromAHSV(
                1,
                (viewModel.hueMin + index).toDouble(),
                1,
                1,
              ).toColor(),
            ),
          ),
          tooltip: buildFlutterSliderTooltip(context),
        )
      ],
    );
  }
}

class _BrightnessView extends StatelessWidget {
  final ColorFiltersViewModel viewModel;
  final ColorFiltersViewBloc bloc;

  const _BrightnessView({
    required this.viewModel,
    required this.bloc,
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
            viewModel.brightnessMin.toDouble(),
            viewModel.brightnessMax.toDouble(),
          ],
          onDragging: (handlerIndex, lowerValue, upperValue) {
            bloc
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
              viewModel.brightnessMin / 100,
            ).toColor(),
            handlerWidth: handlerWidth,
          ),
          rightHandler: buildFlutterSliderHandler(
            context,
            color: HSVColor.fromAHSV(
              1,
              0,
              0,
              viewModel.brightnessMax / 100,
            ).toColor(),
            handlerWidth: handlerWidth,
          ),
          trackBar: buildFlutterSliderTrackBar(
            context,
            colors: List.generate(
              viewModel.brightnessMax - viewModel.brightnessMin,
              (index) => HSVColor.fromAHSV(
                1,
                0,
                0,
                (viewModel.brightnessMin + index) / 100,
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
  final ColorFiltersViewBloc bloc;

  const _ColorNameView({
    required this.bloc,
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
          controller: bloc.colorNameController,
          onChanged: bloc.setColorName,
        ),
      ],
    );
  }
}

class _UserNameView extends StatelessWidget {
  final ColorFiltersViewBloc bloc;

  const _UserNameView({
    required this.bloc,
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
          controller: bloc.userNameController,
          onChanged: bloc.setUserName,
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
