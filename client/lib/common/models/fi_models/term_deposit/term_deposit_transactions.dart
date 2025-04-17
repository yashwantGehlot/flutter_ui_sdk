import 'package:finvu_flutter_sdk/common/models/fi_models/term_deposit/term_deposit_transaction.dart';
import 'package:xml/xml.dart';

class TermDepositTransactions {
  String? startDate;
  String? endDate;
  List<TermDepositTransaction>? transactions;

  TermDepositTransactions({
    this.startDate,
    this.endDate,
    this.transactions,
  });

  factory TermDepositTransactions.fromXmlElement(
      XmlElement transactionsElement) {
    final transactions = transactionsElement
        .findElements('Transaction')
        .map((element) => TermDepositTransaction.fromXmlElement(element))
        .toList();
    return TermDepositTransactions(
      startDate: transactionsElement.getAttribute('startDate'),
      endDate: transactionsElement.getAttribute('endDate'),
      transactions: transactions,
    );
  }
}
