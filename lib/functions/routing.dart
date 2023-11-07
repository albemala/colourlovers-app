import 'package:flutter/material.dart';

void showSnackBar(
  BuildContext context,
  SnackBar Function(BuildContext context) builder,
) {
  if (!context.mounted) return;
  ScaffoldMessenger.of(context)
    ..clearSnackBars()
    ..showSnackBar(builder(context));
}

void showModalDialog(
  BuildContext context,
  AlertDialog dialog,
) {
  if (!context.mounted) return;
  showDialog<void>(
    context: context,
    builder: (_) => dialog,
  );
}

void showBottomSheet(
  BuildContext context,
  Widget view,
) {
  if (!context.mounted) return;
  showModalBottomSheet<void>(
    context: context,
    builder: (_) => view,
  );
}

void openRoute(
  BuildContext context,
  Widget view,
) {
  if (!context.mounted) return;
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => view,
    ),
  );
}

void closeCurrentRoute(BuildContext context) {
  if (!context.mounted) return;
  Navigator.of(context).pop();
}
