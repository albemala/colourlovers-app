import 'package:colourlovers_app/widgets/item-tiles/user-tile/view-state.dart';
import 'package:colourlovers_app/widgets/item-tiles/user-tile/view.dart';
import 'package:colourlovers_app/widgets/text.dart';
import 'package:flutter/material.dart';

class CreatedByView extends StatelessWidget {
  final UserTileViewState user;
  final void Function() onUserTap;

  const CreatedByView({
    super.key,
    required this.user,
    required this.onUserTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 16,
      children: [
        const H2TextView('Created by'),
        UserTileView(
          state: user,
          onTap: onUserTap,
        ),
      ],
    );
  }
}
