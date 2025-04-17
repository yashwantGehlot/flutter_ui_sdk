import 'package:finvu_flutter_sdk/common/models/fi_models/deposit/deposit.dart';
import 'package:finvu_flutter_sdk/common/models/fi_models/equity/equity.dart';
import 'package:finvu_flutter_sdk/common/models/fi_models/mutual_funds/mutual_fund.dart';
import 'package:finvu_flutter_sdk/common/models/fi_models/profile.dart';
import 'package:finvu_flutter_sdk/common/models/fi_models/recurring_deposit/recurring_deposit.dart';
import 'package:finvu_flutter_sdk/common/models/fi_models/term_deposit/term_deposit.dart';
import 'package:finvu_flutter_sdk/common/models/insurance/insurance.dart';
import 'package:xml/xml.dart';

class FIAccount {
  String? type;
  String? version;
  String? linkedAccountReference;
  String? maskedDematId;
  String? maskedAccountNumber;
  String? maskedFolioNo;
  Profile? profile;

  Deposit? deposit;
  TermDeposit? termDeposit;
  RecurringDeposit? recurringDeposit;
  Equity? equities;
  MutualFund? mutualFund;
  Insurance? insurance;

  FIAccount({
    required this.type,
    required this.version,
    required this.linkedAccountReference,
    required this.profile,
    this.maskedAccountNumber,
    this.maskedDematId,
    this.maskedFolioNo,
  });

  factory FIAccount.fromXml(final String xml) {
    final document = XmlDocument.parse(xml);
    final accountElement = document.findElements("Account").first;
    final profileElement = accountElement.findElements("Profile").first;

    final account = FIAccount(
      type: accountElement.getAttribute("type"),
      version: accountElement.getAttribute("version"),
      linkedAccountReference: accountElement.getAttribute("linkedAccRef"),
      profile: Profile.fromXmlElement(profileElement),
      maskedAccountNumber: accountElement.getAttribute("maskedAccNumber"),
      maskedDematId: accountElement.getAttribute("maskedDematId"),
      maskedFolioNo: accountElement.getAttribute("maskedFolioNo"),
    );

    switch (account.type?.toUpperCase()) {
      case "DEPOSIT":
        account.deposit = Deposit.fromXmlElement(accountElement);
        break;
      case "TERM-DEPOSIT" || "TERM_DEPOSIT":
        account.termDeposit = TermDeposit.fromXmlElement(accountElement);
        break;
      case "RECURRING-DEPOSIT" || "RECURRING_DEPOSIT":
        account.recurringDeposit =
            RecurringDeposit.fromXmlElement(accountElement);
        break;
      case "EQUITIES":
        account.equities = Equity.fromXmlElement(accountElement);
        break;
      case "INSURANCE":
        account.insurance = Insurance.fromXmlElement(accountElement);
        break;
      case "MUTUALFUNDS":
        account.mutualFund = MutualFund.fromXmlElement(accountElement);
        break;
    }

    return account;
  }
}
