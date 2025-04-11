import 'package:finvu_flutter_sdk/common/utils/finvu_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FinvuAuthHeader extends StatelessWidget {
  const FinvuAuthHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(padding: EdgeInsets.only(top: 25)),
        const Image(
          image: AssetImage('lib/assets/finvu_logo.png'),
          width: 120,
        ),
        const Padding(padding: EdgeInsets.only(top: 12)),
        Text(
          AppLocalizations.of(context)!.loginDisclaimer,
          style: const TextStyle(color: FinvuColors.grey81858F, fontSize: 9),
        ),
      ],
    );
  }
}
