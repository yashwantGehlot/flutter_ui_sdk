import 'package:finvu_flutter_sdk/common/models/insurance/insurance_transaction.dart';
import 'package:xml/xml.dart';

class InsuranceTransactions {
  String? startDate;
  String? endDate;
  List<InsuranceTransaction>? transactions;

  InsuranceTransactions({
    this.startDate,
    this.endDate,
    this.transactions,
  });

  factory InsuranceTransactions.fromXmlElement(XmlElement transactionsElement) {
    final transactions = transactionsElement
        .findElements("Transaction")
        .map((element) => InsuranceTransaction.fromXmlElement(element))
        .toList();
    return InsuranceTransactions(
      startDate: transactionsElement.getAttribute("startDate"),
      endDate: transactionsElement.getAttribute("endDate"),
      transactions: transactions,
    );
  }
}
