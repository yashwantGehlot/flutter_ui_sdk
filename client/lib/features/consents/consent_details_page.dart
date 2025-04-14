import 'package:dotted_border/dotted_border.dart';
import 'package:finvu_flutter_sdk/common/models/consent.dart';
import 'package:finvu_flutter_sdk/common/utils/analytics_events.dart';
import 'package:finvu_flutter_sdk/common/utils/constants.dart';
import 'package:finvu_flutter_sdk/common/utils/finvu_colors.dart';
import 'package:finvu_flutter_sdk/common/utils/finvu_date_utils.dart';
import 'package:finvu_flutter_sdk/common/utils/ui_utils.dart';
import 'package:finvu_flutter_sdk/common/widgets/base_page.dart';
import 'package:finvu_flutter_sdk/common/widgets/finvu_dialog.dart';
import 'package:finvu_flutter_sdk/common/widgets/finvu_fip_icon.dart';
import 'package:finvu_flutter_sdk/common/widgets/finvu_page_header.dart';
import 'package:finvu_flutter_sdk/features/consents/bloc/consent_bloc.dart';
import 'package:finvu_flutter_sdk/features/consents/consent_history_page.dart';
import 'package:finvu_flutter_sdk_core/finvu_consent_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finvu_flutter_sdk/l10n/app_localizations.dart';

class ConsentDetailsPage extends BasePage {
  const ConsentDetailsPage({
    super.key,
    required this.consent,
  });

  final ConsentDetails consent;

  @override
  State<ConsentDetailsPage> createState() => _ConsentDetailsPageState();

  @override
  String routeName() {
    return FinvuScreens.consentDetailsPage;
  }
}

class _ConsentDetailsPageState extends BasePageState<ConsentDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ConsentBloc, ConsentState>(
      listener: (BuildContext context, ConsentState state) {
        if (state.status == ConsentStatus.consentRevoked) {
          Navigator.pop(context, Constants.consentRevoked);
        } else if (state.status == ConsentStatus.historyFetched) {
          if (state.consentHistory.isEmpty) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(
                    AppLocalizations.of(context)!.noConsentActivityFound,
                  ),
                ),
              );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ConsentHistoryPage(
                  consentHistory: state.consentHistory,
                ),
              ),
            );
          }
        }
      },
      buildWhen: (context, state) {
        return state.status == ConsentStatus.unknown;
      },
      builder: (context, state) {
        final consent = widget.consent;
        return Scaffold(
          appBar: UIUtils.getFinvuAppBar(),
          backgroundColor: FinvuColors.lightBlue,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FinvuPageHeader(
                  title: AppLocalizations.of(context)!.consentDetails,
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildEntityDetailsWidget(context, consent),
                          const SizedBox(height: 10),
                          _buildViewConsentActivityButton(context),
                          const SizedBox(height: 10),
                          Visibility(
                            visible: consent.consentStatus == Constants.active,
                            child: _buildRevokeButton(context),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 20,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: FinvuColors.greyE1E4EF,
                              ),
                              color: Colors.white,
                            ),
                            child: _consentTimeline(context),
                          ),
                          _accountsList(context),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: _buildTextAccessDetails(context),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: _buildConsentDetailsWidget(context, consent),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Text _buildTextAccessDetails(BuildContext context) {
    return Text(
      AppLocalizations.of(context)!.accessDetails,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 14,
        color: FinvuColors.black111111,
      ),
    );
  }

  Column _buildTextConsentDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.consentDetails,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 14,
            color: FinvuColors.black111111,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          "${widget.consent.entityInfo.entityName} ${AppLocalizations.of(context)!.hasYourConsentAccess}",
          style: const TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 12,
            color: FinvuColors.grey81858F,
          ),
        ),
      ],
    );
  }

  Container _consentTimeline(BuildContext context) {
    final consent = widget.consent;
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextConsentDetails(context),
          const SizedBox(
            height: 30,
          ),
          _buildConsentTimeline(
            true,
            AppLocalizations.of(context)!.consentRequested,
            FinvuDateUtils.formatToDate(
              consent.dataDateTimeRange.from!,
            ),
          ),
          _buildSeparater(),
          consent.statusLastUpdateTimestamp != null
              ? _buildConsentTimeline(
                  true,
                  AppLocalizations.of(context)!.acceptedOn,
                  FinvuDateUtils.formatToDate(
                      consent.statusLastUpdateTimestamp!))
              : const SizedBox(),
          _buildSeparater(),
          _buildConsentTimeline(
            consent.consentStatus != Constants.active,
            consent.consentStatus == Constants.revoked
                ? AppLocalizations.of(context)!.expiredOn
                : AppLocalizations.of(context)!.expiryOn,
            FinvuDateUtils.formatToDate(
              consent.dataDateTimeRange.to!,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConsentTimeline(
    bool timelineCompleted,
    String title,
    String subtitle,
  ) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: ColorFiltered(
            colorFilter: widget.consent.consentStatus != Constants.active
                ? ColorFilter.mode(
                    FinvuColors.greyF5F5F5.withOpacity(0.8), BlendMode.srcATop)
                : const ColorFilter.mode(Colors.transparent, BlendMode.srcATop),
            child: Image(
              width: 30,
              height: 30,
              image: timelineCompleted
                  ? const AssetImage('lib/assets/greenRingWithTick.png')
                  : const AssetImage('lib/assets/greyRing.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: FinvuColors.black111111,
              ),
            ),
            Text(
              subtitle,
              style: const TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 12,
                color: FinvuColors.grey81858F,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSeparater() {
    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: Stack(
        alignment: Alignment.center,
        children: [
          RotatedBox(
            quarterTurns: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: DottedBorder(
                padding: EdgeInsets.zero,
                dashPattern: const [2, 5],
                color: FinvuColors.grey81858F,
                child: SizedBox.fromSize(
                  size: const Size(40, 0),
                ),
              ),
            ),
          ),
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: FinvuColors.grey81858F,
            ),
          ),
        ],
      ),
    );
  }

  Widget _accountsList(final BuildContext context) {
    final accounts = widget.consent.consentInfoDetails?.accounts ?? [];
    return Padding(
      padding: const EdgeInsets.only(top: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.consentForAccounts,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: FinvuColors.black111111,
            ),
          ),
          ...accounts.map((account) => _buildLinkedAccountWidget(account))
        ],
      ),
    );
  }

  GestureDetector _buildRevokeButton(BuildContext context) {
    final consent = widget.consent;
    return GestureDetector(
      onTap: () {
        if (consent.finvuUserConsentInfo != null) {
          _showRevokeConsentConfirmationDialog(context, consent);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 50),
        child: Text(
          AppLocalizations.of(context)!.revoke.toUpperCase(),
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 12,
            color: FinvuColors.redC52E2E, // Solid black color
          ),
        ),
      ),
    );
  }

  GestureDetector _buildViewConsentActivityButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context
            .read<ConsentBloc>()
            .add(ConsentHistory(consent: widget.consent));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 50),
        child: Text(
          AppLocalizations.of(context)!.viewConsentActivity,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 12,
            color: FinvuColors.blue,
          ),
        ),
      ),
    );
  }

  Widget _buildLinkedAccountWidget(
    FinvuConsentAccountDetails account,
  ) {
    return Padding(
        padding: const EdgeInsets.only(top: 15),
        child: Card(
          color: Colors.white,
          margin: const EdgeInsets.all(0),
          surfaceTintColor: Colors.transparent,
          shape: const RoundedRectangleBorder(
            side: BorderSide(color: FinvuColors.greyE1E4EF),
            borderRadius: BorderRadius.all(Radius.circular(14)),
          ),
          elevation: 0,
          child: ListTile(
            leading: FinvuFipIcon(
              iconUri: "",
              size: 35,
              applyTint: widget.consent.consentStatus != Constants.active,
            ),
            title: Text(
              account.fipName,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 12,
                color: FinvuColors.black111111,
              ),
            ),
            subtitle: Text(
              "${account.accountType} ${account.maskedAccountNumber}",
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 12,
                color: FinvuColors.grey81858F,
              ),
            ),
          ),
        ));
  }

  Widget _buildEntityDetailsWidget(
    BuildContext context,
    ConsentDetails consentInfo,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      tileColor: Colors.transparent,
      leading: FinvuFipIcon(
        iconUri: consentInfo.entityInfo.entityIconUri ??
            consentInfo.entityInfo.entityLogoUri,
        size: 35,
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            consentInfo.entityInfo.entityName,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: FinvuColors.black111111,
            ),
          ),
          Text(
            "${AppLocalizations.of(context)!.purpose}: ${consentInfo.consentPurposeInfo.text}",
            style: const TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 12,
              color: FinvuColors.grey81858F,
            ),
          ),
        ],
      ),
      trailing: Container(
        decoration: BoxDecoration(
          border: Border.all(color: FinvuColors.green),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          consentInfo.consentStatus,
          style: const TextStyle(
            color: FinvuColors.green,
            fontSize: 10,
          ),
        ),
      ),
    );
  }

  Widget _buildConsentDetailsWidget(
    BuildContext context,
    ConsentDetails consentInfo,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildInfoCard(
                AppLocalizations.of(context)!.frequency,
                AppLocalizations.of(context)!.informationFetchedTimes(
                  consentInfo.consentDataFrequency.value.toInt(),
                  consentInfo.consentDataFrequency.unit.toLowerCase(),
                ),
              ),
              _buildInfoCard(
                AppLocalizations.of(context)!.dataToDate,
                FinvuDateUtils.formatToDate(
                  consentInfo.dataDateTimeRange.to!,
                ),
              ),
              _buildInfoCard(
                AppLocalizations.of(context)!.accountInformation,
                consentInfo.consentDisplayDescriptions
                    .map((val) => UIUtils.toSentenceCase(val))
                    .join(", "),
              ),
              _buildInfoCard(
                AppLocalizations.of(context)!.consentId,
                consentInfo.consentId.toString(),
              ),
              _buildInfoCard(
                AppLocalizations.of(context)!.dataStoredUntil,
                "${consentInfo.consentDataLifePeriod.value.toInt()} ${consentInfo.consentDataLifePeriod.unit.toLowerCase()}",
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildInfoCard(
                AppLocalizations.of(context)!.dataFromDate,
                FinvuDateUtils.formatToDate(
                  consentInfo.dataDateTimeRange.from!,
                ),
              ),
              _buildInfoCard(
                AppLocalizations.of(context)!.purpose,
                consentInfo.consentPurposeInfo.text,
              ),
              _buildInfoCard(
                AppLocalizations.of(context)!.fiTypes,
                consentInfo.fiTypes!.join(", "),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(String title, String value) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.white,
        border: Border.all(
          color: FinvuColors.greyE1E4EF,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: FinvuColors.grey81858F,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: FinvuColors.black111111,
            ),
          ),
        ],
      ),
    );
  }

  void _showRevokeConsentConfirmationDialog(
      BuildContext context, ConsentDetails consent) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return FinvuDialog(
            title: AppLocalizations.of(context)!.confirmation,
            subtitle: [
              TextSpan(
                text: AppLocalizations.of(context)!.revokeConsentConfirmation,
              ),
            ],
            content: const SizedBox(height: 0, width: 0),
            buttonText: AppLocalizations.of(context)!.continuee,
            onPressed: () {
              context.read<ConsentBloc>().add(ConsentRevoke(consent: consent));
              Navigator.of(context).pop();
            },
            shouldShowCancelButton: true,
          );
        });
  }
}
