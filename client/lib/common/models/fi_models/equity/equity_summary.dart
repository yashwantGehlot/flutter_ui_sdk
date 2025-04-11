import 'package:finvu_flutter_sdk/common/models/fi_models/equity/equity_investment.dart';
import 'package:xml/xml.dart';

class EquitySummary {
  double? currentValue;
  EquityInvestment? investment;

  EquitySummary({
    required this.currentValue,
    required this.investment,
  });

  factory EquitySummary.fromXmlElement(final XmlElement equitySummaryElement) {
    final investmentElement =
        equitySummaryElement.findElements('Investment').first;
    return EquitySummary(
      currentValue: double.tryParse(
          equitySummaryElement.getAttribute("currentValue") ?? "0.0"),
      investment: EquityInvestment.fromXmlElement(investmentElement),
    );
  }
}
