import 'package:package_info_plus/package_info_plus.dart';

Future<String> getAppVersion() async {
  final packageInfo = await PackageInfo.fromPlatform();
  final buildNumber = packageInfo.buildNumber;
  return '${packageInfo.version}.${buildNumber.isEmpty ? '0' : buildNumber}';
}
