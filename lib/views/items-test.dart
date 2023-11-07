import 'package:colourlovers_app/views/colors.dart';
import 'package:colourlovers_app/views/palettes.dart';
import 'package:colourlovers_app/views/patterns.dart';
import 'package:colourlovers_app/views/users.dart';
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
