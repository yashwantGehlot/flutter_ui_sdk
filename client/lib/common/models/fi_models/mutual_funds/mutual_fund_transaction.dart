import 'package:xml/xml.dart';

class MutualFundTransaction {
  String? transactionId;
  String? amc;
  String? registrar;
  String? schemeCode;
  String? schemePlan;
  String? isin;
  int? amfiCode;
  String? ucc;
  double? amount;
  double? nav;
  DateTime? navDate;
  String? type;
  String? lockInFlag;
  String? lockInDays;
  String? mode;
  String? narration;
  String? isinDescription;
  String? units;
  DateTime? transactionDateTime;

  MutualFundTransaction({
    this.transactionId,
    this.amc,
    this.registrar,
    this.schemeCode,
    this.schemePlan,
    this.isin,
    this.amfiCode,
    this.ucc,
    this.amount,
    this.nav,
    this.navDate,
    this.type,
    this.lockInFlag,
    this.lockInDays,
    this.mode,
    this.narration,
    this.isinDescription,
    this.units,
    this.transactionDateTime,
  });

  factory MutualFundTransaction.fromXmlElement(
    final XmlElement transactionElement,
  ) {
    final transactionTimestamp = transactionElement.getAttribute("transactionDate");
    final navTimestamp = transactionElement.getAttribute("navDate");
    return MutualFundTransaction(
      transactionId: transactionElement.getAttribute("txnId"),
      amc: transactionElement.getAttribute("amc"),
      registrar: transactionElement.getAttribute("registrar"),
      schemeCode: transactionElement.getAttribute("schemeCode"),
      schemePlan: transactionElement.getAttribute("schemePlan"),
      isin: transactionElement.getAttribute("isin"),
      amfiCode: int.tryParse(transactionElement.getAttribute("amfiCode") ?? "0"),
      ucc: transactionElement.getAttribute("ucc"),
      amount: double.tryParse(transactionElement.getAttribute("amount") ?? "0.0"),
      nav: double.tryParse(transactionElement.getAttribute("nav") ?? "0.0"),
      navDate: navTimestamp != null
          ? DateTime.parse(navTimestamp)
          : null,
      type: transactionElement.getAttribute("type"),
      lockInFlag: transactionElement.getAttribute("lockInFlag"),
      lockInDays: transactionElement.getAttribute("lockInDays"),
      mode: transactionElement.getAttribute("mode"),
      narration: transactionElement.getAttribute("narration"),
      isinDescription: transactionElement.getAttribute("isinDescription"),
      units: transactionElement.getAttribute("units"),
      transactionDateTime: transactionTimestamp != null
          ? DateTime.parse(transactionTimestamp)
          : null,
    );
  }
}
