import 'package:finvu_flutter_sdk/common/utils/finvu_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:finvu_flutter_sdk/l10n/app_localizations.dart';

class DoBInput extends StatefulWidget {
  const DoBInput({
    super.key,
    required this.onChanged,
    required this.localizations,
  });

  final Function(String) onChanged;
  final AppLocalizations localizations;

  @override
  State<DoBInput> createState() => _DoBInputState();
}

class _DoBInputState extends State<DoBInput> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextFormField(
      keyboardType: TextInputType.datetime,
      controller: _controller,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return widget.localizations.required;
        }
        return null;
      },
      onTap: () {
        showDatePicker(
          context: context,
          initialDate: DateTime(1990),
          firstDate: DateTime(1925),
          lastDate: DateTime.now(),
        ).then((selectedDate) {
          if (selectedDate != null) {
            String formattedDate =
                DateFormat('yyyy-MM-dd').format(selectedDate);
            _controller.text = formattedDate;
            widget.onChanged(formattedDate);
          }
        });
      },
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
        labelText: widget.localizations.dateOfBirth,
        hintText: widget.localizations.dateOfBirth,
        labelStyle: theme.inputDecorationTheme.labelStyle,
        hintStyle: theme.inputDecorationTheme.hintStyle,
        suffixIcon: const Icon(Icons.calendar_month),
      ),
    );
  }
}
