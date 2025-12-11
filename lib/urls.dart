import 'dart:io';

import 'package:url_launcher/url_launcher.dart';

const supportEmailUrl = 'albemala@gmail.com';

// const websiteUrl = 'https://luv.albemala.me/';
const repositoryUrl = 'https://github.com/albemala/colourlovers-app';
const twitterUrl = 'https://twitter.com/albemala';

const colourLoversUrl = 'https://www.colourlovers.com';
const colourLoversLicenseUrl = '$colourLoversUrl/api';
const creativeCommonsUrl = 'https://creativecommons.org/licenses/by-nc-sa/3.0/';

String get websiteUrl => switch (Platform.operatingSystem) {
  'ios' ||
  'macos' => 'https://apps.apple.com/us/app/color-picker-luv/id1438312561',
  'android' =>
    'https://play.google.com/store/apps/details?id=me.albemala.luv&hl=en',
  _ => 'https://github.com/albemala/colourlovers-app',
};

String get otherProjectsUrl {
  switch (Platform.operatingSystem) {
    case 'ios':
    case 'macos':
      return 'https://apps.apple.com/us/developer/alberto-malagoli/id965971566';
    default:
      return 'https://projects.albemala.me/?ref=luv-app';
  }
}

Future<void> openUrl(String url) async {
  final uri = Uri.tryParse(url);
  if (uri == null) return;
  await openUri(uri);
}

Future<void> openUri(Uri uri) async {
  final canOpenUrl = await canLaunchUrl(uri);
  if (!canOpenUrl) return;
  await launchUrl(uri);
}

String httpToHttps(String url) {
  return url.replaceFirst('http://', 'https://');
}
