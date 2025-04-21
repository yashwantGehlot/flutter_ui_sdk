import 'package:finvu_flutter_sdk/common/utils/finvu_colors.dart';
import 'package:finvu_flutter_sdk/common/utils/url_utils.dart';
import 'package:finvu_flutter_sdk/common/widgets/exit_dialog.dart';
import 'package:finvu_flutter_sdk/finvu_ui_manager.dart';
import 'package:finvu_flutter_sdk/l10n/app_localizations.dart';
import 'package:finvu_flutter_sdk_core/finvu_ui_initialization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

class FinvuHeader extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onExit;

  const FinvuHeader({Key? key, this.onExit}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Image(
        image: NetworkImage(
          FinvuUIManager().sdkConfig.logoUrl,
        ),
        width: 120,
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.help_outline),
          onPressed: () {
            // TODO: implement Help button
          },
        ),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () async {
            final shouldExit = await exitDialog(context);
            if (shouldExit) {
              // ✅ This will always pop the root FinvuApp from the stack
              Navigator.of(context, rootNavigator: true).pop(false);

              // Optionally still call onExit if parent needs to handle something
              onExit?.call();
            }
          },
        ),
      ],
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
      width: double.infinity,
      alignment: Alignment.center,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RichText(
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
              SizedBox(
                width: 5,
              ),
              const Image(
                image: AssetImage(
                  'lib/assets/finvu_logo.png',
                  package: 'finvu_flutter_sdk',
                ),
                height: 40,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
