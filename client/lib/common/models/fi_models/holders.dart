import 'package:finvu_flutter_sdk/common/models/fi_models/holder.dart';
import 'package:xml/xml.dart';

class Holders {
  Holder? holder;
  String? type;

  Holders({
    required this.holder,
    required this.type,
  });

  factory Holders.fromXmlElement(final XmlElement holdersElement) {
    final holder = holdersElement.findElements('Holder').first;
    return Holders(
      holder: Holder.fromXmlElement(holder),
      type: holdersElement.getAttribute("type") ?? "",
    );
  }
}
