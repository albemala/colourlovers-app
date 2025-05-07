import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/share-palette/view-controller.dart';
import 'package:colourlovers_app/share-palette/view-state.dart';
import 'package:colourlovers_app/widgets/app-bar.dart';
import 'package:colourlovers_app/widgets/background/view.dart';
import 'package:colourlovers_app/widgets/items/palette.dart';
import 'package:colourlovers_app/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SharePaletteViewCreator extends StatelessWidget {
  final ColourloversPalette palette;

  const SharePaletteViewCreator({
    super.key,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return SharePaletteViewController.fromContext(
          context,
          palette: palette,
        );
      },
      child: BlocBuilder<SharePaletteViewController, SharePaletteViewState>(
        builder: (context, state) {
          return SharePaletteView(
            state: state,
            controller: context.read<SharePaletteViewController>(),
          );
        },
      ),
    );
  }
}

class SharePaletteView extends StatelessWidget {
  final SharePaletteViewState state;
  final SharePaletteViewController controller;

  const SharePaletteView({
    super.key,
    required this.state,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarView(
        context,
        title: 'Share Palette',
      ),
      body: BackgroundView(
        blobs: state.backgroundBlobs.toList(),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 96,
                child: PaletteView(
                  hexs: state.colors.toList(),
                  widths: state.colorWidths.toList(),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                child: Column(
                  spacing: 32,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      spacing: 16,
                      children: [
                        const H2TextView('Values'),
                        Column(
                          spacing: 8,
                          children: state.colors.map((color) {
                            return Row(
                              spacing: 8,
                              children: [
                                SizedBox(
                                  width: 120,
                                  child: H1TextView('#$color'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    controller.copyColorToClipboard(
                                      context,
                                      color,
                                    );
                                  },
                                  child: const Text('Copy'),
                                ),
                              ],
                            );
                          }).toList(),
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
                              child: Image.network(state.imageUrl),
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
