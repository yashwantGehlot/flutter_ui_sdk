import 'package:finvu_flutter_sdk/common/models/insurance/insurance_holder.dart';
import 'package:xml/xml.dart';

class InsuranceHolders {
  InsuranceHolder? holder;
  String? type;

  InsuranceHolders({
    required this.holder,
    required this.type,
  });

  factory InsuranceHolders.fromXmlElement(final XmlElement holdersElement) {
    final holderElement = holdersElement.findElements('Holder').first;

    return InsuranceHolders(
      holder: InsuranceHolder.fromXmlElement(holderElement),
      type: holdersElement.getAttribute("type"),
    );
  }
}
