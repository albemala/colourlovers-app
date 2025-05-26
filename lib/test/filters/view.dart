import 'package:colourlovers_app/color-filters/view.dart';
import 'package:colourlovers_app/palette-filters/view.dart';
import 'package:colourlovers_app/pattern-filters/view.dart';
import 'package:colourlovers_app/user-filters/view.dart';
import 'package:flutter/material.dart';

class FiltersTestView extends StatelessWidget {
  const FiltersTestView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(child: ColorFiltersViewCreator()),
        Expanded(child: PaletteFiltersViewCreator()),
        Expanded(child: PatternFiltersViewCreator()),
        Expanded(child: UserFiltersViewCreator()),
      ],
    );
  }
}
