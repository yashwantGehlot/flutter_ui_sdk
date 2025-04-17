import 'package:finvu_flutter_sdk/common/utils/finvu_colors.dart';
import 'package:finvu_flutter_sdk/finvu_ui_manager.dart';
import 'package:flutter/material.dart';
import 'package:finvu_flutter_sdk/l10n/app_localizations.dart';

class AAHandleInput extends StatelessWidget {
  const AAHandleInput({super.key, required this.onChanged});

  final Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    const padding = 25;
    final width = (MediaQuery.of(context).size.width) - (2 * padding);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          width: (3 * (width / 4)),
          child: TextField(
            onChanged: (String text) => {onChanged("${text.trim()}@finvu")},
            enableInteractiveSelection: false,
            onTapOutside: (event) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            decoration: (() {
              final theme = FinvuUIManager().uiConfig?.inputDecorationTheme ??
                  Theme.of(context).inputDecorationTheme;

              return InputDecoration(
                labelText: AppLocalizations.of(context)!.aaHandle,
                hintText: AppLocalizations.of(context)!.aaHandle,
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
          ),
        ),
        SizedBox(
          width: (width / 4),
          child: const Padding(
            padding: EdgeInsets.only(left: 15),
            child: Text("@finvu"),
          ),
        ),
      ],
    );
  }
}
