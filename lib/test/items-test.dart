import 'package:colourlovers_app/colors/view.dart';
import 'package:colourlovers_app/palettes/view.dart';
import 'package:colourlovers_app/patterns/view.dart';
import 'package:colourlovers_app/users/view.dart';
import 'package:flutter/material.dart';

class ItemsTestView extends StatelessWidget {
  const ItemsTestView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(child: ColorsViewCreator()),
        Expanded(child: PalettesViewCreator()),
        Expanded(child: PatternsViewCreator()),
        Expanded(child: UsersViewCreator()),
      ],
    );
  }
}
