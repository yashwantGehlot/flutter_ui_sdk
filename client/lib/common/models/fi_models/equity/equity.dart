import 'package:finvu_flutter_sdk/common/models/fi_models/equity/equity_summary.dart';
import 'package:finvu_flutter_sdk/common/models/fi_models/equity/equity_transactions.dart';
import 'package:xml/xml.dart';

class Equity {
  EquitySummary summary;
  EquityTransactions? transactions;

  Equity({
    required this.transactions,
    required this.summary,
  });

  factory Equity.fromXmlElement(final XmlElement accountElement) {
    final summaryElement = accountElement.findElements("Summary").first;
    final transactionsElement = accountElement.findElements("Transactions");
    final transactions = transactionsElement.isNotEmpty
        ? EquityTransactions.fromXmlElement(transactionsElement.first)
        : null;

    return Equity(
      summary: EquitySummary.fromXmlElement(summaryElement),
      transactions: transactions,
    );
  }
}
