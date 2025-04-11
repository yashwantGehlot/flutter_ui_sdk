import 'package:xml/xml.dart';

class InsuranceTransaction {
  String? transactionId;
  DateTime? transactionDate;
  String? narration;
  String? bonus;
  double? amount;


  InsuranceTransaction({
    this.transactionId,
    this.transactionDate,
    this.narration,
    this.bonus,
    this.amount,
  });

  factory InsuranceTransaction.fromXmlElement(
    final XmlElement transactionElement,
  ) {
    final transactionTimestamp =
        transactionElement.getAttribute("txnDate");
    return InsuranceTransaction(
      transactionId: transactionElement.getAttribute("txnId"),
      transactionDate: transactionTimestamp != null
          ? DateTime.parse(transactionTimestamp)
          : null,
      narration: transactionElement.getAttribute("narration"),
      bonus: transactionElement.getAttribute("bonus"),
      amount: double.tryParse(transactionElement.getAttribute("amount") ?? "0.0"),
    );
  }
}
