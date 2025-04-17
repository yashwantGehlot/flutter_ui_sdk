import 'package:finvu_flutter_sdk/common/models/fi_models/mutual_funds/mutual_fund_transaction.dart';
import 'package:xml/xml.dart';

class MutualFundTransactions {
  String? startDate;
  String? endDate;
  List<MutualFundTransaction>? transactions;

  MutualFundTransactions({
    this.startDate,
    this.endDate,
    this.transactions,
  });

  factory MutualFundTransactions.fromXmlElement(
      XmlElement transactionsElement) {
    final transactions = transactionsElement
        .findElements("Transaction")
        .map((element) => MutualFundTransaction.fromXmlElement(element))
        .toList();
    return MutualFundTransactions(
      startDate: transactionsElement.getAttribute("startDate"),
      endDate: transactionsElement.getAttribute("endDate"),
      transactions: transactions,
    );
  }
}
