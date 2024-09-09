import 'package:colourlovers_app/app-content/view.dart';
import 'package:colourlovers_app/app/defines.dart';
import 'package:colourlovers_app/app/theme.dart';
import 'package:colourlovers_app/app/view-controller.dart';
import 'package:colourlovers_app/app/view-state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppViewCreator extends StatelessWidget {
  const AppViewCreator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppViewController>(
      create: (context) {
        return AppViewController.fromContext(context);
      },
      child: BlocBuilder<AppViewController, AppViewState>(
        builder: (context, state) {
          return AppView(
            controller: context.read<AppViewController>(),
            state: state,
          );
        },
      ),
    );
  }
}

class AppView extends StatelessWidget {
  final AppViewController controller;
  final AppViewState state;

  const AppView({
    required this.controller,
    required this.state,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
/* TODO
        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(
            statusBarBrightness: themeMode == ThemeMode.dark
                ? Brightness.dark
                : Brightness.light,
          ),
        );
*/

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appName,
      theme: getLightTheme(),
      darkTheme: getDarkTheme(),
      themeMode: state.themeMode,
      home: const AppContentViewCreator(),
    );
  }
}
