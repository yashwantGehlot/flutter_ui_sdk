import 'package:finvu_flutter_sdk/common/models/consent.dart';
import 'package:finvu_flutter_sdk/common/models/fi_type.dart';
import 'package:finvu_flutter_sdk/common/models/fi_type_category.dart';
import 'package:finvu_flutter_sdk/common/models/linked_account_with_fip.dart';
import 'package:finvu_flutter_sdk/common/utils/analytics_events.dart';
import 'package:finvu_flutter_sdk/common/utils/finvu_colors.dart';
import 'package:finvu_flutter_sdk/common/utils/finvu_date_utils.dart';
import 'package:finvu_flutter_sdk/common/utils/remote_config_service.dart';
import 'package:finvu_flutter_sdk/common/utils/ui_utils.dart';
import 'package:finvu_flutter_sdk/common/widgets/base_page.dart';
import 'package:finvu_flutter_sdk/common/widgets/finvu_fip_icon.dart';
import 'package:finvu_flutter_sdk/common/widgets/finvu_page_header.dart';
import 'package:finvu_flutter_sdk/features/accounts/account_utils.dart';
import 'package:finvu_flutter_sdk/features/consents/bloc/consent_bloc.dart';
import 'package:finvu_flutter_sdk/features/consents/self_consent_page.dart';
import 'package:finvu_flutter_sdk/features/consents/views/linked_account_consent_cards.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finvu_flutter_sdk/l10n/app_localizations.dart';

class LinkedAccountsDetailsPage extends BasePage {
  const LinkedAccountsDetailsPage({super.key, required this.account});

  final LinkedAccountInfo account;

  @override
  State<LinkedAccountsDetailsPage> createState() =>
      _LinkedAccountsDetailsPageState();

  @override
  String routeName() {
    return FinvuScreens.linkedAccountsDetailsPage;
  }
}

bool isSupportedFiType(FiType? fiType) {
  return FiTypeCategory.insurance.fiTypes.contains(fiType) ||
      FiTypeCategory.termAndRecurringDeposits.fiTypes.contains(fiType) ||
      FiTypeCategory.bankAccounts.fiTypes.contains(fiType) ||
      FiTypeCategory.mutualFunds.fiTypes.contains(fiType) ||
      FiTypeCategory.equities.fiTypes.contains(fiType);
}

class _LinkedAccountsDetailsPageState extends State<LinkedAccountsDetailsPage> {
  ConsentDetails? activeSelfConsent;
  var isFetchingConsents = true;
  final remoteConfig = RemoteConfigService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UIUtils.getFinvuAppBar(),
      body: BlocProvider(
        create: (_) => ConsentBloc()..add(const ConsentsRefresh()),
        child: BlocConsumer<ConsentBloc, ConsentState>(
          listener: (context, state) {
            if (state.status == ConsentStatus.isFetchingConsents) {
              setState(() {
                isFetchingConsents = true;
              });
            } else if (state.status == ConsentStatus.consentsFetched) {
              setState(() {
                isFetchingConsents = false;
              });
            }

            if (state.status == ConsentStatus.consentRevoked) {
              setState(() {
                activeSelfConsent = null;
              });
            }

            if (state.status == ConsentStatus.consentRevoked ||
                state.status == ConsentStatus.selfConsentRequested) {
              context.read<ConsentBloc>().add(const ConsentsRefresh());
            }

            if (state.status == ConsentStatus.unknown ||
                state.status == ConsentStatus.consentsFetched ||
                state.status == ConsentStatus.selfConsentRequested) {
              setState(() {
                activeSelfConsent = getConsentsForAccount(
                    state.activeSelfConsents,
                    widget.account.linkReferenceNumber);
              });
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FinvuPageHeader(
                      title: AppLocalizations.of(context)!.accountInformation),
                  const Padding(
                    padding: EdgeInsets.only(top: 30),
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          ListTile(
                            trailing: remoteConfig
                                        .isAccountDataFeatureEnabled &&
                                    isSupportedFiType(
                                        fiTypeFromString(widget.account.fiType))
                                ? isFetchingConsents
                                    ? const SizedBox()
                                    : _buildViewDataButton(context)
                                : null,
                            tileColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            leading: FinvuFipIcon(
                              iconUri: widget.account.fipInfo.productIconUri,
                              size: 40,
                            ),
                            title: Text(
                              widget.account.fipName,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: FinvuColors.black111111,
                              ),
                            ),
                            subtitle: Text(
                              "${widget.account.accountType} ${widget.account.maskedAccountNumber}",
                              style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: FinvuColors.grey81858F,
                              ),
                            ),
                          ),
                          const Divider(
                            height: 15,
                            thickness: 1.5,
                            color: FinvuColors.greyE1E4EF,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                FinvuDateUtils.format(widget
                                    .account.linkedAccountUpdateTimestamp!),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
                              ),
                              Chip(
                                shape: const StadiumBorder(
                                  side: BorderSide(
                                    color: FinvuColors.lightGreen,
                                  ),
                                ),
                                backgroundColor: FinvuColors.lightGreen,
                                label: Text(
                                  AppLocalizations.of(context)!.accountLinked,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 10,
                                    color: FinvuColors.green,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Divider(
                            height: 15,
                            thickness: 1.5,
                            color: FinvuColors.greyE1E4EF,
                          ),
                          LinkedAccountConsentCards(
                              account: widget.account,
                              shouldAllowSelfConsentAddition:
                                  !(activeSelfConsent != null))
                        ],
                      ))
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  InkWell _buildViewDataButton(BuildContext context) {
    return InkWell(
      onTap: () {
        if (activeSelfConsent != null) {
          _goToAccountDataPage(context, activeSelfConsent!, widget.account);
        } else {
          _goToSelfConsentConfigPage(context, widget.account);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: Text(
          AppLocalizations.of(context)!.viewData,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 12,
            color: FinvuColors.blue,
          ),
        ),
      ),
    );
  }

  void _goToSelfConsentConfigPage(
    BuildContext context,
    LinkedAccountInfo account,
  ) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<ConsentBloc>(),
          child: SelfConsentPage(accounts: [account]),
        ),
      ),
    );
  }

  void _goToAccountDataPage(
    final BuildContext context,
    final ConsentDetails activeSelfConsent,
    LinkedAccountInfo account,
  ) async {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) =>
    //         AccountDataPage(consent: activeSelfConsent, account: account),
    //   ),
    // ).then((onValue) {
    //   context.read<ConsentBloc>().add(const ConsentsRefresh());
    // });
  }
}
