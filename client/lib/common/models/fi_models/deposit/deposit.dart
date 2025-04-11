import 'package:finvu_flutter_sdk/common/models/fi_models/deposit/deposit_summary.dart';
import 'package:finvu_flutter_sdk/common/models/fi_models/deposit/deposit_transactions.dart';
import 'package:xml/xml.dart';

class Deposit {
  DepositSummary summary;
  DepositTransactions? transactions;

  Deposit({
    required this.summary,
    required this.transactions,
  });

  factory Deposit.fromXmlElement(final XmlElement accountElement) {
    final summaryElement = accountElement.findElements("Summary").first;
    final transactionsElement = accountElement.findElements("Transactions");
    final transactions = transactionsElement.isNotEmpty
        ? DepositTransactions.fromXmlElement(transactionsElement.first)
        : null;

    return Deposit(
      summary: DepositSummary.fromXmlElement(summaryElement),
      transactions: transactions,
    );
  }
}
