import 'package:colourlovers_app/about/functions.dart';
import 'package:colourlovers_app/about/view-state.dart';
import 'package:colourlovers_app/app/defines.dart';
import 'package:colourlovers_app/feedback.dart';
import 'package:colourlovers_app/share.dart';
import 'package:colourlovers_app/urls/defines.dart';
import 'package:colourlovers_app/urls/functions.dart';
import 'package:colourlovers_app/widgets/background/functions.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_review/in_app_review.dart';

class AboutViewController extends Cubit<AboutViewState> {
  factory AboutViewController.fromContext(BuildContext context) {
    return AboutViewController();
  }

  AboutViewController() : super(defaultAboutViewState) {
    emit(
      state.copyWith(
        backgroundBlobs: generateBackgroundBlobs(getRandomPalette()).toIList(),
      ),
    );
    _init();
  }

  Future<void> _init() async {
    emit(state.copyWith(appVersion: await getAppVersion()));
  }

  Future<void> shareApp(Rect sharePosition) async {
    await shareText(
      position: sharePosition,
      text: '$appName ∙ $appDescription ∙ $websiteUrl',
    );
  }

  Future<void> rateApp() async {
    final inAppReview = InAppReview.instance;
    await inAppReview.openStoreListing(appStoreId: appleAppId);
  }

  Future<void> openEmail() async {
    await sendFeedback();
  }

  Future<void> openWebsite() async {
    await openUrl(websiteUrl);
  }

  Future<void> openOtherProjects() async {
    await openUrl(otherProjectsUrl);
  }

  Future<void> openTwitter() async {
    await openUrl(twitterUrl);
  }

  Future<void> openColourLoversLicense() async {
    await openUrl(colourLoversLicenseUrl);
  }
}
