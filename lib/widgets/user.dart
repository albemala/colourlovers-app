import 'package:boxicons/boxicons.dart';
import 'package:flutter/material.dart';

class UserWidget extends StatelessWidget {
  const UserWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.primaryVariant,
      child: const Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: EdgeInsets.only(right: 8),
          child: Icon(
            BoxIcons.bx_user_circle_solid,
            size: 56,
            color: Color(0xFF7E22CE),
          ),
        ),
      ),
    );
  }
}
