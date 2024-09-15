import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/share-pattern/view-controller.dart';
import 'package:colourlovers_app/share-pattern/view-state.dart';
import 'package:colourlovers_app/widgets/app-bar.dart';
import 'package:colourlovers_app/widgets/background/view.dart';
import 'package:colourlovers_app/widgets/items/pattern.dart';
import 'package:colourlovers_app/widgets/link.dart';
import 'package:colourlovers_app/widgets/text.dart';
import 'package:flextras/flextras.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SharePatternViewCreator extends StatelessWidget {
  final ColourloversPattern pattern;

  const SharePatternViewCreator({
    super.key,
    required this.pattern,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return SharePatternViewController.fromContext(
          context,
          pattern: pattern,
        );
      },
      child: BlocBuilder<SharePatternViewController, SharePatternViewState>(
        builder: (context, state) {
          return SharePatternView(
            state: state,
            controller: context.read<SharePatternViewController>(),
          );
        },
      ),
    );
  }
}

class SharePatternView extends StatelessWidget {
  final SharePatternViewState state;
  final SharePatternViewController controller;

  const SharePatternView({
    super.key,
    required this.state,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarView(
        context,
        title: 'Share Pattern',
      ),
      body: BackgroundView(
        blobs: state.backgroundBlobs.toList(),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 96,
                child: PatternView(
                  imageUrl: state.imageUrl,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                child: SeparatedColumn(
                  separatorBuilder: () => const SizedBox(height: 32),
                  children: [
                    SeparatedColumn(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      separatorBuilder: () => const SizedBox(height: 16),
                      children: [
                        const H2TextView('Values'),
                        SeparatedColumn(
                          separatorBuilder: () => const SizedBox(height: 8),
                          children: state.colors.map((color) {
                            return SeparatedRow(
                              separatorBuilder: () => const SizedBox(width: 8),
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
                    SeparatedColumn(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      separatorBuilder: () => const SizedBox(height: 16),
                      children: [
                        const H2TextView('Image'),
                        SeparatedRow(
                          separatorBuilder: () => const SizedBox(width: 8),
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
                    SeparatedColumn(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      separatorBuilder: () => const SizedBox(height: 16),
                      children: [
                        const H2TextView('Template'),
                        LinkView(
                          text: 'This pattern template on COLOURlovers.com',
                          onTap: controller.shareTemplate,
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
