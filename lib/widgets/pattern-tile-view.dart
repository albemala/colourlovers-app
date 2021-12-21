import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/widgets/pattern-view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PatternTileView extends HookConsumerWidget {
  final ClPattern pattern;

  const PatternTileView({
    Key? key,
    required this.pattern,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      child: InkWell(
        onTap: () {
          // ref.read(routingService.notifier).showScreen(context, const ColorView(color: color));
        },
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 48,
                child: PatternView(imageUrl: pattern.imageUrl ?? ""),
              ),
            ),
            Text(pattern.title ?? ""),
          ],
        ),
      ),
    );
  }
}
