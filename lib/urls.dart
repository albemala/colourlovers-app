import 'dart:io';

import 'package:url_launcher/url_launcher.dart';

const supportEmailUrl = 'albemala@gmail.com';

const websiteUrl = 'https://luv.albemala.me/';
const repositoryUrl = 'https://github.com/albemala/colourlovers-app';
const twitterUrl = 'https://twitter.com/albemala';

const colourLoversUrl = 'https://www.colourlovers.com';
const colourLoversLicenseUrl = '$colourLoversUrl/api';
const creativeCommonsUrl = 'https://creativecommons.org/licenses/by-nc-sa/3.0/';

String get otherProjectsUrl {
  switch (Platform.operatingSystem) {
    case 'ios':
    case 'macos':
      return 'https://apps.apple.com/us/developer/alberto-malagoli/id965971566';
    default:
      return 'https://projects.albemala.me/?ref=luv-app';
  }
}

const hexeeWebsiteUrl = 'https://hexee.app/?ref=luv-app';
const wmapWebsiteUrl = 'https://wmap.albemala.me/?ref=luv-app';
const iroIroWebsiteUrl = 'https://iro-iro.albemala.me/?ref=luv-app';

String get ejimoWebsiteUrl {
  switch (Platform.operatingSystem) {
    case 'ios':
    case 'macos':
      return 'https://apps.apple.com/us/app/ejimo/id1598944603';
    case 'android':
      return 'https://play.google.com/store/apps/details?id=me.albemala.ejimo';
    default:
      return 'https://ejimo-app.web.app'; // Default for web and other platforms
  }
}

String get upcWebsiteUrl {
  switch (Platform.operatingSystem) {
    case 'ios':
    case 'macos':
      return 'https://apps.apple.com/us/app/universal-palette-converter/id6480113031';
    case 'android':
      return 'https://play.google.com/store/apps/details?id=me.albemala.paletteconverter';
    default:
      return '';
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
