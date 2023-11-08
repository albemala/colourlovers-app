import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ShareItemButton extends StatelessWidget {
  final void Function() onPressed;

  const ShareItemButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        Platform.isIOS || Platform.isMacOS
            ? LucideIcons.share
            : LucideIcons.share2,
      ),
    );
  }
}
