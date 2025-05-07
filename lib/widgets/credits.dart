import 'package:colourlovers_app/urls/defines.dart';
import 'package:colourlovers_app/urls/functions.dart';
import 'package:colourlovers_app/widgets/link.dart';
import 'package:flutter/material.dart';

class CreditsView extends StatelessWidget {
  final String itemName;
  final String itemUrl;

  const CreditsView({
    super.key,
    required this.itemName,
    required this.itemUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 16,
      children: [
        LinkView(
          text: 'This $itemName on COLOURlovers.com',
          onTap: () {
            openUrl(itemUrl);
          },
        ),
        LinkView(
          text: 'Licensed under Attribution-Noncommercial-Share Alike',
          onTap: () {
            openUrl(creativeCommonsUrl);
          },
        ),
      ],
    );
  }
}
