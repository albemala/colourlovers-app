import 'package:colourlovers_app/about/view.dart';
import 'package:colourlovers_app/common/preferences/bloc.dart';
import 'package:colourlovers_app/explore/view.dart';
import 'package:colourlovers_app/favorites/view.dart';
import 'package:colourlovers_app/test/view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';

enum MainRoute {
  explore,
  favorites,
  about,
  test,
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
      // appBar: AppTopBarView(
      //   context,
      //   title: getRouteTitle(route),
      //   actions: const [
      //     ThemeModeToggleButton(),
      //     // TODO add padding to the left
      //   ],
      // ),
      // TODO
      // body: BackgroundWidget(
      //   colors: defaultBackgroundColors,
      //   child: _getBody(route),
      // ),
      body: IndexedStack(
        index: route.index,
        children: const [
          NavigatorView(child: ExploreViewBuilder()),
          NavigatorView(child: FavoritesView()),
          NavigatorView(child: AboutView()),
          if (kDebugMode) NavigatorView(child: TestViewBuilder()),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: route.index,
        onDestinationSelected: (index) {
          context.read<MainRouteBloc>().setRoute(index);
        },
        destinations: const [
          NavigationDestination(
            label: 'Explore',
            icon: Icon(LucideIcons.compass),
          ),
          NavigationDestination(
            label: 'Favorites',
            icon: Icon(LucideIcons.star),
          ),
          NavigationDestination(
            label: 'About',
            icon: Icon(LucideIcons.info),
          ),
          if (kDebugMode)
            NavigationDestination(
              label: 'Test',
              icon: Icon(LucideIcons.bug),
            ),
        ],
      ),
    );
  }
}

class NavigatorView extends StatelessWidget {
  final Widget child;

  const NavigatorView({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          builder: (BuildContext context) => child,
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
