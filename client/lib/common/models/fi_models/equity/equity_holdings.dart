import 'package:finvu_flutter_sdk/common/models/fi_models/equity/equity_holding.dart';
import 'package:xml/xml.dart';

class EquityHoldings {
  String? type;
  List<EquityHolding>? holding;

  EquityHoldings({
    required this.type,
    required this.holding,
  });

  factory EquityHoldings.fromXmlElement(final XmlElement holdingsElement) {
    final holding = holdingsElement
        .findElements('Holding')
        .map((element) => EquityHolding.fromXmlElement(element))
        .toList();
    return EquityHoldings(
      type: holdingsElement.getAttribute("type"),
      holding: holding,
    );
  }
}
