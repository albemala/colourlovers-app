import 'package:flutter/material.dart';

SnackBar createGenericSnackBar({
  required String message,
  SnackBarBehavior behavior = SnackBarBehavior.floating,
  Duration duration = const Duration(seconds: 3),
}) {
  return SnackBar(
    content: Text(message),
    behavior: behavior,
    duration: duration,
  );
}

SnackBar createCopiedToClipboardSnackBar(String text) {
  return createGenericSnackBar(message: '$text copied to clipboard');
}
