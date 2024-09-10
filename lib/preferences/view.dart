import 'package:colourlovers_app/widgets/app-top-bar.dart';
import 'package:flutter/material.dart';

class PreferencesView extends StatelessWidget {
  const PreferencesView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTopBarView(
        context,
        title: 'Preferences',
        actions: const [
          // ThemeModeToggleButton(),
          // TODO add padding to the left
        ],
      ),
      body: const Center(
        child: Text('Preferences'),
      ),
    );
  }
}
