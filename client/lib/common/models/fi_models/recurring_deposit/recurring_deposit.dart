import 'package:finvu_flutter_sdk/common/models/fi_models/profile.dart';
import 'package:finvu_flutter_sdk/common/models/fi_models/recurring_deposit/recurring_deposit_summary.dart';
import 'package:finvu_flutter_sdk/common/models/fi_models/recurring_deposit/recurring_deposit_transactions.dart';
import 'package:xml/xml.dart';

class RecurringDeposit {
  Profile profile;
  RecurringDepositSummary summary;
  RecurringDepositTransactions? transactions;

  RecurringDeposit({
    required this.profile,
    required this.summary,
    required this.transactions,
  });

  factory RecurringDeposit.fromXmlElement(final XmlElement accountElement) {
    final profileElement = accountElement.findElements('Profile').first;
    final summaryElement = accountElement.findElements('Summary').first;
    final transactionsElement = accountElement.findElements('Transactions');
    final transactions = transactionsElement.isNotEmpty
        ? RecurringDepositTransactions.fromXmlElement(transactionsElement.first)
        : null;

    return RecurringDeposit(
      profile: Profile.fromXmlElement(profileElement),
      summary: RecurringDepositSummary.fromXmlElement(summaryElement),
      transactions: transactions,
    );
  }
}
