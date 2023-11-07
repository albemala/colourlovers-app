import 'package:colourlovers_app/blocs/preferences.dart';
import 'package:colourlovers_app/views/about.dart';
import 'package:colourlovers_app/views/explore.dart';
import 'package:colourlovers_app/views/favorites.dart';
import 'package:colourlovers_app/widgets/app-top-bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      return const ExploreViewBuilder();
    case MainRoute.favorites:
      return const FavoritesView();
    case MainRoute.about:
      return const AboutView();
  }
}

class MainRouteBloc extends Cubit<MainRoute> {
  factory MainRouteBloc.fromContext(BuildContext context) {
    return MainRouteBloc();
  }

  MainRouteBloc() : super(MainRoute.explore);

  void setRoute(int index) {
    emit(
      MainRoute.values[index],
    );
  }
}

class AppContentViewBuilder extends StatelessWidget {
  const AppContentViewBuilder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: MainRouteBloc.fromContext,
      child: BlocBuilder<MainRouteBloc, MainRoute>(
        builder: (context, route) {
          return AppContentView(
            route: route,
          );
        },
      ),
    );
  }
}

class AppContentView extends StatelessWidget {
  final MainRoute route;

  const AppContentView({
    super.key,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
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
        onTap: (index) {
          context.read<MainRouteBloc>().setRoute(index);
        },
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
  }
}

class ThemeModeToggleButton extends StatelessWidget {
  const ThemeModeToggleButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PreferencesBloc, PreferencesBlocModel>(
      builder: (context, preferences) {
        return IconButton(
          onPressed: () {
            context.read<PreferencesBloc>().toggleThemeMode();
          },
          tooltip: 'Toggle light/dark theme',
          icon: preferences.themeMode == ThemeMode.light //
              ? const Icon(LucideIcons.moon)
              : const Icon(LucideIcons.sun),
        );
      },
    );
  }
}
