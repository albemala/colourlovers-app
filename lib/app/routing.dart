import 'package:flutter/material.dart';

void showSnackBar(
  BuildContext context,
  SnackBar view,
) {
  if (!context.mounted) return;
  ScaffoldMessenger.of(context)
    ..clearSnackBars()
    ..showSnackBar(view);
}

void showModalDialog(
  BuildContext context,
  AlertDialog view,
) {
  if (!context.mounted) return;
  showDialog<void>(
    context: context,
    builder: (_) => view,
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
  Widget view, {
  bool fullscreenDialog = false,
}) {
  if (!context.mounted) return;
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      fullscreenDialog: fullscreenDialog,
      builder: (_) => view,
    ),
  );
}

void closeCurrentRoute(BuildContext context) {
  if (!context.mounted) return;
  Navigator.of(context).pop();
}
