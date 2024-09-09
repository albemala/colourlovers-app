import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/share-palette/view-controller.dart';
import 'package:colourlovers_app/share-palette/view-state.dart';
import 'package:colourlovers_app/widgets/app-top-bar.dart';
import 'package:colourlovers_app/widgets/h1-text.dart';
import 'package:colourlovers_app/widgets/h2-text.dart';
import 'package:colourlovers_app/widgets/items.dart';
import 'package:flextras/flextras.dart';
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
      appBar: AppTopBarView(
        context,
        title: 'Share Palette',
      ),
      body: SingleChildScrollView(
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
              child: SeparatedColumn(
                separatorBuilder: () {
                  return const SizedBox(height: 32);
                },
                children: [
                  SeparatedColumn(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    separatorBuilder: () {
                      return const SizedBox(height: 16);
                    },
                    children: [
                      const H2TextView('Values'),
                      SeparatedColumn(
                        separatorBuilder: () {
                          return const SizedBox(height: 8);
                        },
                        children: state.colors.map((color) {
                          return SeparatedRow(
                            separatorBuilder: () {
                              return const SizedBox(width: 8);
                            },
                            children: [
                              SizedBox(
                                width: 120,
                                child: H1TextView('#$color'),
                              ),
                              TextButton(
                                onPressed: () {
                                  controller.copyColorToClipboard(
                                      context, color);
                                },
                                child: const Text('Copy'),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  SeparatedColumn(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    separatorBuilder: () {
                      return const SizedBox(height: 16);
                    },
                    children: [
                      const H2TextView('Image'),
                      SeparatedRow(
                        separatorBuilder: () {
                          return const SizedBox(width: 8);
                        },
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
    );
  }
}
