import 'package:url_launcher/url_launcher.dart';

Future<void> launch(final Uri url) async {
  if (!await launchUrl(url)) {
    throw Exception('Could not launch $url');
  }
}
