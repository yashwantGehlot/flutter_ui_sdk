import 'package:finvu_flutter_sdk/common/utils/finvu_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:finvu_flutter_sdk/l10n/app_localizations.dart';

class OtpInput extends StatelessWidget {
  const OtpInput({
    super.key,
    required this.onChanged,
    this.inputFormatters = const [],
  });

  final Function(String) onChanged;
  final List<TextInputFormatter> inputFormatters;

  @override
  Widget build(BuildContext context) {
    final defaultInputFormatters = [FilteringTextInputFormatter.digitsOnly];

    return TextField(
      keyboardType: TextInputType.number,
      inputFormatters:
          inputFormatters.isEmpty ? defaultInputFormatters : inputFormatters,
      obscureText: false,
      enableInteractiveSelection: false,
      onChanged: (value) {
        onChanged(value.trim());
      },
      decoration: InputDecoration(
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(14),
          ),
          borderSide: BorderSide(color: FinvuColors.greyD8E1EE),
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(14),
          ),
        ),
        labelText: AppLocalizations.of(context)!.otp,
        hintText: AppLocalizations.of(context)!.enterOtp,
      ),
    );
  }
}
