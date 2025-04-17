import 'package:xml/xml.dart';

class DepositTransaction {
  String? type;
  String? mode;
  double? amount;
  String? currentBalance;
  DateTime? transactionTimestamp;
  DateTime? valueDate;
  String? transactionId;
  String? narration;
  String? reference;

  DepositTransaction({
    this.type,
    this.mode,
    this.amount,
    this.currentBalance,
    this.transactionTimestamp,
    this.valueDate,
    this.transactionId,
    this.narration,
    this.reference,
  });

  factory DepositTransaction.fromXmlElement(
    final XmlElement transactionElement,
  ) {
    final transactionTimestamp =
        transactionElement.getAttribute("transactionTimestamp");
    final valueDate = transactionElement.getAttribute("valueDate");
    return DepositTransaction(
      type: transactionElement.getAttribute("type"),
      mode: transactionElement.getAttribute("mode"),
      amount: double.tryParse(transactionElement.getAttribute("amount") ?? ""),
      currentBalance: transactionElement.getAttribute("currentBalance") ?? "",
      transactionTimestamp: transactionTimestamp != null
          ? DateTime.parse(transactionTimestamp)
          : null,
      valueDate: valueDate != null ? DateTime.parse(valueDate) : null,
      transactionId: transactionElement.getAttribute("txnId"),
      narration: transactionElement.getAttribute("narration"),
      reference: transactionElement.getAttribute("reference"),
    );
  }
}
