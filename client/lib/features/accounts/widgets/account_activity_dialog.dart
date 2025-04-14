import 'package:finvu_flutter_sdk/common/utils/finvu_colors.dart';
import 'package:finvu_flutter_sdk/common/utils/finvu_date_utils.dart';
import 'package:finvu_flutter_sdk/common/widgets/finvu_dialog.dart';
import 'package:finvu_flutter_sdk/common/widgets/finvu_fip_icon.dart';
import 'package:finvu_flutter_sdk/common/models/linked_account_with_fip.dart';
import 'package:flutter/material.dart';
import 'package:finvu_flutter_sdk/l10n/app_localizations.dart';

class AccountActivityDialog extends StatelessWidget {
  const AccountActivityDialog({
    super.key,
    required this.account,
  });

  final LinkedAccountInfo account;

  @override
  Widget build(BuildContext context) {
    return FinvuDialog(
      title: AppLocalizations.of(context)!.accountActivity,
      content: Column(
        children: [
          ListTile(
            tileColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            leading: FinvuFipIcon(
              iconUri: account.fipInfo.productIconUri,
              size: 40,
            ),
            title: Text(
              account.fipName,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: FinvuColors.black111111,
              ),
            ),
            subtitle: Text(
              "${account.accountType} ${account.maskedAccountNumber}",
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: FinvuColors.grey81858F,
              ),
            ),
          ),
          const Divider(
            height: 36,
            thickness: 1.5,
            color: FinvuColors.greyE1E4EF,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                FinvuDateUtils.format(account.linkedAccountUpdateTimestamp!),
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
          )
        ],
      ),
    );
  }
}
