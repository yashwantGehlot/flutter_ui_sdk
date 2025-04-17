import 'package:finvu_flutter_sdk_core/finvu_offline_messages.dart';

class NotificationWithEntityInfo extends FinvuOfflineMessageInfo {
  NotificationWithEntityInfo({
    required FinvuOfflineMessageInfo offlineMessage,
  }) : super(
          userId: offlineMessage.userId,
          messageId: offlineMessage.messageId,
          messageAcked: offlineMessage.messageAcked,
          messageOriginator: offlineMessage.messageOriginator,
          messageOriginatorName: offlineMessage.messageOriginatorName,
          messageText: offlineMessage.messageText,
          messageTimestamp: offlineMessage.messageTimestamp,
          messageType: offlineMessage.messageType,
          requestConsentId: offlineMessage.requestConsentId,
          requestSessionId: offlineMessage.requestSessionId,
        );
}
