import 'package:colourlovers_app/widgets/skewed-container.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppBarView extends AppBar {
  AppBarView(
    BuildContext context, {
    super.key,
    required String title,
    super.actions,
  }) : super(
         centerTitle: true,
         title: SkewedContainerView(
           padding: const EdgeInsets.fromLTRB(16, 8, 21, 8),
           color: Theme.of(context).colorScheme.primaryContainer,
           child: Text(
             title.toUpperCase(),
             style: GoogleFonts.archivoNarrow(
               textStyle: Theme.of(context).textTheme.bodyLarge,
               fontWeight: FontWeight.w600,
               letterSpacing: 0.6,
             ),
           ),
         ),
       );
}
