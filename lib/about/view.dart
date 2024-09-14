import 'package:colourlovers_app/about/view-controller.dart';
import 'package:colourlovers_app/about/view-state.dart';
import 'package:colourlovers_app/app/defines.dart';
import 'package:colourlovers_app/share.dart';
import 'package:colourlovers_app/widgets/app-bar.dart';
import 'package:colourlovers_app/widgets/link.dart';
import 'package:colourlovers_app/widgets/text.dart';
import 'package:flextras/flextras.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AboutViewCreator extends StatelessWidget {
  const AboutViewCreator({
    super.key,
  });

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

  const AboutView({
    required this.controller,
    required this.state,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarView(
        context,
        title: 'About',
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        child: SeparatedColumn(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          separatorBuilder: () => const SizedBox(height: 32),
          children: [
            SeparatedColumn(
              crossAxisAlignment: CrossAxisAlignment.start,
              separatorBuilder: () => const SizedBox(height: 0),
              children: [
                const H1TextView(appName),
                H2TextView(state.appVersion),
              ],
            ),
            SeparatedRow(
              separatorBuilder: () => const SizedBox(width: 16),
              children: [
                Builder(
                  builder: (context) {
                    return OutlinedButton(
                      onPressed: () => controller.shareApp(
                        getSharePosition(context),
                      ),
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
            SeparatedColumn(
              crossAxisAlignment: CrossAxisAlignment.start,
              separatorBuilder: () => const SizedBox(height: 16),
              children: [
                const H1TextView('Help & Support'),
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
    );
  }
}
