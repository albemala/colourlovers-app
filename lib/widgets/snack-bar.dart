import 'package:flutter/material.dart';

SnackBar createCopiedToClipboardSnackBar(String text) {
  return SnackBar(
    content: Row(
      children: [
        Text(text),
        const Text(' copied to clipboard'),
      ],
    ),
    behavior: SnackBarBehavior.floating,
    // width: 240,
    duration: const Duration(seconds: 3),
  );
}
