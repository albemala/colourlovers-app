import 'package:colourlovers_app/widgets/skewed-container.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppBarWidget extends AppBar {
  final String titleText;
  final List<Widget>? actionWidgets;

  AppBarWidget(
    BuildContext context, {
    Key? key,
    required this.titleText,
    this.actionWidgets = const [],
  }) : super(
          key: key,
          centerTitle: true,
          title: SkewedContainerWidget(
            padding: const EdgeInsets.fromLTRB(16, 8, 21, 8),
            color: Theme.of(context).colorScheme.primaryVariant,
            child: Text(
              titleText.toUpperCase(),
              style: GoogleFonts.archivoNarrow(
                textStyle: Theme.of(context).textTheme.bodyText1,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.6,
              ),
            ),
          ),
          actions: actionWidgets,
        );
}
