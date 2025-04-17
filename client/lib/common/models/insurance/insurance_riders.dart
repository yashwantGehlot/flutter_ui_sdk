import 'package:finvu_flutter_sdk/common/models/insurance/insurance_rider.dart';
import 'package:xml/xml.dart';

class InsuranceRiders {
  InsuranceRider? rider;
  String? type;

  InsuranceRiders({
    required this.rider,
  });

  factory InsuranceRiders.fromXmlElement(final XmlElement ridersElement) {
    final riderElement = ridersElement.findElements('Rider').first;

    return InsuranceRiders(
      rider: InsuranceRider.fromXmlElement(riderElement),
    );
  }
}
