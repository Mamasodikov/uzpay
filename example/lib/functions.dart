import 'package:url_launcher/url_launcher.dart';

launchCustomUrl(String url) async {
  var uri = Uri.parse(url);

  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } else {
    throw 'Could not launch $url';
  }
}