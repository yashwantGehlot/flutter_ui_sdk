import 'package:finvu_flutter_sdk/finvu_ui_manager.dart';
import 'package:flutter/material.dart';
import 'package:finvu_flutter_sdk/l10n/app_localizations.dart';

class AccountAddUpsellBanner extends StatelessWidget {
  const AccountAddUpsellBanner({
    super.key,
    required this.onPressedAddAccount,
  });

  final VoidCallback onPressedAddAccount;

  @override
  Widget build(BuildContext context) {
    final uiConfig = FinvuUIManager().uiConfig;
    final theme = Theme.of(context);

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 120),
        child: SizedBox(
          width: double.infinity,
          child: Card(
            clipBehavior: Clip.hardEdge,
            surfaceTintColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                image: const DecorationImage(
                  image: AssetImage(
                    'lib/assets/finvu_add_account_upsell.png',
                    package: 'finvu_flutter_sdk',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      // width: 250,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!
                                .accessAllFeaturesOnFinvu,
                            style: theme.textTheme.titleMedium,
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 5, bottom: 5),
                            child: Text(
                              AppLocalizations.of(context)!
                                  .addInsuranceEquityAndDeposits,
                              style: theme.textTheme.bodyMedium,
                            ),
                          ),
                          if (uiConfig?.isElevatedButton ?? true)
                            ElevatedButton(
                              style: theme.elevatedButtonTheme.style?.copyWith(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.white),
                                foregroundColor: MaterialStateProperty.all(
                                    uiConfig?.primaryColor),
                              ),
                              onPressed: onPressedAddAccount,
                              child: Text(
                                AppLocalizations.of(context)!.addNow,
                                style: TextStyle(
                                  fontFamily: uiConfig?.fontFamily,
                                ),
                              ),
                            )
                          else
                            OutlinedButton(
                              style: theme.outlinedButtonTheme.style?.copyWith(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.white),
                                foregroundColor: MaterialStateProperty.all(
                                    uiConfig?.primaryColor),
                                side: MaterialStateProperty.all(
                                  BorderSide(
                                      color: uiConfig?.primaryColor ??
                                          Colors.blue),
                                ),
                              ),
                              onPressed: onPressedAddAccount,
                              child: Text(
                                AppLocalizations.of(context)!.addNow,
                                style: TextStyle(
                                  fontFamily: uiConfig?.fontFamily,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
