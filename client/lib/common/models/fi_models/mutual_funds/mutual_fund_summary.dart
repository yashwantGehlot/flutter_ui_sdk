import 'package:finvu_flutter_sdk/common/models/fi_models/mutual_funds/mutual_fund_investment.dart';
import 'package:xml/xml.dart';

class MutualFundSummary {
  double? currentValue;
  MutualFundInvestment? investment;

  MutualFundSummary({
    required this.currentValue,
    required this.investment,
  });

  factory MutualFundSummary.fromXmlElement(
      final XmlElement equitySummaryElement) {
    final investmentElement =
        equitySummaryElement.findElements('Investment').first;
    return MutualFundSummary(
      currentValue: double.tryParse(
          equitySummaryElement.getAttribute("currentValue") ?? "0.0"),
      investment: MutualFundInvestment.fromXmlElement(investmentElement),
    );
  }
}
