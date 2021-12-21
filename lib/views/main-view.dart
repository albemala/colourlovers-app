import 'package:colourlovers_app/providers/providers.dart';
import 'package:colourlovers_app/providers/routing-provider.dart';
import 'package:colourlovers_app/views/about-view.dart';
import 'package:colourlovers_app/views/explore-view.dart';
import 'package:colourlovers_app/views/favorites-view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MainView extends HookConsumerWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final route = ref.watch(routingProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitle(route)),
      ),
      body: _getBody(route),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: route.index,
        onTap: ref.read(routingProvider.notifier).setRoute,
        items: const [
          BottomNavigationBarItem(
            label: "Explore",
            // TODO change icon
            icon: Icon(Icons.home_outlined),
          ),
          BottomNavigationBarItem(
            label: "Favorites",
            icon: Icon(Icons.star_outline),
          ),
          BottomNavigationBarItem(
            label: "About",
            icon: Icon(Icons.info_outline),
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
      default:
        return Container();
    }
  }

  String _getTitle(MainRoute route) {
    switch (route) {
      case MainRoute.explore:
        return "Explore";
      case MainRoute.favorites:
        return "Favorites";
      case MainRoute.about:
        return "About";
      default:
        return "";
    }
  }
}
