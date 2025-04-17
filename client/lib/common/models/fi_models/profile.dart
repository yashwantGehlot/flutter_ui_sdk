import 'package:finvu_flutter_sdk/common/models/fi_models/holders.dart';
import 'package:xml/xml.dart';

class Profile {
  Holders? holders;

  Profile({
    required this.holders,
  });

  factory Profile.fromXmlElement(final XmlElement profileElement) {
    final holders = profileElement.findElements('Holders').first;
    return Profile(holders: Holders.fromXmlElement(holders));
  }
}
