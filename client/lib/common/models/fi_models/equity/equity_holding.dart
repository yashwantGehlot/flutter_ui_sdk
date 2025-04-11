import 'package:xml/xml.dart';

class EquityHolding {
  String? issuerName;
  String? isin;
  String? isinDescription;
  int? units;
  double? lastTradedPrice;

  EquityHolding({
    this.issuerName,
    this.isin,
    this.isinDescription,
    this.units,
    this.lastTradedPrice,
  });

  factory EquityHolding.fromXmlElement(final XmlElement holdingElement) {
    return EquityHolding(
      issuerName: holdingElement.getAttribute("issuerName"),
      isin: holdingElement.getAttribute("isin"),
      isinDescription: holdingElement.getAttribute("isinDescription"),
      units: int.tryParse(holdingElement.getAttribute("units") ?? ""),
      lastTradedPrice:
          double.tryParse(holdingElement.getAttribute("lastTradedPrice") ?? ""),
    );
  }
}
