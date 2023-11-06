import 'package:colourlovers_app/conductors/preferences.dart';
import 'package:colourlovers_app/conductors/routing.dart';
import 'package:colourlovers_app/defines/app.dart';
import 'package:colourlovers_app/defines/theme.dart';
import 'package:colourlovers_app/views/app-content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_state_management/flutter_state_management.dart';

class AppView extends StatelessWidget {
  const AppView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: context.getConductor<PreferencesConductor>().themeMode,
      builder: (context, themeMode, child) {
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
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: themeMode,
          home: child,
        );
      },
      child: RoutingView(
        routingStream: context.getConductor<RoutingConductor>().routingStream,
        child: const AppContentViewCreator(),
      ),
    );
  }
}
