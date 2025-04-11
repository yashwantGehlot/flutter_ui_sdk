import 'package:finvu_flutter_sdk/common/models/bottom_navigation_item.dart';
import 'package:finvu_flutter_sdk/common/utils/analytics_events.dart';
import 'package:finvu_flutter_sdk/common/utils/error_utils.dart';
import 'package:finvu_flutter_sdk/common/utils/finvu_colors.dart';
import 'package:finvu_flutter_sdk/common/widgets/base_page.dart';
import 'package:finvu_flutter_sdk/features/notification/bloc/notification_bloc.dart';
import 'package:finvu_flutter_sdk/features/notification/views/notifications_other_notification_tab.dart';
import 'package:finvu_flutter_sdk/features/notification/views/notifications_priority_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NotificationsPage extends BasePage {
  const NotificationsPage({super.key, required this.onNavigateToItem});

  @override
  State<NotificationsPage> createState() => _NotificationPageState();

  final Function(BottomNavigationItem) onNavigateToItem;

  @override
  String routeName() {
    return FinvuScreens.notificationsPage;
  }
}

class _NotificationPageState extends BasePageState<NotificationsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: FinvuColors.darkBlue,
        automaticallyImplyLeading: false,
        actions: [
          RawMaterialButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            elevation: 2.0,
            constraints: const BoxConstraints.tightFor(
              width: 28.0,
              height: 28.0,
            ),
            fillColor: Colors.white,
            shape: const CircleBorder(),
            child: const Icon(
              Icons.close_rounded,
              size: 12.0,
            ),
          ),
        ],
        title: Padding(
          padding: const EdgeInsets.only(left: 25),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 20,
                color: Colors.white,
              ),
              AppLocalizations.of(context)!.notifications,
            ),
          ),
        ),
        titleSpacing: 0,
        iconTheme: const IconThemeData(color: FinvuColors.blue),
      ),
      backgroundColor: FinvuColors.lightBlue,
      body: BlocProvider(
        create: (context) =>
            NotificationBloc()..add(const NotificationsFetch()),
        child: BlocConsumer<NotificationBloc, NotificationState>(
          listener: (context, state) {
            if (state.status == NotificationStatus.error) {
              if (ErrorUtils.hasSessionExpired(state.error)) {
                handleSessionExpired(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      ErrorUtils.getErrorMessage(context, state.error),
                    ),
                  ),
                );
              }
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                Expanded(
                  child: DefaultTabController(
                    length: 2,
                    child: Column(
                      children: [
                        ColoredBox(
                          color: FinvuColors.darkBlue,
                          child: TabBar(
                            tabs: [
                              Tab(text: AppLocalizations.of(context)!.priority),
                              Tab(
                                  text: AppLocalizations.of(context)!
                                      .otherNotifications),
                            ],
                            labelColor: Colors.white,
                            indicatorColor: Colors.white,
                            unselectedLabelColor: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Expanded(
                          child: TabBarView(
                            children: [
                              NotificationsPriorityTab(
                                onNavigateToItem: widget.onNavigateToItem,
                              ),
                              const NotificationsOtherNotificationsTab()
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
