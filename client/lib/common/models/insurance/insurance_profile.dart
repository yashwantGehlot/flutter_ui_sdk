import 'package:finvu_flutter_sdk/common/models/insurance/insurance_holders.dart';
import 'package:finvu_flutter_sdk/common/models/insurance/insurance_riders.dart';
import 'package:xml/xml.dart';

class InsuranceProfile {
  InsuranceHolders? holders;
  InsuranceRiders? riders;

  InsuranceProfile({
    required this.holders,
    required this.riders,
  });

  factory InsuranceProfile.fromXmlElement(final XmlElement investmentElement) {
    final holdersElement = investmentElement.findElements('Holders').first;
    final ridersElement = investmentElement.findElements('Riders').first;

    return InsuranceProfile(
        holders: InsuranceHolders.fromXmlElement(holdersElement),
        riders: InsuranceRiders.fromXmlElement(ridersElement));
  }
}
