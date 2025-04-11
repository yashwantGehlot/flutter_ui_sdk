import 'package:finvu_flutter_sdk_core/finvu_discovered_accounts.dart';

class DiscoveredAccountInfo extends FinvuDiscoveredAccountInfo {
  DiscoveredAccountInfo({
    required super.accountType,
    required super.accountReferenceNumber,
    required super.maskedAccountNumber,
    required super.fiType,
    required this.isLinked,
  });

  DiscoveredAccountInfo.from(
    FinvuDiscoveredAccountInfo accountInfo,
    bool isLinked,
  ) : this(
          accountType: accountInfo.accountType,
          accountReferenceNumber: accountInfo.accountReferenceNumber,
          maskedAccountNumber: accountInfo.maskedAccountNumber,
          fiType: accountInfo.fiType,
          isLinked: isLinked,
        );

  bool isLinked;
}
