import 'package:flutter/material.dart';

void showSnackBar(
  BuildContext context,
  SnackBar snackBar,
) {
  if (!context.mounted) return;
  ScaffoldMessenger.of(context)
      // ..clearSnackBars()
      .showSnackBar(snackBar);
}

Future<ReturnType?> openDialog<ReturnType>(
  BuildContext context,
  Widget dialog,
) async {
  if (!context.mounted) return null;
  return showDialog<ReturnType>(
    context: context,
    // barrierDismissible: false,
    builder: (_) => dialog,
  );
}

void openBottomSheet(
  BuildContext context,
  Widget bottomSheet,
) {
  if (!context.mounted) return;
  showModalBottomSheet<void>(
    context: context,
    builder: (_) => bottomSheet,
  );
}

void openScreen(
  BuildContext context,
  Widget route,
) {
  if (!context.mounted) return;
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => route,
    ),
  );
}

void closeCurrentView<ReturnType>(
  BuildContext context, [
  ReturnType? result,
]) {
  if (!context.mounted) return;
  Navigator.of(context).pop(result);
}
