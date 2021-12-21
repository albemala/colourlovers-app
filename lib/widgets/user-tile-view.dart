import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class UserTileView extends HookConsumerWidget {
  final ClLover lover;

  const UserTileView({
    Key? key,
    required this.lover,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      child: InkWell(
        onTap: () {
          // ref.read(routingProvider.notifier).showScreen(context, const ColorView(color: color));
        },
        child: SizedBox(
          height: 48,
          child: Center(
            child: Text(lover.userName ?? ""),
          ),
        ),
      ),
    );
  }
}
