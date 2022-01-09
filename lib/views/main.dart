import 'package:boxicons/boxicons.dart';
import 'package:colourlovers_app/providers/providers.dart';
import 'package:colourlovers_app/providers/routing-provider.dart';
import 'package:colourlovers_app/views/about.dart';
import 'package:colourlovers_app/views/explore.dart';
import 'package:colourlovers_app/views/favorites.dart';
import 'package:colourlovers_app/widgets/app-bar.dart';
import 'package:colourlovers_app/widgets/background.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MainView extends HookConsumerWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final route = ref.watch(routingProvider);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBarWidget(
        context,
        titleText: _getTitle(route),
      ),
      body: BackgroundWidget(
        colors: defaultBackgroundColors,
        child: _getBody(route),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: route.index,
        onTap: ref.read(routingProvider.notifier).setRoute,
        items: const [
          BottomNavigationBarItem(
            label: 'Explore',
            icon: Icon(BoxIcons.bx_compass_regular),
          ),
          BottomNavigationBarItem(
            label: 'Favorites',
            icon: Icon(BoxIcons.bx_star_regular),
          ),
          BottomNavigationBarItem(
            label: 'About',
            icon: Icon(BoxIcons.bx_info_circle_regular),
          ),
        ],
      ),
    );
  }

  Widget _getBody(MainRoute route) {
    switch (route) {
      case MainRoute.explore:
        return const ExploreView();
      case MainRoute.favorites:
        return const FavoritesView();
      case MainRoute.about:
        return const AboutView();
    }
  }

  String _getTitle(MainRoute route) {
    switch (route) {
      case MainRoute.explore:
        return 'Explore';
      case MainRoute.favorites:
        return 'Favorites';
      case MainRoute.about:
        return 'About';
    }
  }
}
