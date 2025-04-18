import 'package:finvu_flutter_sdk/common/utils/finvu_colors.dart';
import 'package:finvu_flutter_sdk/common/utils/url_utils.dart';
import 'package:finvu_flutter_sdk/l10n/app_localizations.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class FinvuScaffold extends StatelessWidget {
  final Widget child;
  final Widget? bottomSheet;

  const FinvuScaffold({super.key, required this.child, this.bottomSheet});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const FinvuHeader(),
            Expanded(child: child),
            FinvuFooter(),
          ],
        ),
      ),
      bottomSheet: bottomSheet,
    );
  }
}

class FinvuHeader extends StatelessWidget {
  const FinvuHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      width: double.infinity,
      color: Colors.white,
      child: Row(
        children: [
          const Icon(Icons.arrow_back, size: 24), // or your app logo/icon

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              "Finvu",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.left,
            ),
          ),

          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              // TODO: implement Help button
            },
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              // TODO: implement Exit/Close button
            },
          ),
        ],
      ),
    );
  }
}

class FinvuFooter extends StatelessWidget {
  FinvuFooter({super.key});
  final Uri _termsAndConditionsUrl = Uri.parse('https://finvu.in/terms');

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      color: Colors.white,
      width: double.infinity,
      alignment: Alignment.center,
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: AppLocalizations.of(context)!.accept,
              style: const TextStyle(color: FinvuColors.black1D1B20),
            ),
            const TextSpan(
              text: " ",
              style: TextStyle(color: FinvuColors.black1D1B20),
            ),
            TextSpan(
              text: AppLocalizations.of(context)!.termsAndConditions,
              style: const TextStyle(color: FinvuColors.blue),
              recognizer: TapGestureRecognizer()
                ..onTap = () => launch(_termsAndConditionsUrl),
            ),
          ],
        ),
      ),
    );
  }
}
