import 'package:finvu_flutter_sdk/common/utils/finvu_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AccountAddUpsellBanner extends StatelessWidget {
  const AccountAddUpsellBanner({
    super.key,
    required this.onPressedAddAccount,
  });

  final VoidCallback onPressedAddAccount;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 120),
        child: SizedBox(
          width: double.infinity,
          child: Card(
            clipBehavior: Clip.hardEdge,
            surfaceTintColor: Colors.white,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                image: const DecorationImage(
                  image: AssetImage('lib/assets/finvu_add_account_upsell.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 50),
                child: Container(
                  width: 50,
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 250,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!
                                  .accessAllFeaturesOnFinvu,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 5, bottom: 5),
                              child: Text(
                                AppLocalizations.of(context)!
                                    .addInsuranceEquityAndDeposits,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                foregroundColor: FinvuColors.blue,
                                backgroundColor: Colors.white, // Text color
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: onPressedAddAccount,
                              child: Text(AppLocalizations.of(context)!.addNow),
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
      ),
    );
  }
}
