import 'package:finvu_flutter_sdk/common/models/consent.dart';
import 'package:finvu_flutter_sdk/common/utils/finvu_colors.dart';
import 'package:finvu_flutter_sdk/common/utils/finvu_date_utils.dart';
import 'package:finvu_flutter_sdk/common/utils/ui_utils.dart';
import 'package:finvu_flutter_sdk/common/widgets/finvu_fip_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PendingConsentDetails extends StatelessWidget {
  const PendingConsentDetails({
    super.key,
    required this.consent,
  });

  final ConsentDetails consent;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.pendingConsentDetails,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            color: FinvuColors.black111111,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          AppLocalizations.of(context)!.followingBanksRequestedConsent,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: FinvuColors.grey81858F,
          ),
        ),
        const SizedBox(height: 20),
        _buildEntityDetailsWidget(context, consent),
        const SizedBox(height: 10),
        _buildConsentDetailsWidget(context, consent),
      ],
    );
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
      title: Text(
        consentInfo.entityInfo.entityName,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 14,
          color: FinvuColors.black111111,
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
}
