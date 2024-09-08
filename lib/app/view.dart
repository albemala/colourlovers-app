import 'package:colourlovers_app/app-content/view.dart';
import 'package:colourlovers_app/app/defines.dart';
import 'package:colourlovers_app/app/theme.dart';
import 'package:colourlovers_app/preferences/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppView extends StatelessWidget {
  const AppView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PreferencesBloc, PreferencesBlocModel>(
      builder: (context, preferences) {
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
          themeMode: preferences.themeMode,
          home: const AppContentViewBuilder(),
        );
      },
    );
  }
}
