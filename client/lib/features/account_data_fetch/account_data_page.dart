import 'dart:async';

import 'package:finvu_flutter_sdk/common/models/consent.dart';
import 'package:finvu_flutter_sdk/common/models/fi_models/account.dart';
import 'package:finvu_flutter_sdk/common/models/finvu_error.dart';
import 'package:finvu_flutter_sdk/common/models/linked_account_with_fip.dart';
import 'package:finvu_flutter_sdk/common/models/notification_with_entity_info.dart';
import 'package:finvu_flutter_sdk/common/utils/analytics_events.dart';
import 'package:finvu_flutter_sdk/common/utils/error_utils.dart';
import 'package:finvu_flutter_sdk/common/utils/remote_config_service.dart';
import 'package:finvu_flutter_sdk/common/utils/ui_utils.dart';
import 'package:finvu_flutter_sdk/common/widgets/base_page.dart';
import 'package:finvu_flutter_sdk/common/widgets/finvu_page_header.dart';
import 'package:finvu_flutter_sdk/features/account_data_fetch/deposits/bank_account_item.dart';
import 'package:finvu_flutter_sdk/features/account_data_fetch/bloc/account_data_bloc.dart';
import 'package:finvu_flutter_sdk/features/account_data_fetch/bloc/account_data_event.dart';
import 'package:finvu_flutter_sdk/features/account_data_fetch/bloc/account_data_state.dart';
import 'package:finvu_flutter_sdk/features/account_data_fetch/equity/equity_item.dart';
import 'package:finvu_flutter_sdk/features/account_data_fetch/insurance/insurance_item.dart';
import 'package:finvu_flutter_sdk/features/account_data_fetch/mutual_fund/mutual_fund_item.dart';
import 'package:finvu_flutter_sdk/features/account_data_fetch/recurring_deposits/recurring_deposit_account_item.dart';
import 'package:finvu_flutter_sdk/features/account_data_fetch/term_deposits/term_deposit_account_item.dart';
import 'package:finvu_flutter_sdk/features/notification/bloc/notification_bloc.dart';
import 'package:finvu_flutter_sdk_core/finvu_initiate_account_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AccountDataPage extends BasePage {
  const AccountDataPage(
      {super.key, required this.consent, required this.account});

  final ConsentDetails consent;
  final LinkedAccountInfo account;

  @override
  State<AccountDataPage> createState() => _AccountDataPageState();

  @override
  String routeName() {
    return FinvuScreens.accountDataPage;
  }
}

class _AccountDataPageState extends BasePageState<AccountDataPage> {
  var shouldShowSpinner = true;
  var didFetch = false;

  late String requestSessionId;
  late String requestConsentId;
  Timer? _pollingTimer;
  final remoteConfig = RemoteConfigService();

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  void _stopPolling() {
    _pollingTimer?.cancel();
  }

  void _startPolling(BuildContext context) {
    var interval = remoteConfig.accountDataFetchPollIntervalInSeconds;
    _pollingTimer = Timer.periodic(Duration(seconds: interval), (timer) {
      context.read<NotificationBloc>().add(const NotificationsFetch());
    });

    Timer(Duration(seconds: remoteConfig.accountDataFetchPollTimeoutInSeconds),
        () {
      if (mounted) {
        _stopPolling();
        setState(() {
          shouldShowSpinner = false;
          didFetch = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AccountDataBloc>(
          create: (context) => AccountDataBloc()
            ..add(
              AccountDataFetchRequestSubmitted(widget.consent),
            ),
        ),
        BlocProvider(create: (context) => NotificationBloc()),
      ],
      child: Scaffold(
        appBar: UIUtils.getFinvuAppBar(),
        body: MultiBlocListener(
          listeners: [
            BlocListener<AccountDataBloc, AccountDataState>(
              listener: (context, state) {
                if (state.status ==
                    AccountDataStatus.accountDataRequestInitiated) {
                  setState(() {
                    requestSessionId = state.sessionId;
                    requestConsentId = state.consentId;
                  });
                  _startPolling(context);
                } else if (state.status ==
                    AccountDataStatus.accountDataFetched) {
                  setState(() {
                    shouldShowSpinner = false;
                    didFetch = true;
                  });
                } else if (state.status ==
                        AccountDataStatus
                            .accountDataRequestInitialisationFailed ||
                    state.status == AccountDataStatus.accountDataFetchFailed) {
                  setState(() {
                    shouldShowSpinner = false;
                    didFetch = false;
                  });
                } else if (state.status == AccountDataStatus.error) {
                  handleError(context, state.error);
                }
              },
            ),
            BlocListener<NotificationBloc, NotificationState>(
              listener: (context, state) {
                if (state.status == NotificationStatus.notificationFetched) {
                  stopPollingIfRequired(context, state.priorityNotifications,
                      state.otherNotifications);
                } else if (state.status == NotificationStatus.error) {
                  handleError(context, state.error);
                }
              },
            ),
          ],
          child: BlocBuilder<AccountDataBloc, AccountDataState>(
            builder: (context, state) {
              return Column(
                children: [
                  const FinvuPageHeader(
                    title: "Account Data",
                  ),
                  const SizedBox(height: 20),
                  shouldShowSpinner
                      ? const CircularProgressIndicator()
                      : didFetch
                          ? getWidgetForAccountData(state.accountData!)
                          : Text(
                              AppLocalizations.of(context)!.failedToFetchData)
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void handleError(BuildContext context, FinvuError? error) {
    if (ErrorUtils.hasSessionExpired(error)) {
      handleSessionExpired(context);
    } else {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              ErrorUtils.getErrorMessage(context, error),
            ),
          ),
        );

      setState(() {
        shouldShowSpinner = false;
        didFetch = false;
      });
    }
  }

  void stopPollingIfRequired(
      BuildContext context,
      List<NotificationWithEntityInfo> priorityNotifications,
      List<NotificationWithEntityInfo> otherNotifications) {
    var notifications =
        {...priorityNotifications, ...otherNotifications}.toList();
    var shouldStopPolling = notifications
        .where((notification) =>
            notification.requestConsentId == requestConsentId &&
            notification.requestSessionId == requestSessionId)
        .isNotEmpty;
    if (shouldStopPolling) {
      _stopPolling();
      context.read<AccountDataBloc>().add(const AccountDataFetchSubmitted());
    }
  }

  Widget getWidgetForAccountData(final AccountDataFetchResponse accountData) {
    final account = FIAccount.fromXml(
      accountData.decryptedInfo.first.decryptedData,
    );
    if (account.deposit != null) {
      return bankAccountItem(context, account, widget.account);
    }
    if (account.termDeposit != null) {
      return termDepositAccountItem(context, account, widget.account);
    }
    if (account.recurringDeposit != null) {
      return recurringDepositAccountItem(context, account, widget.account);
    }
    if (account.equities != null) {
      return equityItem(context, account, widget.account);
    }
    if (account.mutualFund != null) {
      return mutualFundItem(context, account, widget.account);
    }
    if (account.insurance != null) {
      return insuranceItem(context, account, widget.account);
    }
    return Container();
  }
}
