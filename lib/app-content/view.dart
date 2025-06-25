import 'package:colourlovers_app/about/view.dart';
import 'package:colourlovers_app/app-content/view-controller.dart';
import 'package:colourlovers_app/app-content/view-state.dart';
import 'package:colourlovers_app/explore/view.dart';
import 'package:colourlovers_app/favorites/view.dart';
import 'package:colourlovers_app/preferences/view.dart';
import 'package:colourlovers_app/test/view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';

const exploreView = NavigatorView(child: ExploreViewCreator());
const favoritesView = NavigatorView(child: FavoritesViewCreator());
const preferencesView = NavigatorView(child: PreferencesViewCreator());
const aboutView = NavigatorView(child: AboutViewCreator());
const testView = NavigatorView(child: TestViewCreator());

const exploreDestination = NavigationDestination(
  label: 'Explore',
  icon: Icon(LucideIcons.compass),
);
const favoritesDestination = NavigationDestination(
  label: 'Favorites',
  icon: Icon(LucideIcons.bookmark),
);
const preferencesDestination = NavigationDestination(
  label: 'Preferences',
  icon: Icon(LucideIcons.settings),
);
const aboutDestination = NavigationDestination(
  label: 'About',
  icon: Icon(LucideIcons.info),
);
const testDestination = NavigationDestination(
  label: 'Test',
  icon: Icon(LucideIcons.bug),
);

class AppContentViewCreator extends StatelessWidget {
  const AppContentViewCreator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppContentViewController>(
      create: (context) {
        return AppContentViewController.fromContext(context);
      },
      child: BlocBuilder<AppContentViewController, AppContentViewState>(
        builder: (context, state) {
          return AppContentView(
            controller: context.read<AppContentViewController>(),
            state: state,
          );
        },
      ),
    );
  }
}

class AppContentView extends StatelessWidget {
  final AppContentViewController controller;
  final AppContentViewState state;
  final List<Widget>? views;
  final List<NavigationDestination>? destinations;

  const AppContentView({
    super.key,
    required this.controller,
    required this.state,
    @visibleForTesting this.views,
    @visibleForTesting this.destinations,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: state.currentRoute.index,
        children:
            views ??
            <Widget>[
              exploreView,
              favoritesView,
              preferencesView,
              aboutView,
              if (kDebugMode) testView,
            ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: state.currentRoute.index,
        onDestinationSelected: controller.setCurrentRoute,
        destinations:
            destinations ??
            <NavigationDestination>[
              exploreDestination,
              favoritesDestination,
              preferencesDestination,
              aboutDestination,
              if (kDebugMode) testDestination,
            ],
      ),
    );
  }
}

class NavigatorView extends StatelessWidget {
  final Widget child;

  const NavigatorView({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Navigator(
        onGenerateRoute: (RouteSettings settings) {
          return MaterialPageRoute(builder: (BuildContext context) => child);
        },
      ),
    );
  }
}
