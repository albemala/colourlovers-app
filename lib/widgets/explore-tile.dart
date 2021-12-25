import 'package:colourlovers_app/widgets/skewed-container.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ExploreTileWidget extends StatelessWidget {
  final void Function() onTap;
  final String title;
  final Widget child;

  const ExploreTileWidget({
    Key? key,
    required this.onTap,
    required this.title,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 96,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          SizedBox(
            width: double.maxFinite,
            child: Material(
              type: MaterialType.transparency,
              elevation: 12,
              child: ClipRRect(
                child: child,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: onTap,
            ),
          ),
          Positioned(
            top: 8,
            left: -4,
            child: SkewedContainerWidget(
              padding: const EdgeInsets.fromLTRB(16, 8, 21, 8),
              color: Colors.white,
              elevation: 4,
              child: Text(
                title.toUpperCase(),
                style: GoogleFonts.archivoNarrow(
                  textStyle: Theme.of(context).textTheme.bodyText1,
                  color: Theme.of(context).backgroundColor,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.6,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
