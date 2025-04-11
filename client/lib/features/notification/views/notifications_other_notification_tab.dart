import 'package:finvu_flutter_sdk/common/models/notification_with_entity_info.dart';
import 'package:finvu_flutter_sdk/common/utils/finvu_colors.dart';
import 'package:finvu_flutter_sdk/common/utils/finvu_date_utils.dart';
import 'package:finvu_flutter_sdk/features/notification/bloc/notification_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NotificationsOtherNotificationsTab extends StatelessWidget {
  const NotificationsOtherNotificationsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotificationBloc, NotificationState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state.status == NotificationStatus.isFetchingNotification) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.otherNotifications.isEmpty) {
          return Center(
            child: Text(AppLocalizations.of(context)!.noOtherNotifications),
          );
        }
        return SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 20),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: state.otherNotifications.length,
                  itemBuilder: (context, index) {
                    return _notificationItem(
                      context,
                      state.otherNotifications[index],
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _notificationItem(
    BuildContext context,
    NotificationWithEntityInfo notification,
  ) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notification.messageText,
                          style: const TextStyle(
                              fontSize: 12, color: FinvuColors.grey81858F),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            FinvuDateUtils.formatToRelativeTime(
                              context,
                              notification.messageTimestamp,
                            ),
                            style: const TextStyle(
                              fontSize: 12,
                              color: FinvuColors.black111111,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 12, bottom: 12),
            child: Divider(
              height: 1,
              color: FinvuColors.greyE1E4EF,
            ),
          )
        ],
      ),
    );
  }
}
