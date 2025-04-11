part of 'notification_bloc.dart';

enum NotificationStatus {
  unknown,
  isFetchingNotification,
  notificationFetched,
  error,
}

class NotificationState extends Equatable {
  final NotificationStatus status;
  final List<NotificationWithEntityInfo> priorityNotifications;
  final List<NotificationWithEntityInfo> otherNotifications;
  final FinvuError? error;

  const NotificationState({
    this.status = NotificationStatus.unknown,
    this.priorityNotifications = const [],
    this.otherNotifications = const [],
    this.error,
  });

  NotificationState copyWith({
    List<NotificationWithEntityInfo>? priorityNotifications,
    List<NotificationWithEntityInfo>? otherNotifications,
    required NotificationStatus status,
    FinvuError? error,
  }) {
    return NotificationState(
      priorityNotifications:
          priorityNotifications ?? this.priorityNotifications,
      otherNotifications: otherNotifications ?? this.otherNotifications,
      status: status,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
        priorityNotifications,
        otherNotifications,
        status,
        error,
      ];
}
