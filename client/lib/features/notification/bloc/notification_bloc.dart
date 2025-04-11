import 'package:equatable/equatable.dart';
import 'package:finvu_flutter_sdk/common/models/finvu_error.dart';
import 'package:finvu_flutter_sdk/common/models/notification_with_entity_info.dart';
import 'package:finvu_flutter_sdk/common/utils/constants.dart';
import 'package:finvu_flutter_sdk/common/utils/finvu_date_utils.dart';
import 'package:finvu_flutter_sdk_core/finvu_exception.dart';
import 'package:finvu_flutter_sdk_core/finvu_offline_messages.dart';
import 'package:finvu_flutter_sdk_internal/finvu_manager_internal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final FinvuManagerInternal _finvuManagerInternal = FinvuManagerInternal();

  NotificationBloc() : super(const NotificationState()) {
    on<NotificationsFetch>(_onNotificationFetch);
    on<RemovePriorityNotification>(_onRemovePriorityNotification);
  }
  void _onRemovePriorityNotification(
    RemovePriorityNotification event,
    Emitter<NotificationState> emit,
  ) async {
    List<NotificationWithEntityInfo> modifiedList =
        List<NotificationWithEntityInfo>.from(state.priorityNotifications);

    modifiedList.remove(event.notification);
    emit(
      state.copyWith(
        priorityNotifications: modifiedList,
        status: NotificationStatus.notificationFetched,
      ),
    );
  }

  void _onNotificationFetch(
    NotificationsFetch event,
    Emitter<NotificationState> emit,
  ) async {
    emit(
      state.copyWith(
        status: NotificationStatus.isFetchingNotification,
      ),
    );
    try {
      final notifications = await _finvuManagerInternal.fetchOfflineMessages();

      final priorityMessages = notifications
          .where((element) => element.messageType == Constants.consentRequested)
          .map(
            (e) => NotificationWithEntityInfo(
              offlineMessage: e,
            ),
          )
          .toList();

      priorityMessages.sort(
        (a, b) =>
            FinvuDateUtils.getDateFromTimestamp(b.messageTimestamp).compareTo(
          FinvuDateUtils.getDateFromTimestamp(a.messageTimestamp),
        ),
      );

      final otherMessages = notifications
          .where((element) => element.messageType != Constants.consentRequested)
          .map(
            (e) => NotificationWithEntityInfo(
              offlineMessage: e,
            ),
          )
          .toList();

      otherMessages.sort(
        (a, b) =>
            FinvuDateUtils.getDateFromTimestamp(b.messageTimestamp).compareTo(
          FinvuDateUtils.getDateFromTimestamp(a.messageTimestamp),
        ),
      );

      emit(
        state.copyWith(
          priorityNotifications: priorityMessages,
          otherNotifications: otherMessages,
          status: NotificationStatus.notificationFetched,
        ),
      );
    } on FinvuException catch (err) {
      debugPrint("Error while fetching Notification $err");
      emit(
        state.copyWith(
          status: NotificationStatus.error,
          error: err.toFinvuError(),
        ),
      );
    } catch (err) {
      debugPrint("Error while fetching Notification $err");
      emit(
        state.copyWith(
          status: NotificationStatus.error,
        ),
      );
    }
  }
}
