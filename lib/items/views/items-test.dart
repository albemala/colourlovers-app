import 'package:colourlovers_app/items/views/colors.dart';
import 'package:colourlovers_app/items/views/palettes.dart';
import 'package:colourlovers_app/items/views/patterns.dart';
import 'package:colourlovers_app/items/views/users.dart';
import 'package:flutter/material.dart';

class ItemsTestView extends StatelessWidget {
  const ItemsTestView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(child: ColorsViewBuilder()),
        Expanded(child: PalettesViewBuilder()),
        Expanded(child: PatternsViewBuilder()),
        Expanded(child: UsersViewBuilder()),
      ],
    );
  }
}
