import 'package:colourlovers_app/preferences/view-controller.dart';
import 'package:colourlovers_app/preferences/view-state.dart';
import 'package:colourlovers_app/widgets/app-bar.dart';
import 'package:colourlovers_app/widgets/background/view.dart';
import 'package:colourlovers_app/widgets/radio.dart';
import 'package:colourlovers_app/widgets/text.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PreferencesViewCreator extends StatelessWidget {
  const PreferencesViewCreator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PreferencesViewController>(
      create: (context) {
        return PreferencesViewController.fromContext(context);
      },
      child: BlocBuilder<PreferencesViewController, PreferencesViewState>(
        builder: (context, state) {
          return PreferencesView(
            controller: context.read<PreferencesViewController>(),
            state: state,
          );
        },
      ),
    );
  }
}

class PreferencesView extends StatelessWidget {
  final PreferencesViewController controller;
  final PreferencesViewState state;

  const PreferencesView({
    super.key,
    required this.controller,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final schemes = FlexScheme.values.toList()
      // Remove custom one
      ..removeLast();
    return Scaffold(
      appBar: AppBarView(context, title: 'Preferences'),
      body: BackgroundView(
        blobs: state.backgroundBlobs.toList(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 32,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  const H1TextView('App theme'),
                  RadioView<ThemeMode>(
                    options: const [
                      (value: ThemeMode.dark, label: 'Dark'),
                      (value: ThemeMode.light, label: 'Light'),
                    ],
                    selectedValue: state.themeMode,
                    onChanged: controller.setThemeMode,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  const H1TextView('Theme colors'),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 80,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          // childAspectRatio: 1,
                        ),
                    itemCount: schemes.length,
                    itemBuilder: (context, index) {
                      final scheme = schemes[index];
                      final schemeData = FlexColor.schemesWithCustom[scheme];
                      if (schemeData == null) return Container();

                      final schemeColors = state.themeMode == ThemeMode.dark
                          ? FlexColorScheme.dark(scheme: scheme)
                          : FlexColorScheme.light(scheme: scheme);

                      return _ThemeTileView(
                        colors: schemeColors,
                        isSelected: state.flexScheme == scheme,
                        onPressed: () {
                          controller.setFlexScheme(scheme);
                        },
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ThemeTileView extends StatelessWidget {
  final FlexColorScheme colors;
  final bool isSelected;
  final void Function() onPressed;

  const _ThemeTileView({
    required this.colors,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = colors.colorScheme;
    final tileColors = [
      colorScheme?.primary ?? Colors.transparent,
      colorScheme?.inversePrimary ?? Colors.transparent,
      colorScheme?.secondary ?? Colors.transparent,
      colorScheme?.tertiary ?? Colors.transparent,
    ];
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          width: 2,
          color: isSelected
              ? Theme.of(context).colorScheme.secondary
              : Colors.transparent,
        ),
      ),
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CustomPaint(
              size: const Size(48, 48),
              painter: _ThemeTilePainter(colors: tileColors),
            ),
          ),
        ),
      ),
    );
  }
}

class _ThemeTilePainter extends CustomPainter {
  final List<Color> colors;

  _ThemeTilePainter({required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final tileWidth = size.width / 2;
    final tileHeight = size.height / 2;
    final paint = Paint()..style = PaintingStyle.fill;

    for (var i = 0; i < 4; i++) {
      paint.color = colors[i];
      canvas.drawRect(
        Rect.fromLTWH(
          (i % 2) * tileWidth,
          (i ~/ 2) * tileHeight,
          tileWidth,
          tileHeight,
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ThemeTilePainter oldDelegate) {
    return !listEquals(oldDelegate.colors, colors);
  }
}
