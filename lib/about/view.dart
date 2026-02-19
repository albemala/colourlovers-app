import 'package:colourlovers_app/about/view-controller.dart';
import 'package:colourlovers_app/about/view-state.dart';
import 'package:colourlovers_app/app/defines.dart';
import 'package:colourlovers_app/share.dart';
import 'package:colourlovers_app/widgets/app-bar.dart';
import 'package:colourlovers_app/widgets/background/view.dart';
import 'package:colourlovers_app/widgets/link.dart';
import 'package:colourlovers_app/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AboutViewCreator extends StatelessWidget {
  const AboutViewCreator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AboutViewController>(
      create: (context) {
        return AboutViewController.fromContext(context);
      },
      child: BlocBuilder<AboutViewController, AboutViewState>(
        builder: (context, state) {
          return AboutView(
            controller: context.read<AboutViewController>(),
            state: state,
          );
        },
      ),
    );
  }
}

class AboutView extends StatelessWidget {
  final AboutViewController controller;
  final AboutViewState state;

  const AboutView({required this.controller, required this.state, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarView(context, title: 'About'),
      body: BackgroundView(
        blobs: state.backgroundBlobs.toList(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 32,
            children: [
              Row(
                spacing: 16,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      'assets/app-icon/icon.png',
                      width: 64,
                      height: 64,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // spacing: 0,
                    children: [
                      const H1TextView(appName),
                      H2TextView(state.appVersion),
                    ],
                  ),
                ],
              ),
              Row(
                spacing: 16,
                children: [
                  Builder(
                    builder: (context) {
                      return OutlinedButton(
                        onPressed: () =>
                            controller.shareApp(getSharePosition(context)),
                        child: const Text('Share $appName'),
                      );
                    },
                  ),
                  OutlinedButton(
                    onPressed: controller.rateApp,
                    child: const Text('Rate $appName'),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 16,
                children: [
                  const H2TextView('Help & Support'),
                  OutlinedButton(
                    onPressed: controller.openEmail,
                    child: const Text('Contact us'),
                  ),
                  OutlinedButton(
                    onPressed: controller.openWebsite,
                    child: const Text('Website'),
                  ),
                  OutlinedButton(
                    onPressed: controller.openTwitter,
                    child: const Text('Twitter'),
                  ),
                ],
              ),
              FilledButton(
                onPressed: controller.openOtherProjects,
                child: const Text('Other useful apps'),
              ),
              LinkView(
                onTap: controller.openColourLoversLicense,
                text: 'COLOURlovers License',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
