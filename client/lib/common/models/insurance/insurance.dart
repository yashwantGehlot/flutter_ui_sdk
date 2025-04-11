import 'package:finvu_flutter_sdk/common/models/insurance/insurance_profile.dart';
import 'package:finvu_flutter_sdk/common/models/insurance/insurance_summary.dart';
import 'package:finvu_flutter_sdk/common/models/insurance/insurance_transactions.dart';
import 'package:xml/xml.dart';

class Insurance {
  InsuranceSummary summary;
  InsuranceTransactions? transactions;
  InsuranceProfile profile;

  Insurance({
    required this.transactions,
    required this.summary,
    required this.profile,
  });

  factory Insurance.fromXmlElement(final XmlElement accountElement) {
    final summaryElement = accountElement.findElements("Summary").first;
    final transactionsElement = accountElement.findElements("Transactions");
    final transactions = transactionsElement.isNotEmpty
        ? InsuranceTransactions.fromXmlElement(transactionsElement.first)
        : null;
    final profileElement = accountElement.findElements("Profile").first;

    return Insurance(
        summary: InsuranceSummary.fromXmlElement(summaryElement),
        transactions: transactions,
        profile: InsuranceProfile.fromXmlElement(profileElement));
  }
}
