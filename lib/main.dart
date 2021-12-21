import 'package:colourlovers_app/views/app-view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(
    const ProviderScope(
      child: AppView(),
    ),
  );
}
