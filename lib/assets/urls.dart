import 'package:url_launcher/url_launcher.dart';

class URLs {
  static const website = 'https://luv.albemala.me/';

  static const colourLoversLicense = 'https://www.colourlovers.com/api';
  static const creativeCommons = 'https://creativecommons.org/licenses/by-nc-sa/3.0/';

  static const twitterProfile = 'https://twitter.com/albemala';
  static const supportEmail = "albemala@gmail.com";

  // Projects
  // static const slashBWebsite='https://slashb.app/';
  // static const hexeeWebsite='https://hexee.app/';

  static Future<void> open(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }
}
