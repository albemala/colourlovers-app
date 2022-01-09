import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';

Future<void> copyToClipboard(BuildContext context, String? text) async {
  if (text == null || text.isEmpty) return;

  await FlutterClipboard.copy(text);

  ScaffoldMessenger.of(context).clearSnackBars();

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Text(text),
          const SizedBox(width: 4),
          const Text('copied to clipboard'),
        ],
      ),
      behavior: SnackBarBehavior.floating,
      // width: 240,
      duration: const Duration(seconds: 3),
    ),
  );
}
