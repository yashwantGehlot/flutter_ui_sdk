import 'package:finvu_flutter_sdk/common/models/fi_type.dart';
import 'package:flutter/material.dart';
import 'package:finvu_flutter_sdk/l10n/app_localizations.dart';

enum FiTypeCategory {
  all([]), // This is a special category that includes all the FI types
  bankAccounts([FiType.deposit]),
  termAndRecurringDeposits([
    FiType.termDeposit,
    FiType.termDeposit2,
    FiType.recurringDeposit,
  ]),
  insurance([
    FiType.insurancePolicies,
    FiType.lifeInsurance,
    FiType.generalInsurance,
  ]),
  mutualFunds([FiType.mutualFunds]),
  equities([FiType.equities]),
  gstin([FiType.gstr13b]),
  nps([FiType.nps]),
  other([
    FiType.sip,
    FiType.cp,
    FiType.govtSecurities,
    FiType.bonds,
    FiType.debentures,
    FiType.etf,
    FiType.idr,
    FiType.cis,
    FiType.aif,
    FiType.invit,
    FiType.reit,
    FiType.other,
  ]);

  final List<FiType> fiTypes;

  const FiTypeCategory(this.fiTypes);

  String getLocalizedTitle(BuildContext context) {
    switch (this) {
      case FiTypeCategory.all:
        return AppLocalizations.of(context)!.all;
      case FiTypeCategory.bankAccounts:
        return AppLocalizations.of(context)!.bankAccounts;
      case FiTypeCategory.termAndRecurringDeposits:
        return AppLocalizations.of(context)!.termAndRecurringDeposits;
      case FiTypeCategory.insurance:
        return AppLocalizations.of(context)!.insurance;
      case FiTypeCategory.mutualFunds:
        return AppLocalizations.of(context)!.mutualFunds;
      case FiTypeCategory.equities:
        return AppLocalizations.of(context)!.equities;
      case FiTypeCategory.gstin:
        return AppLocalizations.of(context)!.gstin;
      case FiTypeCategory.nps:
        return AppLocalizations.of(context)!.nps;
      case FiTypeCategory.other:
        return AppLocalizations.of(context)!.other;
    }
  }
}
