import 'package:finvu_flutter_sdk/common/utils/finvu_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:finvu_flutter_sdk/l10n/app_localizations.dart';

class PasscodeInput extends StatefulWidget {
  const PasscodeInput({
    super.key,
    this.label,
    this.hint,
    this.onChanged,
    this.controller,
  });

  final Function(String)? onChanged;
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  @override
  State<PasscodeInput> createState() => _PasscodeInputState();
}

class _PasscodeInputState extends State<PasscodeInput> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(4)
      ],
      enableInteractiveSelection: false,
      onChanged: widget.onChanged != null
          ? (value) {
              if (widget.onChanged != null) {
                widget.onChanged!(value.trim());
              }
            }
          : null,
      obscureText: _obscureText,
      decoration: InputDecoration(
        suffixIcon: InkWell(
          onTap: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
          child: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(14),
          ),
          borderSide: BorderSide(color: FinvuColors.greyD8E1EE),
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(14)),
        ),
        labelText: widget.label ?? AppLocalizations.of(context)!.pin,
        hintText: widget.hint ??
            widget.label ??
            AppLocalizations.of(context)!.enterPin,
      ),
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
    );
  }
}
