import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/utils/clipboard.dart';
import 'package:colourlovers_app/utils/url.dart';
import 'package:colourlovers_app/widgets/app-bar.dart';
import 'package:colourlovers_app/widgets/background.dart';
import 'package:colourlovers_app/widgets/color.dart';
import 'package:colourlovers_app/widgets/h1-text.dart';
import 'package:colourlovers_app/widgets/h2-text.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ShareColorView extends HookConsumerWidget {
  final ClColor? color;

  const ShareColorView({
    Key? key,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBarWidget(
        context,
        titleText: 'Share Color',
      ),
      body: BackgroundWidget(
        colors: [
          HexColor(color?.hex ?? ''),
        ],
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 96,
                child: ColorWidget(hex: color?.hex ?? ''),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const H2TextWidget('Values'),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        H1TextWidget('#${color?.hex ?? ''}'),
                        const SizedBox(width: 8),
                        TextButton(
                          onPressed: () {
                            copyToClipboard(context, color?.hex ?? '');
                          },
                          child: const Text('Copy'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    const H2TextWidget('Image'),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Flexible(
                          child: Image.network(color?.imageUrl ?? ''),
                        ),
                        const SizedBox(width: 8),
                        TextButton(
                          onPressed: () {
                            openUrl(color?.imageUrl ?? '');
                          },
                          child: const Text('Share'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
