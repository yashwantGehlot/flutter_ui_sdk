import 'package:finvu_flutter_sdk/common/models/fi_models/deposit/deposit_transaction.dart';
import 'package:xml/xml.dart';

class DepositTransactions {
  String? startDate;
  String? endDate;
  List<DepositTransaction>? transactions;

  DepositTransactions({
    this.startDate,
    this.endDate,
    this.transactions,
  });

  factory DepositTransactions.fromXmlElement(XmlElement transactionsElement) {
    final transactions = transactionsElement
        .findElements("Transaction")
        .map((element) => DepositTransaction.fromXmlElement(element))
        .toList();
    return DepositTransactions(
      startDate: transactionsElement.getAttribute("startDate"),
      endDate: transactionsElement.getAttribute("endDate"),
      transactions: transactions,
    );
  }
}
