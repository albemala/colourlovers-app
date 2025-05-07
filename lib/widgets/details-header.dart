import 'package:colourlovers_app/widgets/item-button.dart';
import 'package:flutter/material.dart';

class DetailsHeaderView extends StatelessWidget {
  final String title;
  final Widget item;
  final void Function() onItemTap;

  const DetailsHeaderView({
    super.key,
    required this.title,
    required this.item,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 16,
      children: [
        Center(
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        ItemButtonView(
          onTap: onItemTap,
          child: item,
        ),
      ],
    );
  }
}
