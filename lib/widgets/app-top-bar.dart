import 'package:colourlovers_app/widgets/skewed-container.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTopBarView extends AppBar {
  final String titleText;
  final List<Widget>? actionWidgets;

  AppTopBarView(
    BuildContext context, {
    super.key,
    required this.titleText,
    this.actionWidgets = const [],
  }) : super(
          centerTitle: true,
          title: SkewedContainerView(
            padding: const EdgeInsets.fromLTRB(16, 8, 21, 8),
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Text(
              titleText.toUpperCase(),
              style: GoogleFonts.archivoNarrow(
                textStyle: Theme.of(context).textTheme.bodyLarge,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.6,
              ),
            ),
          ),
          actions: actionWidgets,
        );
}
