part of 'notification_bloc.dart';

sealed class NotificationEvent {
  const NotificationEvent();
}

final class NotificationFetched extends NotificationEvent {
  const NotificationFetched(this.notifications);

  final FinvuOfflineMessageInfo notifications;
}

final class RemovePriorityNotification extends NotificationEvent {
  const RemovePriorityNotification(this.notification);
  final NotificationWithEntityInfo notification;
}

final class NotificationsFetch extends NotificationEvent {
  const NotificationsFetch();
}
