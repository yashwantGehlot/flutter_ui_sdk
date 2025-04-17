import 'package:finvu_flutter_sdk/common/widgets/finvu_dialog.dart';
import 'package:flutter/material.dart';
import 'package:finvu_flutter_sdk/l10n/app_localizations.dart';

class AddNewMobileNumberDialog extends StatelessWidget {
  final Function(String) onDialogButtonPressed;
  final String subtitle;
  const AddNewMobileNumberDialog({
    super.key,
    required this.onDialogButtonPressed,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    TextEditingController mobileNumberController = TextEditingController();
    return FinvuDialog(
      title: AppLocalizations.of(context)!.enterMobileNumber,
      subtitle: [
        TextSpan(
          text: subtitle,
        ),
      ],
      content: TextField(
        controller: mobileNumberController,
        keyboardType: TextInputType.phone,
        decoration: const InputDecoration(labelText: 'Mobile Number'),
        enableInteractiveSelection: false,
      ),
      buttonText: AppLocalizations.of(context)!.submit,
      onPressed: () {
        String mobileNumber = mobileNumberController.text;
        onDialogButtonPressed(mobileNumber);
        Navigator.of(context).pop();
      },
    );
  }
}
