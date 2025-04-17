import 'package:finvu_flutter_sdk/common/utils/finvu_colors.dart';
import 'package:finvu_flutter_sdk/common/widgets/finvu_dialog.dart';
import 'package:finvu_flutter_sdk/finvu_ui_manager.dart';
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
        decoration: (() {
          final theme = FinvuUIManager().uiConfig?.inputDecorationTheme ??
              Theme.of(context).inputDecorationTheme;

          return InputDecoration(
            labelText: AppLocalizations.of(context)!.mobileNumber,
            hintText: AppLocalizations.of(context)!.mobileNumber,
            enabledBorder: theme.enabledBorder ??
                const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(14)),
                  borderSide: BorderSide(color: FinvuColors.greyD8E1EE),
                ),
            focusedBorder: theme.focusedBorder ??
                const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(14)),
                  borderSide: BorderSide(color: FinvuColors.blue, width: 2),
                ),
            border: theme.border ??
                const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(14)),
                ),
            labelStyle: theme.labelStyle,
            hintStyle: theme.hintStyle,
            contentPadding: theme.contentPadding,
          );
        })(),
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
