import 'dart:io';

// const websiteUrl = 'https://luv.albemala.me/';
const repositoryUrl = 'https://github.com/albemala/colourlovers-app';

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

String httpToHttps(String url) {
  return url.replaceFirst('http://', 'https://');
}
