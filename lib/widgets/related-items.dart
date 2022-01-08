import 'package:colourlovers_app/widgets/h2-text.dart';
import 'package:flutter/material.dart';

class RelatedItemsWidget<ItemType> extends StatelessWidget {
  final String title;
  final List<ItemType> items;
  final Widget Function(ItemType item) itemBuilder;

  const RelatedItemsWidget({
    Key? key,
    required this.title,
    required this.items,
    required this.itemBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        H2TextWidget(title),
        const SizedBox(height: 16),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items.elementAt(index);
            return item != null ? itemBuilder(item) : Container();
          },
          separatorBuilder: (context, index) => const SizedBox(height: 8),
        ),
        const SizedBox(height: 8),
        OutlinedButton(
          onPressed: () {},
          child: const Text('Show more'),
        ),
      ],
    );
  }
}
