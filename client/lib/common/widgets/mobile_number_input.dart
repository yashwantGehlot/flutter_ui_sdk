import 'package:finvu_flutter_sdk/common/utils/finvu_colors.dart';
import 'package:finvu_flutter_sdk/common/widgets/finvu_input_style_config.dart';
import 'package:finvu_flutter_sdk/finvu_ui_manager.dart';
import 'package:flutter/material.dart';
import 'package:finvu_flutter_sdk/l10n/app_localizations.dart';

class MobileNumberInput extends StatelessWidget {
  const MobileNumberInput({
    super.key,
    required this.onChanged,
  });

  final Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = FinvuUIManager().uiConfig?.inputDecorationTheme ??
        Theme.of(context).inputDecorationTheme;

    return TextField(
      keyboardType: TextInputType.phone,
      onChanged: (value) {
        onChanged(value.trim());
      },
      enableInteractiveSelection: false,
      decoration: InputDecoration(
        enabledBorder: theme.enabledBorder ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: FinvuColors.greyD8E1EE),
            ),
        focusedBorder: theme.focusedBorder ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: FinvuColors.blue, width: 2),
            ),
        border: theme.border ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
        labelText: AppLocalizations.of(context)!.mobileNumber,
        hintText: AppLocalizations.of(context)!.mobileNumber,
        labelStyle: theme.labelStyle,
        hintStyle: theme.hintStyle,
        contentPadding: theme.contentPadding,
      ),
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
    );
  }
}
