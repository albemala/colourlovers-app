import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/share/color/view-controller.dart';
import 'package:colourlovers_app/share/color/view-state.dart';
import 'package:colourlovers_app/widgets/app-bar.dart';
import 'package:colourlovers_app/widgets/background/view.dart';
import 'package:colourlovers_app/widgets/items/color.dart';
import 'package:colourlovers_app/widgets/text.dart';
import 'package:colourlovers_app/widgets/url_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShareColorViewCreator extends StatelessWidget {
  final ColourloversColor color;

  const ShareColorViewCreator({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return ShareColorViewController.fromContext(context, color: color);
      },
      child: BlocBuilder<ShareColorViewController, ShareColorViewState>(
        builder: (context, state) {
          return ShareColorView(
            state: state,
            controller: context.read<ShareColorViewController>(),
          );
        },
      ),
    );
  }
}

class ShareColorView extends StatelessWidget {
  final ShareColorViewState state;
  final ShareColorViewController controller;

  const ShareColorView({
    super.key,
    required this.state,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarView(context, title: 'Share Color'),
      body: BackgroundView(
        blobs: state.backgroundBlobs.toList(),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 128, child: ColorView(hex: state.hex)),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 32,
                ),
                child: Column(
                  spacing: 32,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      spacing: 16,
                      children: [
                        const H2TextView('Values'),
                        Row(
                          spacing: 8,
                          children: [
                            SizedBox(
                              // width: 120,
                              child: H1TextView('#${state.hex}'),
                            ),
                            TextButton(
                              onPressed: () {
                                controller.copyHexToClipboard(context);
                              },
                              child: const Text('Copy'),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      spacing: 16,
                      children: [
                        const H2TextView('Image'),
                        Row(
                          spacing: 8,
                          children: [
                            Flexible(
                              child: UrlImageView(imageUrl: state.imageUrl),
                            ),
                            TextButton(
                              onPressed: controller.shareImage,
                              child: const Text('Share'),
                            ),
                          ],
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
