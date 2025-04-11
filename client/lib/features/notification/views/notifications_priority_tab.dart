import 'package:finvu_flutter_sdk/common/models/notification_with_entity_info.dart';
import 'package:finvu_flutter_sdk/common/models/bottom_navigation_item.dart';
import 'package:finvu_flutter_sdk/common/utils/finvu_colors.dart';
import 'package:finvu_flutter_sdk/common/utils/finvu_date_utils.dart';
import 'package:finvu_flutter_sdk/features/notification/bloc/notification_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NotificationsPriorityTab extends StatelessWidget {
  const NotificationsPriorityTab({
    super.key,
    required this.onNavigateToItem,
  });

  final Function(BottomNavigationItem) onNavigateToItem;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotificationBloc, NotificationState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state.status == NotificationStatus.isFetchingNotification) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.priorityNotifications.isEmpty) {
          return Center(
            child: Text(AppLocalizations.of(context)!.noPriorityNotifications),
          );
        }
        return SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(top: 20, bottom: 20),
            child: Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: state.priorityNotifications.length,
                  itemBuilder: (context, index) {
                    return _notificationItem(
                      context,
                      state.priorityNotifications[index],
                    );
                  },
                ),
              ],
            ),
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
                            fontSize: 12,
                            color: FinvuColors.grey81858F,
                          ),
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
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Row(
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10, top: 7, bottom: 7),
                                  minimumSize: const Size(0, 0),
                                  foregroundColor: Colors.white,
                                  backgroundColor: FinvuColors.blue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                ),
                                onPressed: () {
                                  onNavigateToItem(
                                      BottomNavigationItem.consents);
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  style: const TextStyle(fontSize: 11),
                                  AppLocalizations.of(context)!.goToConsents,
                                ),
                              ),
                              const Padding(padding: EdgeInsets.all(10)),
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  side:
                                      const BorderSide(color: FinvuColors.blue),
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10, top: 7, bottom: 7),
                                  minimumSize: const Size(0, 0),
                                  foregroundColor: FinvuColors.black111111,
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                ),
                                onPressed: () {
                                  context.read<NotificationBloc>().add(
                                        RemovePriorityNotification(
                                          notification,
                                        ),
                                      );
                                },
                                child: Text(
                                    style: const TextStyle(fontSize: 11),
                                    AppLocalizations.of(context)!.later),
                              ),
                            ],
                          ),
                        )
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
