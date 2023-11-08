import 'package:url_launcher/url_launcher.dart';

Future<void> openUrl(String url) async {
  final uri = Uri.tryParse(url);
  if (uri == null) return;

  final canOpenUrl = await canLaunchUrl(uri);
  if (!canOpenUrl) return;

  await launchUrl(uri);
}

String httpToHttps(String url) {
  return url.replaceFirst('http://', 'https://');
}
