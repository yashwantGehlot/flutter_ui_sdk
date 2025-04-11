import 'package:xml/xml.dart';

class EquityTransaction {
  String? transactionId;
  String? orderId;
  String? companyName;
  DateTime? transactionDateTime;
  String? exchange;
  String? isin;
  String? isinDescription;
  String? equityCategory;
  String? narration;
  double? rate;
  int? units;
  String? type;

  EquityTransaction({
    this.transactionId,
    this.orderId,
    this.companyName,
    this.transactionDateTime,
    this.exchange,
    this.isin,
    this.isinDescription,
    this.equityCategory,
    this.narration,
    this.rate,
    this.units,
    this.type,
  });

  factory EquityTransaction.fromXmlElement(
    final XmlElement transactionElement,
  ) {
    final transactionTimestamp =
        transactionElement.getAttribute("transactionDateTime");
    return EquityTransaction(
      transactionId: transactionElement.getAttribute("txnId"),
      orderId: transactionElement.getAttribute("orderId"),
      companyName: transactionElement.getAttribute("companyName"),
      transactionDateTime: transactionTimestamp != null
          ? DateTime.parse(transactionTimestamp)
          : null,
      exchange: transactionElement.getAttribute("exchange"),
      isin: transactionElement.getAttribute("isin"),
      isinDescription: transactionElement.getAttribute("isinDescription"),
      equityCategory: transactionElement.getAttribute("equityCategory"),
      narration: transactionElement.getAttribute("narration"),
      rate: double.tryParse(transactionElement.getAttribute("rate") ?? ""),
      units: int.tryParse(transactionElement.getAttribute("units") ?? ""),
      type: transactionElement.getAttribute("type"),
    );
  }
}
