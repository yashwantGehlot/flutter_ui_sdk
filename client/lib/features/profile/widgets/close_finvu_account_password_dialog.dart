import 'package:finvu_flutter_sdk/common/widgets/finvu_dialog.dart';
import 'package:finvu_flutter_sdk/common/widgets/passcode_input.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class CloseFinvuAccountPasswordDialog extends StatefulWidget {
  final Function(String)? onSubmit;

  const CloseFinvuAccountPasswordDialog({super.key, this.onSubmit});

  @override
  State<CloseFinvuAccountPasswordDialog> createState() =>
      _CloseFinvuAccountPasswordDialogState();
}

class _CloseFinvuAccountPasswordDialogState
    extends State<CloseFinvuAccountPasswordDialog> {
  String passcode = '';

  void _updatePasscode(String newPasscode) {
    setState(() {
      passcode = newPasscode;
    });
  }

  void _submitPasscode() {
    if (widget.onSubmit != null) {
      widget.onSubmit!(passcode);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return FinvuDialog(
      title: AppLocalizations.of(context)!.closeAAAccount,
      subtitle: [
        TextSpan(text: AppLocalizations.of(context)!.enterPin),
      ],
      content: PasscodeInput(
        onChanged: _updatePasscode,
        label: AppLocalizations.of(context)!.pin,
      ),
      buttonText: AppLocalizations.of(context)!.deleteAAAccount,
      onPressed: _submitPasscode,
      dismissible: true,
      textAlign: TextAlign.left,
    );
  }
}
