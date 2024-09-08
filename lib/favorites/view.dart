import 'package:colourlovers_app/widgets/app-top-bar.dart';
import 'package:flutter/material.dart';

class FavoritesView extends StatelessWidget {
  const FavoritesView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTopBarView(
        context,
        title: 'Favorites',
        actions: const [],
      ),
      body: const Center(
        child: Text('Favorites'),
      ),
    );
  }
}
