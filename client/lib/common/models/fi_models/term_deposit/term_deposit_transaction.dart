import 'package:xml/xml.dart';

class TermDepositTransaction {
  String? txnId;
  String? amount;
  String? narration;
  String? type;
  String? mode;
  String? balance;
  DateTime? transactionDateTime;
  DateTime? valueDate;
  String? reference;

  TermDepositTransaction({
    this.txnId,
    this.amount,
    this.narration,
    this.type,
    this.mode,
    this.balance,
    this.transactionDateTime,
    this.valueDate,
    this.reference,
  });

  factory TermDepositTransaction.fromXmlElement(XmlElement transactionElement) {
    final transactionDateTime =
        transactionElement.getAttribute('transactionDateTime');
    final valueDate = transactionElement.getAttribute('valueDate');

    return TermDepositTransaction(
      txnId: transactionElement.getAttribute('txnId'),
      amount: transactionElement.getAttribute('amount'),
      narration: transactionElement.getAttribute('narration'),
      type: transactionElement.getAttribute('type'),
      mode: transactionElement.getAttribute('mode'),
      balance: transactionElement.getAttribute('balance'),
      transactionDateTime: transactionDateTime != null
          ? DateTime.parse(transactionDateTime)
          : null,
      valueDate: valueDate != null ? DateTime.parse(valueDate) : null,
      reference: transactionElement.getAttribute('reference'),
    );
  }
}
