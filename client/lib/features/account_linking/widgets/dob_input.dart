import 'package:finvu_flutter_sdk/common/utils/finvu_colors.dart';
import 'package:flutter/material.dart';
import 'package:finvu_flutter_sdk/l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class DoBInput extends StatefulWidget {
  const DoBInput({super.key, required this.onChanged});

  final Function(String) onChanged;

  @override
  State<DoBInput> createState() => _DoBInputState();
}

class _DoBInputState extends State<DoBInput> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.datetime,
      controller: _controller,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return AppLocalizations.of(context)!.required;
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
        labelText: AppLocalizations.of(context)!.dateOfBirth,
        hintText: AppLocalizations.of(context)!.dateOfBirth,
        suffixIcon: const Icon(Icons.calendar_month),
      ),
    );
  }
}
