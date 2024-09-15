import 'package:colourlovers_app/widgets/item-tiles/user-tile/view-state.dart';
import 'package:colourlovers_app/widgets/item-tiles/user-tile/view.dart';
import 'package:colourlovers_app/widgets/text.dart';
import 'package:flextras/flextras.dart';
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
    return SeparatedColumn(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      separatorBuilder: () => const SizedBox(height: 16),
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
