import 'package:colourlovers_app/conductors/preferences.dart';
import 'package:colourlovers_app/views/about.dart';
import 'package:colourlovers_app/views/explore.dart';
import 'package:colourlovers_app/views/favorites.dart';
import 'package:colourlovers_app/widgets/app-top-bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_state_management/flutter_state_management.dart';
import 'package:lucide_icons/lucide_icons.dart';

enum MainRoute {
  explore,
  favorites,
  about,
}

String getRouteTitle(MainRoute route) {
  switch (route) {
    case MainRoute.explore:
      return 'Explore';
    case MainRoute.favorites:
      return 'Favorites';
    case MainRoute.about:
      return 'About';
  }
}

Widget getRouteView(MainRoute route) {
  switch (route) {
    case MainRoute.explore:
      return const ExploreViewCreator();
    case MainRoute.favorites:
      return const FavoritesView();
    case MainRoute.about:
      return const AboutView();
  }
}

class MainRouteConductor extends Conductor {
  factory MainRouteConductor.fromContext(BuildContext context) {
    return MainRouteConductor();
  }

  final route = ValueNotifier<MainRoute>(MainRoute.explore);

  MainRouteConductor();

  void setRoute(int index) {
    route.value = MainRoute.values[index];
  }

  @override
  void dispose() {
    route.dispose();
  }
}

class AppContentViewCreator extends StatelessWidget {
  const AppContentViewCreator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ConductorCreator(
      create: MainRouteConductor.fromContext,
      child: ConductorConsumer<MainRouteConductor>(
        builder: (context, conductor) {
          return AppContentView(
            conductor: conductor,
          );
        },
      ),
    );
  }
}

class AppContentView extends StatelessWidget {
  final MainRouteConductor conductor;

  const AppContentView({
    super.key,
    required this.conductor,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: conductor.route,
      builder: (context, route, _) {
        return Scaffold(
          // extendBodyBehindAppBar: true, // TODO
          appBar: AppTopBarView(
            context,
            title: getRouteTitle(route),
            actions: const [
              ThemeModeToggleButton(),
              // TODO add padding to the left
            ],
          ),
          // TODO
          // body: BackgroundWidget(
          //   colors: defaultBackgroundColors,
          //   child: _getBody(route),
          // ),
          body: getRouteView(route),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: route.index,
            onTap: conductor.setRoute,
            items: [
              BottomNavigationBarItem(
                label: getRouteTitle(MainRoute.explore),
                icon: const Icon(LucideIcons.compass),
              ),
              BottomNavigationBarItem(
                label: getRouteTitle(MainRoute.favorites),
                icon: const Icon(LucideIcons.star),
              ),
              BottomNavigationBarItem(
                label: getRouteTitle(MainRoute.about),
                icon: const Icon(LucideIcons.info),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ThemeModeToggleButton extends StatelessWidget {
  const ThemeModeToggleButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ConductorConsumer<PreferencesConductor>(
      builder: (context, preferencesConductor) {
        return IconButton(
          onPressed: () {
            preferencesConductor.toggleThemeMode();
          },
          tooltip: 'Toggle light/dark theme',
          icon: preferencesConductor.themeMode.value == ThemeMode.light //
              ? const Icon(LucideIcons.moon)
              : const Icon(LucideIcons.sun),
        );
      },
    );
  }
}
