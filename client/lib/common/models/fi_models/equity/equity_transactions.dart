import 'package:finvu_flutter_sdk/common/models/fi_models/equity/equity_transaction.dart';
import 'package:xml/xml.dart';

class EquityTransactions {
  String? startDate;
  String? endDate;
  List<EquityTransaction>? transactions;

  EquityTransactions({
    this.startDate,
    this.endDate,
    this.transactions,
  });

  factory EquityTransactions.fromXmlElement(XmlElement transactionsElement) {
    final transactions = transactionsElement
        .findElements("Transaction")
        .map((element) => EquityTransaction.fromXmlElement(element))
        .toList();
    return EquityTransactions(
      startDate: transactionsElement.getAttribute("startDate"),
      endDate: transactionsElement.getAttribute("endDate"),
      transactions: transactions,
    );
  }
}
