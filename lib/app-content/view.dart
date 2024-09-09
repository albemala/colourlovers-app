import 'package:colourlovers_app/about/view.dart';
import 'package:colourlovers_app/app-content/view-controller.dart';
import 'package:colourlovers_app/app-content/view-state.dart';
import 'package:colourlovers_app/explore/view.dart';
import 'package:colourlovers_app/favorites/view.dart';
import 'package:colourlovers_app/test/view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';

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

  const AppContentView({
    super.key,
    required this.controller,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        index: state.currentRoute.index,
        children: const [
          NavigatorView(child: ExploreViewCreator()),
          NavigatorView(child: FavoritesView()),
          NavigatorView(child: AboutView()),
          if (kDebugMode) NavigatorView(child: TestViewCreator()),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: state.currentRoute.index,
        onDestinationSelected: controller.setCurrentRoute,
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
