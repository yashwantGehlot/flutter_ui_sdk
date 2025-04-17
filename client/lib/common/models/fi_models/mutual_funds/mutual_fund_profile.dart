import 'package:finvu_flutter_sdk/common/models/fi_models/mutual_funds/mutual_fund_profile_holders.dart';
import 'package:xml/xml.dart';

class MutualFundProfile {
  MutualFundHolders? holders;

  MutualFundProfile({
    required this.holders,
  });

  factory MutualFundProfile.fromXmlElement(final XmlElement investmentElement) {
    final holdersElement = investmentElement.findElements('Holders').first;

    return MutualFundProfile(
      holders: MutualFundHolders.fromXmlElement(holdersElement),
    );
  }
}
