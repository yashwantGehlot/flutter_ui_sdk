import 'package:finvu_flutter_sdk/common/models/fi_models/profile.dart';
import 'package:finvu_flutter_sdk/common/models/fi_models/term_deposit/term_deposit_summary.dart';
import 'package:finvu_flutter_sdk/common/models/fi_models/term_deposit/term_deposit_transactions.dart';
import 'package:xml/xml.dart';

class TermDeposit {
  Profile profile;
  TermDepositSummary summary;
  TermDepositTransactions? transactions;

  TermDeposit({
    required this.profile,
    required this.summary,
    required this.transactions,
  });

  factory TermDeposit.fromXmlElement(final XmlElement accountElement) {
    final profileElement = accountElement.findElements('Profile').first;
    final summaryElement = accountElement.findElements('Summary').first;
    final transactionsElement = accountElement.findElements('Transactions');
    final transactions = transactionsElement.isNotEmpty
        ? TermDepositTransactions.fromXmlElement(transactionsElement.first)
        : null;

    return TermDeposit(
      profile: Profile.fromXmlElement(profileElement),
      summary: TermDepositSummary.fromXmlElement(summaryElement),
      transactions: transactions,
    );
  }
}
