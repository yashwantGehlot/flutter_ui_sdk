import 'package:finvu_flutter_sdk/common/models/consent.dart';
import 'package:finvu_flutter_sdk/common/models/linked_account_with_fip.dart';
import 'package:finvu_flutter_sdk/common/utils/constants.dart';
import 'package:finvu_flutter_sdk/common/utils/finvu_colors.dart';
import 'package:finvu_flutter_sdk/common/utils/finvu_date_utils.dart';
import 'package:finvu_flutter_sdk/common/widgets/finvu_fip_icon.dart';
import 'package:finvu_flutter_sdk/features/consents/bloc/consent_bloc.dart';
import 'package:finvu_flutter_sdk/features/consents/consent_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finvu_flutter_sdk/l10n/app_localizations.dart';

class LinkedAccountConsentCards extends StatefulWidget {
  const LinkedAccountConsentCards(
      {super.key,
      required this.account,
      required this.shouldAllowSelfConsentAddition});

  final LinkedAccountInfo account;
  final bool shouldAllowSelfConsentAddition;

  @override
  State<LinkedAccountConsentCards> createState() =>
      _LinkedAccountConsentCardsState();
}

class _LinkedAccountConsentCardsState extends State<LinkedAccountConsentCards> {
  bool hasConsents = false;
  List<ConsentDetails> consents = [];
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ConsentBloc, ConsentState>(listener: (context, state) {
      if (state.status == ConsentStatus.consentRevoked) {
        context.read<ConsentBloc>().add(const ConsentsRefresh());
      }
      if (state.status == ConsentStatus.consentsFetched) {
        var consentList = [
          ...state.activeConsents,
          ...state.activeSelfConsents,
          ...state.inactiveConsents,
          ...state.expiringConsents
        ];

        var linkedConsents = consentList.where((consent) {
          var linkReferenceNumbers = consent.consentInfoDetails?.accounts
              .map((acc) => acc.linkReferenceNumber)
              .toList();

          return linkReferenceNumbers
                  ?.contains(widget.account.linkReferenceNumber) ??
              false;
        }).toList();

        var revokedConsents = linkedConsents
            .where((consent) => consent.consentStatus == Constants.revoked)
            .toList();

        var nonRevokedConsents = linkedConsents
            .where((consent) =>
                consent.consentStatus != Constants.revoked &&
                !state.activeSelfConsents.contains(consent))
            .toList();

        var selfConsents = linkedConsents
            .where((consent) =>
                consent.consentStatus != Constants.revoked &&
                state.activeSelfConsents.contains(consent))
            .toList();
        consents = [...selfConsents, ...nonRevokedConsents, ...revokedConsents];

        setState(() {
          hasConsents = consents.isNotEmpty;
        });
      }
    }, builder: (context, state) {
      if (state.status == ConsentStatus.isFetchingConsents) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      return Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              hasConsents
                  ? AppLocalizations.of(context)!.accountConsents
                  : AppLocalizations.of(context)!.noConsentFound,
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
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: consents.length,
                itemBuilder: (context, index) {
                  return _buildAccountConsentDetailCard(
                      context,
                      consents[index],
                      state.activeSelfConsents.contains(consents[index]));
                },
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildAccountConsentDetailCard(
      BuildContext context, ConsentDetails consentInfo, bool isSelfConsent) {
    final subtitle = consentInfo.consentStatus == Constants.active
        ? AppLocalizations.of(context)!.expiresOn(
            FinvuDateUtils.format(consentInfo.consentDateTimeRange.to!))
        : AppLocalizations.of(context)!.requestedOn(
            FinvuDateUtils.format(consentInfo.consentDateTimeRange.from!));

    return ListTile(
      onTap: () {
        _goToConsentDetailsPage(context, consentInfo);
      },
      contentPadding: EdgeInsets.zero,
      tileColor: Colors.transparent,
      leading: isSelfConsent
          ? const Icon(
              Icons.person_outline,
              size: 35,
              color: Colors.grey,
            )
          : FinvuFipIcon(
              iconUri: consentInfo.entityInfo.entityIconUri ??
                  consentInfo.entityInfo.entityLogoUri,
              size: 35,
            ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isSelfConsent
                ? AppLocalizations.of(context)!.selfConsent
                : consentInfo.entityInfo.entityName,
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14,
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
      trailing: Container(
        decoration: BoxDecoration(
          border: consentInfo.consentStatus == Constants.revoked
              ? Border.all(color: Colors.redAccent)
              : Border.all(color: FinvuColors.green),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          consentInfo.consentStatus,
          style: TextStyle(
            color: consentInfo.consentStatus == Constants.revoked
                ? Colors.redAccent
                : Colors.green,
            fontSize: 10,
          ),
        ),
      ),
    );
  }

  void _goToConsentDetailsPage(BuildContext context, ConsentDetails consent) {
    final route = MaterialPageRoute(
      builder: (_) => BlocProvider.value(
        value: context.read<ConsentBloc>(),
        child: ConsentDetailsPage(consent: consent),
      ),
    );
    Navigator.push(context, route);
  }

  List<ConsentDetails> sortConsents(List<ConsentDetails> consents) {
    List<ConsentDetails> sortedConsents = List<ConsentDetails>.from(consents);
    sortedConsents.sort((a, b) =>
        b.consentDateTimeRange.to!.compareTo(a.consentDateTimeRange.to!));
    return sortedConsents;
  }
}
