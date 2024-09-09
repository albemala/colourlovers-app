import 'package:colourlovers_api/colourlovers_api.dart';
import 'package:colourlovers_app/share-color/view-controller.dart';
import 'package:colourlovers_app/share-color/view-state.dart';
import 'package:colourlovers_app/widgets/app-top-bar.dart';
import 'package:colourlovers_app/widgets/h1-text.dart';
import 'package:colourlovers_app/widgets/h2-text.dart';
import 'package:colourlovers_app/widgets/items.dart';
import 'package:flextras/flextras.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShareColorViewCreator extends StatelessWidget {
  final ColourloversColor color;

  const ShareColorViewCreator({
    super.key,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return ShareColorViewController.fromContext(
          context,
          color: color,
        );
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
      appBar: AppTopBarView(
        context,
        title: 'Share Color',
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 96,
              child: ColorView(hex: state.hex),
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
                      SeparatedRow(
                        separatorBuilder: () {
                          return const SizedBox(width: 8);
                        },
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
