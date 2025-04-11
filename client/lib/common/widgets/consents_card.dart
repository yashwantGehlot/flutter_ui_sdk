import 'package:dotted_border/dotted_border.dart';
import 'package:finvu_flutter_sdk/common/models/consent.dart';
import 'package:finvu_flutter_sdk/common/utils/constants.dart';
import 'package:finvu_flutter_sdk/common/utils/finvu_colors.dart';
import 'package:finvu_flutter_sdk/common/utils/finvu_date_utils.dart';
import 'package:finvu_flutter_sdk/common/widgets/finvu_fip_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ConsentsCard extends StatelessWidget {
  const ConsentsCard({
    super.key,
    required this.title,
    required this.primaryButtonTitle,
    required this.secondaryButtonTitle,
    required this.consents,
    required this.showAll,
    required this.onPrimaryButtonClicked,
    required this.onSecondaryButtonClicked,
    this.onViewAllClicked,
  });

  final String title;
  final String primaryButtonTitle;
  final String? secondaryButtonTitle;
  final bool showAll;
  final List<ConsentDetails> consents;
  final Function(ConsentDetails) onPrimaryButtonClicked;
  final Function(ConsentDetails)? onSecondaryButtonClicked;
  final Function()? onViewAllClicked;

  @override
  Widget build(BuildContext context) {
    if (consents.isEmpty) {
      return const SizedBox.shrink();
    }

    consents.sort((a, b) =>
        b.consentDateTimeRange.from!.compareTo(a.consentDateTimeRange.from!));

    final consentsToShow = showAll ? consents : [consents.first];

    return ListView.builder(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: consentsToShow.length,
      itemBuilder: (context, index) {
        final consentInfo = consentsToShow[index];
        return Card(
          color: Colors.white,
          surfaceTintColor: Colors.transparent,
          child: Padding(
            padding: EdgeInsets.only(
              left: 15,
              right: 15,
              bottom: 15,
              top: index == 0 ? 0 : 5,
            ),
            child: Column(
              children: [
                (!showAll && index == 0)
                    ? _buildHeaderWidget(context, title, consents)
                    : const SizedBox.shrink(),
                _buildEntityDetailsWidget(context, consentInfo),
                _buildSeparater(),
                const SizedBox(height: 15),
                _buildConsentDetailsWidget(context, consentInfo),
                const SizedBox(height: 15),
                _buildSeparater(),
                const SizedBox(height: 15),
                _buildConsentButtons(context, consentInfo)
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildConsentButtons(
    BuildContext context,
    ConsentDetails consentInfo,
  ) {
    return Row(
      children: [
        if (secondaryButtonTitle != null)
          Expanded(
            child: OutlinedButton(
              child: Text(secondaryButtonTitle!),
              onPressed: () => onSecondaryButtonClicked!(consentInfo),
            ),
          ),
        if (secondaryButtonTitle != null) const SizedBox(width: 20),
        Expanded(
          child: ElevatedButton(
            child: Text(primaryButtonTitle),
            onPressed: () => onPrimaryButtonClicked(consentInfo),
          ),
        ),
      ],
    );
  }

  Widget _buildSeparater() {
    return DottedBorder(
      padding: EdgeInsets.zero,
      dashPattern: const [2, 5],
      color: FinvuColors.greyE1E4EF,
      child: SizedBox.fromSize(
        size: const Size(double.infinity, 0),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.purpose,
                style: const TextStyle(
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                consentInfo.consentPurposeInfo.text,
                style: const TextStyle(
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.accountInformation,
                style: const TextStyle(
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 5),
              Wrap(
                spacing: 3,
                runSpacing: 5,
                children: consentInfo.consentDisplayDescriptions
                    .map(
                      (desc) => Chip(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        color: const MaterialStatePropertyAll(Colors.white),
                        surfaceTintColor: Colors.transparent,
                        padding: const EdgeInsets.all(1),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          side: BorderSide(
                            color: FinvuColors.greyE1E4EF,
                          ),
                        ),
                        labelStyle: const TextStyle(fontSize: 12),
                        label: Text(
                          desc,
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEntityDetailsWidget(
    BuildContext context,
    ConsentDetails consentInfo,
  ) {
    final subtitle = consentInfo.consentStatus == Constants.active
        ? AppLocalizations.of(context)!.expiresOn(
            FinvuDateUtils.format(consentInfo.consentDateTimeRange.to!))
        : AppLocalizations.of(context)!.requestedOn(
            FinvuDateUtils.format(consentInfo.consentDateTimeRange.from!));
    return ListTile(
      tileColor: Colors.white,
      leading: FinvuFipIcon(
        iconUri: consentInfo.entityInfo.entityIconUri ??
            consentInfo.entityInfo.entityLogoUri,
        size: 35,
      ),
      title: Text(
        consentInfo.entityInfo.entityName,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 14,
          color: FinvuColors.black111111,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 12,
          color: FinvuColors.grey81858F,
        ),
      ),
    );
  }

  Widget _buildHeaderWidget(
    BuildContext context,
    String title,
    List<ConsentDetails> consents,
  ) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(
                top: showAll ? 12 : 0, bottom: showAll ? 12 : 0),
            child: Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                const Padding(padding: EdgeInsets.only(left: 5)),
                CircleAvatar(
                  backgroundColor: FinvuColors.greyF3F5FD,
                  radius: 12,
                  child: Text(
                    consents.length.toString(),
                    style: const TextStyle(
                      color: FinvuColors.grey81858F,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: !showAll,
            child: TextButton(
              style: TextButton.styleFrom(padding: const EdgeInsets.all(0)),
              onPressed: () {
                if (onViewAllClicked != null) {
                  onViewAllClicked!();
                }
              },
              child: Text(
                AppLocalizations.of(context)!.viewAll,
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 12,
                  color: FinvuColors.blue,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
