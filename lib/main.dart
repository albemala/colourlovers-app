import 'package:colourlovers_app/conductors/preferences-conductor.dart';
import 'package:colourlovers_app/conductors/routing-conductor.dart';
import 'package:colourlovers_app/views/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_state_management/flutter_state_management.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // GoogleFonts.config.allowRuntimeFetching = false; // TODO restore

  runApp(
    const ConductorCreator(
      create: RoutingConductor.fromContext,
      child: ConductorCreator(
        create: PreferencesConductor.fromContext,
        child: AppView(),
      ),
    ),
  );
}
