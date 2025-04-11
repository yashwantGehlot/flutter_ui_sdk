import 'package:finvu_flutter_sdk/common/utils/finvu_colors.dart';
import 'package:finvu_flutter_sdk/common/utils/url_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileDisclaimerBanner extends StatelessWidget {
  const ProfileDisclaimerBanner({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final Uri knowMoreUrl = Uri.parse('https://finvu.in/');

    return Container(
      margin: const EdgeInsets.only(left: 25, right: 25, bottom: 25),
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
          color: FinvuColors.greyF3F5FD,
          borderRadius: BorderRadius.all(Radius.circular(16))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Image(
            image: AssetImage('lib/assets/finvu_logo.png'),
            width: 120,
          ),
          const Padding(padding: EdgeInsets.only(top: 12)),
          Text(
            AppLocalizations.of(context)!.loginDisclaimer,
            style: const TextStyle(color: FinvuColors.grey81858F, fontSize: 9),
          ),
          const Padding(padding: EdgeInsets.only(top: 12)),
          InkWell(
            onTap: () {
              launch(knowMoreUrl);
            },
            child: Row(
              children: [
                Text(
                  AppLocalizations.of(context)!.knowMoreAboutFinvu,
                  style: const TextStyle(
                      color: FinvuColors.blue,
                      fontSize: 12,
                      fontWeight: FontWeight.w800),
                ),
                const Icon(
                  Icons.arrow_right_alt_sharp,
                  size: 24,
                  color: FinvuColors.blue,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
