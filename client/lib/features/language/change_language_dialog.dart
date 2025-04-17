import 'package:finvu_flutter_sdk/common/utils/analytics_events.dart';
import 'package:finvu_flutter_sdk/common/utils/constants.dart';
import 'package:finvu_flutter_sdk/common/widgets/base_page.dart';
import 'package:finvu_flutter_sdk/common/widgets/finvu_dialog.dart';
import 'package:finvu_flutter_sdk/features/language/language_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finvu_flutter_sdk/l10n/app_localizations.dart';

class ChangeLanguageDialog extends BasePage {
  const ChangeLanguageDialog({super.key});

  @override
  State<ChangeLanguageDialog> createState() => _ChangeLanguageDialogState();

  @override
  String routeName() {
    return FinvuScreens.changeLanguageDialog;
  }
}

class _ChangeLanguageDialogState extends State<ChangeLanguageDialog> {
  @override
  Widget build(BuildContext context) {
    return FinvuDialog(
      title: AppLocalizations.of(context)!.changeLanguage,
      content: BlocBuilder<LanguageCubit, Locale?>(
        builder: (context, selectedLocale) {
          return Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: AppLocalizations.supportedLocales.length,
              itemBuilder: (context, index) {
                final currentLocale = AppLocalizations.supportedLocales[index];
                final isSelected = selectedLocale == currentLocale;
                return ListTile(
                  title: Text(Constants
                      .languageCodeToNameMap[currentLocale.languageCode]!),
                  onTap: () {
                    context.read<LanguageCubit>().changeLanguage(currentLocale);
                    Navigator.of(context).pop();
                  },
                  selected: isSelected,
                  trailing: isSelected ? const Icon(Icons.check) : null,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
