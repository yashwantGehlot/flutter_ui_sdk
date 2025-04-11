import 'package:finvu_flutter_sdk/common/models/fi_models/equity/equity_holdings.dart';
import 'package:xml/xml.dart';

class EquityInvestment {
  EquityHoldings? holdings;

  EquityInvestment({
    required this.holdings,
  });

  factory EquityInvestment.fromXmlElement(final XmlElement investmentElement) {
    final holdingsElement = investmentElement.findElements('Holdings').first;
    return EquityInvestment(
      holdings: EquityHoldings.fromXmlElement(holdingsElement),
    );
  }
}
