import 'package:finvu_flutter_sdk/common/models/fi_models/mutual_funds/mutual_fund_holding.dart';
import 'package:xml/xml.dart';

class MutualFundInvestment {
  List<MutualFundHolding>? holding;

  MutualFundInvestment({
    required this.holding,
  });

  factory MutualFundInvestment.fromXmlElement(
      final XmlElement investmentElement) {
    final holdingsElement = investmentElement
        .findElements('Holding')
        .map((element) => MutualFundHolding.fromXmlElement(element))
        .toList();

    return MutualFundInvestment(
      holding: holdingsElement,
    );
  }
}
