import 'package:finvu_flutter_sdk/common/models/fi_models/recurring_deposit/recurring_deposit_transaction.dart';
import 'package:xml/xml.dart';

class RecurringDepositTransactions {
  String? startDate;
  String? endDate;
  List<RecurringDepositTransaction>? transactions;

  RecurringDepositTransactions({
    this.startDate,
    this.endDate,
    this.transactions,
  });

  factory RecurringDepositTransactions.fromXmlElement(
      XmlElement transactionsElement) {
    final transactions = transactionsElement
        .findElements('Transaction')
        .map((element) => RecurringDepositTransaction.fromXmlElement(element))
        .toList();
    return RecurringDepositTransactions(
      startDate: transactionsElement.getAttribute('startDate'),
      endDate: transactionsElement.getAttribute('endDate'),
      transactions: transactions,
    );
  }
}
