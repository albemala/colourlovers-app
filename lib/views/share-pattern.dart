import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/utils/clipboard.dart';
import 'package:colourlovers_app/utils/url.dart';
import 'package:colourlovers_app/widgets/app-bar.dart';
import 'package:colourlovers_app/widgets/background.dart';
import 'package:colourlovers_app/widgets/h1-text.dart';
import 'package:colourlovers_app/widgets/h2-text.dart';
import 'package:colourlovers_app/widgets/pattern.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SharePatternView extends HookConsumerWidget {
  final ClPattern? pattern;

  const SharePatternView({
    Key? key,
    required this.pattern,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBarWidget(
        context,
        titleText: 'Share Pattern',
      ),
      body: BackgroundWidget(
        colors: pattern?.colors?.map(HexColor.new).toList() ?? [],
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 96,
                child: PatternWidget(imageUrl: pattern?.imageUrl ?? ''),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const H2TextWidget('Values'),
                    const SizedBox(height: 16),
                    ListView.separated(
                      shrinkWrap: true,
                      itemCount: pattern?.colors?.length ?? 0,
                      itemBuilder: (context, index) {
                        final color = pattern?.colors?.elementAt(index) ?? '';
                        return Row(
                          children: [
                            SizedBox(
                              width: 120,
                              child: H1TextWidget('#$color'),
                            ),
                            const SizedBox(width: 8),
                            TextButton(
                              onPressed: () {
                                copyToClipboard(context, color);
                              },
                              child: const Text('Copy'),
                            ),
                          ],
                        );
                      },
                      separatorBuilder: (context, index) => const SizedBox(height: 8),
                    ),
                    const SizedBox(height: 32),
                    const H2TextWidget('Image'),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Flexible(
                          child: Image.network(pattern?.imageUrl ?? ''),
                        ),
                        const SizedBox(width: 8),
                        TextButton(
                          onPressed: () {
                            openUrl(pattern?.imageUrl ?? '');
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
