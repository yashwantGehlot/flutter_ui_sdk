import 'package:finvu_flutter_sdk/common/widgets/finvu_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class ConfirmFinvuAccountCloseDialog extends StatelessWidget {
  final Function() onSubmit;

  const ConfirmFinvuAccountCloseDialog({super.key, required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return FinvuDialog(
      title: AppLocalizations.of(context)!.closeAAAccount,
      subtitle: [
        TextSpan(
          text: AppLocalizations.of(context)!.areYouSure,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
      content: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppLocalizations.of(context)!.consentsWillBeRevoked),
          Text(AppLocalizations.of(context)!.accountsWillBeDelinked),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                onSubmit();
              },
              child: Text(AppLocalizations.of(context)!.yes),
            ),
          )
        ],
      ),
      dismissible: true,
      textAlign: TextAlign.left,
    );
  }
}
