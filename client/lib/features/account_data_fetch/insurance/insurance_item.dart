import 'package:finvu_flutter_sdk/common/models/fi_models/account.dart';
import 'package:finvu_flutter_sdk/common/models/linked_account_with_fip.dart';
import 'package:finvu_flutter_sdk/common/utils/finvu_colors.dart';
import 'package:finvu_flutter_sdk/common/widgets/finvu_fip_icon.dart';
import 'package:finvu_flutter_sdk/features/account_data_fetch/insurance/insurance_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Widget insuranceItem(
    BuildContext context, FIAccount account, LinkedAccountInfo accountInfo) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: ListTile(
      tileColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      leading: const FinvuFipIcon(
        iconUri: "",
        size: 35,
      ),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            accountInfo.fipName,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 15,
              color: FinvuColors.black1D1B20,
            ),
          ),
          const Spacer(),
          Text(
            "#${account.insurance?.summary.policyNumber}",
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
              color: FinvuColors.grey81858F,
            ),
          ),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                account.insurance!.summary.policyType.toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: FinvuColors.grey81858F,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Text(
                "₹${account.insurance?.summary.coverAmount.toString()}",
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 22,
                  color: FinvuColors.blue,
                ),
              ),
              const Spacer(),
              SizedBox(
                height: 30,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InsuranceDetail(
                          summary: account.insurance!.summary,
                        ),
                      ),
                    );
                  },
                  child: Text(AppLocalizations.of(context)!.viewDetails),
                ),
              ),
            ],
          )
        ],
      ),
    ),
  );
}
