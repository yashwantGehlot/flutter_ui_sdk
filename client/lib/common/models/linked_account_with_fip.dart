import 'package:finvu_flutter_sdk_core/finvu_fip_info.dart';
import 'package:finvu_flutter_sdk_core/finvu_linked_accounts.dart';

class LinkedAccountInfo extends FinvuLinkedAccountDetailsInfo {
  LinkedAccountInfo({
    required FinvuLinkedAccountDetailsInfo linkedAccountDetailsInfo,
    required this.fipInfo,
  }) : super(
          userId: linkedAccountDetailsInfo.userId,
          fipId: linkedAccountDetailsInfo.fipId,
          fipName: linkedAccountDetailsInfo.fipName,
          maskedAccountNumber: linkedAccountDetailsInfo.maskedAccountNumber,
          accountReferenceNumber:
              linkedAccountDetailsInfo.accountReferenceNumber,
          linkReferenceNumber: linkedAccountDetailsInfo.linkReferenceNumber,
          consentIdList: linkedAccountDetailsInfo.consentIdList,
          fiType: linkedAccountDetailsInfo.fiType,
          accountType: linkedAccountDetailsInfo.accountType,
          linkedAccountUpdateTimestamp:
              linkedAccountDetailsInfo.linkedAccountUpdateTimestamp,
          authenticatorType: linkedAccountDetailsInfo.authenticatorType,
        );

  FinvuFIPInfo fipInfo;
}
