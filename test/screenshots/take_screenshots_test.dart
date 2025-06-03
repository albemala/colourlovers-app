import 'dart:io';
import 'dart:ui';

import 'package:colourlovers_app/preferences/data-controller.dart';
import 'package:colourlovers_app/theme/data.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_screenshot/golden_screenshot.dart';
import 'package:google_fonts/google_fonts.dart';

import 'data.dart';
import 'functions.dart';
import 'mocks.dart';

Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();

  // define what fonts to load
  // this is very important, otherwise the fonts will not be loaded properly
  await GoogleFonts.pendingFonts([
    // GoogleFonts.zenMaruGothic(), // Japanese
    // GoogleFonts.notoSansJp(), // Japanese
    // GoogleFonts.notoSansKr(), // Korean
    // GoogleFonts.notoSansSc(), // Simplified Chinese
    // GoogleFonts.maShanZheng(), // Simplified Chinese
    GoogleFonts.archivo(),
    GoogleFonts.archivoNarrow(),
  ]);

  final tempDir = Directory('temp');
  if (tempDir.existsSync()) {
    tempDir.deleteSync(recursive: true);
  }

  final devices = [
    GoldenScreenshotDevices.macbook,
    GoldenScreenshotDevices.newerIpad,
    GoldenScreenshotDevices.newerIphone,
  ];

  // define what locales to use
  final locales = [
    // const Locale('de'), // German
    const Locale('en'), // English
    // const Locale('es'), // Spanish
    // const Locale('fr'), // French
    // const Locale('it'), // Italian
    // const Locale('ja'), // Japanese
    // const Locale('ko'), // Korean
    // const Locale('zh'), // Chinese
  ];

  final screenshotData = await createScreenshotData();

  for (final device in devices) {
    for (final locale in locales) {
      for (final data in screenshotData) {
        testGoldens(
          '${locale.languageCode} - ${device.name} - ${data.fileName}',
          (tester) async {
            await takeDeviceScreenshot(
              tester: tester,
              device: device,
              screenshotData: data,
              locale: locale,
            );
          },
        );
      }
    }
  }
}

Future<void> takeDeviceScreenshot({
  required WidgetTester tester,
  required GoldenScreenshotDevices device,
  required ScreenshotData screenshotData,
  required Locale locale,
}) async {
  final theme = getDarkTheme(FlexScheme.purpleM3);

  final child = MultiBlocProvider(
    providers: [
      BlocProvider<PreferencesDataController>.value(
        value: MockPreferencesDataController(),
      ),
    ],
    child: screenshotData.view,
  );

  final goldenFileName = screenshotData.fileName;

  await takeScreenshot(
    tester: tester,
    device: device,
    theme: theme,
    child: child,
    goldenFileName: goldenFileName,
    locale: locale,
  );
}
