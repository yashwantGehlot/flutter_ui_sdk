import 'package:finvu_flutter_sdk/common/utils/finvu_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:finvu_flutter_sdk/l10n/app_localizations.dart';

class IdentifierInput extends StatelessWidget {
  const IdentifierInput({
    super.key,
    required this.identifierType,
    required this.onChanged,
    required this.localizations,
  });

  final String identifierType;
  final Function(String) onChanged;
  final AppLocalizations localizations;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextFormField(
      enableInteractiveSelection: false,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return localizations.required;
        }
        // Ref: https://incometaxindia.gov.in/Documents/about-pan.htm
        final panRegExp = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$');
        if (!panRegExp.hasMatch(value)) {
          return localizations.pleaseEnterValidPanCardNumber;
        }

        return null;
      },
      onChanged: (value) => onChanged(value.toUpperCase()),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
        TextInputFormatter.withFunction(
          (oldValue, newValue) => TextEditingValue(
            text: newValue.text.toUpperCase(),
            selection: newValue.selection,
          ),
        ),
      ],
      decoration: InputDecoration(
        enabledBorder: theme.inputDecorationTheme.enabledBorder ??
            const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(14),
              ),
              borderSide: BorderSide(color: FinvuColors.greyD8E1EE),
            ),
        focusedBorder: theme.inputDecorationTheme.focusedBorder ??
            const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(14),
              ),
              borderSide: BorderSide(color: FinvuColors.blue, width: 2),
            ),
        border: theme.inputDecorationTheme.border ??
            const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(14),
              ),
            ),
        labelText: identifierType,
        hintText: identifierType,
        labelStyle: theme.inputDecorationTheme.labelStyle,
        hintStyle: theme.inputDecorationTheme.hintStyle,
        contentPadding: theme.inputDecorationTheme.contentPadding,
      ),
    );
  }
}
