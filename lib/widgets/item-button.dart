import 'package:flutter/material.dart';

// TODO reuse this widget in other places

class ItemButtonView extends StatelessWidget {
  final void Function() onTap;
  final Widget child;

  const ItemButtonView({super.key, required this.onTap, required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Stack(
        children: [
          SizedBox.expand(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: child,
            ),
          ),
          Material(
            type: MaterialType.transparency,
            child: InkWell(onTap: onTap),
          ),
        ],
      ),
    );
  }
}
