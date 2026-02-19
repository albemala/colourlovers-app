import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/filters/functions.dart';
import 'package:flutter/material.dart';

class HueRangesView extends StatelessWidget {
  final List<ColourloversRequestHueRange> hueRanges;
  final void Function(ColourloversRequestHueRange range, bool selected)
  onSelected;

  const HueRangesView({
    super.key,
    required this.hueRanges,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: ColourloversRequestHueRange.values.map((hueRange) {
        return ChoiceChip(
          avatar: SizedBox(
            width: 18,
            height: 18,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: getColourloversRequestHueRangeColor(hueRange),
                shape: BoxShape.circle,
              ),
            ),
          ),
          label: Text(getColourloversRequestHueRangeName(hueRange)),
          selected: hueRanges.contains(hueRange),
          onSelected: (selected) => onSelected(hueRange, selected),
        );
      }).toList(),
    );
  }
}
