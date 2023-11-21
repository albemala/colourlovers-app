import 'package:colourlovers_app/common/widgets/h2-text.dart';
import 'package:flextras/flextras.dart';
import 'package:flutter/material.dart';

class RelatedItemsPreviewView<ItemType> extends StatelessWidget {
  final String title;
  final List<ItemType> items;
  final Widget Function(ItemType item) itemBuilder;
  final void Function() onShowMorePressed;

  const RelatedItemsPreviewView({
    super.key,
    required this.title,
    required this.items,
    required this.itemBuilder,
    required this.onShowMorePressed,
  });

  @override
  Widget build(BuildContext context) {
    return SeparatedColumn(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      separatorBuilder: () {
        return const SizedBox(height: 16);
      },
      children: [
        H2TextView(title),
        SeparatedColumn(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          separatorBuilder: () {
            return const SizedBox(height: 8);
          },
          children: [
            ...items.map(itemBuilder),
            OutlinedButton(
              onPressed: onShowMorePressed,
              child: const Text('Show more'),
            ),
          ],
        ),
      ],
    );
  }
}
