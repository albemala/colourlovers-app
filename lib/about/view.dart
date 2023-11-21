import 'package:colourlovers_app/common/widgets/app-top-bar.dart';
import 'package:flutter/material.dart';

class AboutView extends StatelessWidget {
  const AboutView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTopBarView(
        context,
        title: 'About',
        actions: const [
          // ThemeModeToggleButton(),
          // TODO add padding to the left
        ],
      ),
      body: const Center(
        child: Text('About'),
      ),
    );
  }
}
