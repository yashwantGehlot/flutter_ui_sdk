import 'package:finvu_flutter_sdk/common/models/consent.dart';

ConsentDetails? getConsentsForAccount(
    List<ConsentDetails> activeSelfConsents, String linkReferenceNumber) {
  for (var selfConsent in activeSelfConsents) {
    var currentAccountActiveSelfConsents = selfConsent
        .consentInfoDetails?.accounts
        .where((account) => account.linkReferenceNumber == linkReferenceNumber)
        .toList();

    if (currentAccountActiveSelfConsents != null &&
        currentAccountActiveSelfConsents.isNotEmpty) {
      return selfConsent;
    }
  }
  return null;
}
