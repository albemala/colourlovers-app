import 'package:colourlovers_app/app/view.dart';
import 'package:colourlovers_app/common/preferences/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // GoogleFonts.config.allowRuntimeFetching = false; // TODO restore

  runApp(
    const BlocProvider(
      create: PreferencesBloc.fromContext,
      child: AppView(),
    ),
  );
}
