import 'package:colourlovers_app/filters/color/view.dart';
import 'package:colourlovers_app/filters/favorites/view.dart';
import 'package:colourlovers_app/filters/palette/view.dart';
import 'package:colourlovers_app/filters/pattern/view.dart';
import 'package:colourlovers_app/filters/user/view.dart';
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
        Expanded(child: FavoritesFiltersViewCreator()),
      ],
    );
  }
}
