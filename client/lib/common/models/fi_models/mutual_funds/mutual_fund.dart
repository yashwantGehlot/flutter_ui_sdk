import 'package:finvu_flutter_sdk/common/models/fi_models/mutual_funds/mutual_fund_profile.dart';
import 'package:finvu_flutter_sdk/common/models/fi_models/mutual_funds/mutual_fund_summary.dart';
import 'package:finvu_flutter_sdk/common/models/fi_models/mutual_funds/mutual_fund_transactions.dart';
import 'package:xml/xml.dart';

class MutualFund {
  MutualFundSummary summary;
  MutualFundTransactions? transactions;
  MutualFundProfile profile;

  MutualFund({
    required this.transactions,
    required this.summary,
    required this.profile,
  });

  factory MutualFund.fromXmlElement(final XmlElement accountElement) {
    final summaryElement = accountElement.findElements("Summary").first;
    final transactionsElement = accountElement.findElements("Transactions");
    final transactions = transactionsElement.isNotEmpty
        ? MutualFundTransactions.fromXmlElement(transactionsElement.first)
        : null;
    final profileElement = accountElement.findElements("Profile").first;

    return MutualFund(
      summary: MutualFundSummary.fromXmlElement(summaryElement),
      transactions: transactions,
      profile: MutualFundProfile.fromXmlElement(profileElement),
    );
  }
}
