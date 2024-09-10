import 'package:colourlovers_app/widgets/app-bar.dart';
import 'package:flutter/material.dart';

class PreferencesView extends StatelessWidget {
  const PreferencesView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarView(
        context,
        title: 'Preferences',
      ),
      body: const Center(
        child: Text('Preferences'),
      ),
    );
  }
}
