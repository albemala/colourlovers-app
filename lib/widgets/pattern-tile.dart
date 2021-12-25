import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/widgets/item-tile.dart';
import 'package:colourlovers_app/widgets/pattern.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PatternTileWidget extends HookConsumerWidget {
  final ClPattern pattern;

  const PatternTileWidget({
    Key? key,
    required this.pattern,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ItemTileWidget(
      onTap: () {
        // ref.read(routingProvider.notifier).showScreen(context, PatternDetailsView(pattern: pattern));
      },
      title: pattern.title,
      numViews: pattern.numViews,
      numVotes: pattern.numVotes,
      child: PatternWidget(
        imageUrl: pattern.imageUrl,
      ),
    );
  }
}
