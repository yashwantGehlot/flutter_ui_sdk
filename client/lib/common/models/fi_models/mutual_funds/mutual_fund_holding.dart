import 'package:xml/xml.dart';

class MutualFundHolding {
  String? amc;
  String? registrar;
  String? schemeCode;
  String? schemeOption;
  String? schemeTypes;
  String? schemeCategory;
  String? isin;
  String? isinDescription;
  String? ucc;
  int? amfiCode;
  int? folioNo;
  String? fatcaStatus;
  double? closingUnits;
  int? lienUnits;
  double? nav;
  DateTime? navDate;
  int? lockinUnits;

  MutualFundHolding({
    this.amc,
    this.registrar,
    this.schemeCode,
    this.schemeOption,
    this.schemeTypes,
    this.schemeCategory,
    this.isin,
    this.isinDescription,
    this.ucc,
    this.amfiCode,
    this.folioNo,
    this.fatcaStatus,
    this.closingUnits,
    this.lienUnits,
    this.nav,
    this.navDate,
    this.lockinUnits,
  });

  factory MutualFundHolding.fromXmlElement(final XmlElement holdingElement) {
    final navDate = holdingElement.getAttribute("navDate");

    return MutualFundHolding(
      amc: holdingElement.getAttribute("amc"),
      registrar: holdingElement.getAttribute("registrar"),
      schemeCode: holdingElement.getAttribute("schemeCode"),
      schemeOption: holdingElement.getAttribute("schemeOption"),
      schemeTypes: holdingElement.getAttribute("schemeTypes"),
      schemeCategory: holdingElement.getAttribute("schemeCategory"),
      isin: holdingElement.getAttribute("isin"),
      isinDescription: holdingElement.getAttribute("isinDescription"),
      ucc: holdingElement.getAttribute("ucc"),
      amfiCode: int.tryParse(holdingElement.getAttribute("amfiCode") ?? "0"),
      folioNo: int.tryParse(holdingElement.getAttribute("folioNo") ?? "0"),
      fatcaStatus: holdingElement.getAttribute("FatcaStatus"),
      closingUnits: double.tryParse(holdingElement.getAttribute("closingUnits") ?? "0.0"),
      lienUnits: int.tryParse(holdingElement.getAttribute("lienUnits") ?? "0"),
      nav: double.tryParse(holdingElement.getAttribute("nav") ?? "0.0"),
      navDate: navDate != null
        ? DateTime.parse(navDate)
        : null,
      lockinUnits: int.tryParse(holdingElement.getAttribute("lockinUnits") ?? "0"),
    );
  }
}
