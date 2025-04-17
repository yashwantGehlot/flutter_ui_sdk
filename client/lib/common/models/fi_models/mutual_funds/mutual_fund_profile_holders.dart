import 'package:finvu_flutter_sdk/common/models/fi_models/mutual_funds/mutual_fund_profile_holder.dart';
import 'package:xml/xml.dart';

class MutualFundHolders {
  MutualFundHolder? holder;

  MutualFundHolders({
    required this.holder,
  });

  factory MutualFundHolders.fromXmlElement(final XmlElement holdersElement) {
    final holderElement = holdersElement.findElements('Holder').first;

    return MutualFundHolders(
      holder: MutualFundHolder.fromXmlElement(holderElement),
    );
  }
}
