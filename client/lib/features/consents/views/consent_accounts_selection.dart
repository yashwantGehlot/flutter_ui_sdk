import 'package:finvu_flutter_sdk/common/models/consent.dart';
import 'package:finvu_flutter_sdk/common/models/linked_account_with_fip.dart';
import 'package:finvu_flutter_sdk/common/utils/constants.dart';
import 'package:finvu_flutter_sdk/common/utils/finvu_colors.dart';
import 'package:finvu_flutter_sdk/common/utils/finvu_date_utils.dart';
import 'package:finvu_flutter_sdk/common/utils/ui_utils.dart';
import 'package:finvu_flutter_sdk/common/widgets/finvu_fip_icon.dart';
import 'package:finvu_flutter_sdk/features/account_linking/account_linking_page.dart';
import 'package:finvu_flutter_sdk/features/consents/bloc/consent_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finvu_flutter_sdk/l10n/app_localizations.dart';

class ConsentAccountsSelection extends StatefulWidget {
  const ConsentAccountsSelection({
    super.key,
    required this.consent,
  });

  final ConsentDetails consent;

  @override
  State<ConsentAccountsSelection> createState() =>
      _ConsentAccountsSelectionState();
}

class _ConsentAccountsSelectionState extends State<ConsentAccountsSelection> {
  List<LinkedAccountInfo> _selectedAccounts = [];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConsentBloc, ConsentState>(
      builder: (context, state) {
        if (state.status == ConsentStatus.isFetchingLinkedAccounts) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return Card(
          color: Colors.white,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderWidget(context, state.linkedAccounts),
                const SizedBox(height: 5),
                _buildAccountsListWidget(state.linkedAccounts),
                const SizedBox(height: 15),
                _buildApproveConsentButton(context, state.status),
                const SizedBox(height: 15),
                _buildRejectConsentButton(context, state.status),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeaderWidget(
    BuildContext context,
    List<LinkedAccountInfo> linkedAccounts,
  ) {
    final areAllAccountsSelected =
        _selectedAccounts.length == linkedAccounts.length;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          AppLocalizations.of(context)!.chooseAccounts,
          style: const TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        TextButton(
          style: TextButton.styleFrom(padding: const EdgeInsets.all(0)),
          onPressed: () {
            setState(() {
              _selectedAccounts = areAllAccountsSelected ? [] : linkedAccounts;
            });
          },
          child: Text(
            areAllAccountsSelected
                ? AppLocalizations.of(context)!.deselectAll.toUpperCase()
                : AppLocalizations.of(context)!.selectAll.toUpperCase(),
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 12,
              color: FinvuColors.blue,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAccountsListWidget(List<LinkedAccountInfo> linkedAccounts) {
    return Column(
      children: linkedAccounts
          .where((account) =>
              widget.consent.fiTypes?.contains(account.fiType) ?? false)
          .map((account) => _buildLinkedAccountWidget(account))
          .toList(),
    );
  }

  Widget _buildLinkedAccountWidget(
    LinkedAccountInfo account,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        tileColor: FinvuColors.greyF3F5FD,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        leading: FinvuFipIcon(
          iconUri: account.fipInfo.productIconUri,
          size: 35,
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
        trailing: SizedBox(
          width: 24,
          height: 24,
          child: Checkbox.adaptive(
            value: _selectedAccounts.contains(account),
            activeColor: FinvuColors.blue,
            onChanged: (value) {
              setState(() {
                if (value!) {
                  _selectedAccounts.add(account);
                } else {
                  _selectedAccounts.remove(account);
                }
              });
            },
          ),
        ),
      ),
    );
  }

  Widget _buildConsentDetailsWidget(
    BuildContext context,
    ConsentDetails consentInfo,
  ) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 15,
      mainAxisSpacing: 15,
      childAspectRatio: 1.5,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildInfoCard(
          AppLocalizations.of(context)!.frequency,
          AppLocalizations.of(context)!.informationFetchedTimes(
            consentInfo.consentDataFrequency.value.toInt(),
            consentInfo.consentDataFrequency.unit.toLowerCase(),
          ),
        ),
        _buildInfoCard(
          AppLocalizations.of(context)!.purpose,
          consentInfo.consentPurposeInfo.text,
        ),
        _buildInfoCard(
          AppLocalizations.of(context)!.consentFromDate,
          FinvuDateUtils.formatToDate(
            consentInfo.consentDateTimeRange.from!,
          ),
        ),
        _buildInfoCard(
          AppLocalizations.of(context)!.consentExpiresOn,
          FinvuDateUtils.formatToDate(
            consentInfo.consentDateTimeRange.to!,
          ),
        ),
        _buildInfoCard(
          AppLocalizations.of(context)!.accountInformation,
          consentInfo.consentDisplayDescriptions
              .map((val) => UIUtils.toSentenceCase(val))
              .join(", "),
        ),
        _buildInfoCard(
          AppLocalizations.of(context)!.dataStoredUntil,
          "${consentInfo.consentDataLifePeriod.value.toInt()} ${consentInfo.consentDataLifePeriod.unit.toLowerCase()}",
        ),
        _buildInfoCard(
          AppLocalizations.of(context)!.dataFromDate,
          FinvuDateUtils.formatToDate(
            consentInfo.dataDateTimeRange.from!,
          ),
        ),
        _buildInfoCard(
          AppLocalizations.of(context)!.dataToDate,
          FinvuDateUtils.formatToDate(
            consentInfo.dataDateTimeRange.to!,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
      ),
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

  Widget _buildApproveConsentButton(
      BuildContext context, ConsentStatus status) {
    if (status == ConsentStatus.isApprovingConsent) {
      return const Align(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      );
    }

    return ElevatedButton(
      onPressed: () {
        if (_selectedAccounts.isEmpty) {
          return;
        }

        context.read<ConsentBloc>().add(
              ConsentApprove(
                consent: widget.consent,
                selectedAccounts: _selectedAccounts,
              ),
            );
      },
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(48),
      ),
      child: Text(
        AppLocalizations.of(context)!.approveConsent,
      ),
    );
  }

  Widget _buildRejectConsentButton(BuildContext context, ConsentStatus status) {
    if (status == ConsentStatus.isRejectingConsent) {
      return const Align(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      );
    }

    return OutlinedButton(
      onPressed: () {
        context.read<ConsentBloc>().add(ConsentReject(consent: widget.consent));
      },
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(48),
      ),
      child: Text(
        AppLocalizations.of(context)!.reject,
      ),
    );
  }

  Widget _buildAddMoreAccountsButtonWidget(BuildContext context) {
    return TextButton(
      onPressed: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AccountLinkingPage(),
          ),
        );
        if (context.mounted && result != null && result is String) {
          if (result == Constants.linkingSuccessful) {
            context.read<ConsentBloc>().add(const LinkedAccountsRefresh());
          }
        }
      },
      child: Text(
        "+ ${AppLocalizations.of(context)!.addMoreAccounts}",
      ),
    );
  }
}
