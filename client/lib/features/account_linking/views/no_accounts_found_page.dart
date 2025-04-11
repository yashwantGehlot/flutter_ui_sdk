import 'package:finvu_flutter_sdk/common/utils/constants.dart';
import 'package:finvu_flutter_sdk/common/utils/finvu_colors.dart';
import 'package:finvu_flutter_sdk/common/utils/ui_utils.dart';
import 'package:finvu_flutter_sdk/common/widgets/finvu_fip_icon.dart';
import 'package:finvu_flutter_sdk/common/widgets/finvu_page_header.dart';
import 'package:finvu_flutter_sdk_core/finvu_fip_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NoAccountsFoundPage extends StatelessWidget {
  final String mobileNumber;
  final FinvuFIPInfo fip;

  const NoAccountsFoundPage(
      {super.key, required this.mobileNumber, required this.fip});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UIUtils.getFinvuAppBar(),
      backgroundColor: FinvuColors.lightBlue,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FinvuPageHeader(
            title: AppLocalizations.of(context)!.noAccountFound,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: FinvuColors.grey81858F,
                    ),
                    children: [
                      TextSpan(
                          text: AppLocalizations.of(context)!
                              .noAccountsFoundAssociatedWith),
                      const TextSpan(text: ": "),
                      TextSpan(
                        text: mobileNumber,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: FinvuColors.black111111,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 24),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        FinvuFipIcon(
                          iconUri: fip.productIconUri,
                          size: 30,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          fip.productName ?? "",
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  AppLocalizations.of(context)!.noAccountsDiscoveredReason1,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: FinvuColors.black111111,
                  ),
                ),
                Text(
                  AppLocalizations.of(context)!.noAccountsDiscoveredReason2,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: FinvuColors.black111111,
                  ),
                ),
                Text(
                  AppLocalizations.of(context)!.noAccountsDiscoveredReason3,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: FinvuColors.black111111,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
