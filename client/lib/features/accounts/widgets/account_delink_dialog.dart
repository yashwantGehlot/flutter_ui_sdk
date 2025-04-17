import 'package:finvu_flutter_sdk/common/utils/finvu_colors.dart';
import 'package:finvu_flutter_sdk/common/widgets/finvu_dialog.dart';
import 'package:finvu_flutter_sdk/common/widgets/finvu_fip_icon.dart';
import 'package:finvu_flutter_sdk/features/accounts/bloc/accounts_bloc.dart';
import 'package:finvu_flutter_sdk/common/models/linked_account_with_fip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finvu_flutter_sdk/l10n/app_localizations.dart';

class AccountDelinkDialog extends StatelessWidget {
  const AccountDelinkDialog({
    super.key,
    required this.account,
  });

  final LinkedAccountInfo account;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AccountsBloc, AccountsState>(
        listener: (context, state) {
      if (state.status == AccountsStatus.accountDelinked) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(
                AppLocalizations.of(context)!.delinkingSuccessful,
              ),
            ),
          );
        Navigator.pop(context);
      }
    }, builder: (context, state) {
      return FinvuDialog(
        title: AppLocalizations.of(context)!.delinkAccount,
        subtitle: [
          TextSpan(
            text: AppLocalizations.of(context)!.delinkAccountConfirmation,
          ),
        ],
        content: ListTile(
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
        buttonText: AppLocalizations.of(context)!.remove,
        isButtonLoading: state.status == AccountsStatus.isDelinkingAccount,
        onPressed: () {
          context.read<AccountsBloc>().add(AccountsDelink(account));
        },
      );
    });
  }
}
