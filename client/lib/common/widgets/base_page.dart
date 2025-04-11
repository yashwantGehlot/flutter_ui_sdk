import 'package:finvu_flutter_sdk/common/utils/analytics_utils.dart';
import 'package:finvu_flutter_sdk/common/widgets/finvu_dialog.dart';
import 'package:finvu_flutter_sdk/common/widgets/named_route.dart';
import 'package:finvu_flutter_sdk/features/splash/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

abstract class BasePage extends StatefulWidget implements NamedRoute {
  const BasePage({super.key});
}

abstract class BasePageState<Page extends BasePage> extends State<Page> {
  @override
  void initState() {
    super.initState();
    FinvuAnalytics.logScreenView(widget.routeName());
  }

  void handleSessionExpired(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) {
        return FinvuDialog(
          dismissible: false,
          title: AppLocalizations.of(context)!.sessionExpired,
          subtitle: [
            TextSpan(
              text: AppLocalizations.of(context)!.sessionExpiredLoginToContinue,
            ),
          ],
          content: const SizedBox.shrink(),
          buttonText: AppLocalizations.of(context)!.okay,
          onPressed: () async {
            if (!mounted) {
              return;
            }

            try {
              await Navigator.pushAndRemoveUntil(
                context,
                SplashPage.route(),
                (Route<dynamic> route) => false,
              );
            } catch (e) {
              if (mounted) {
                Navigator.pop(context);
              }
            }
          },
        );
      },
    );
  }

  void goToSplashScreen() {
    Navigator.pushAndRemoveUntil(
      context,
      SplashPage.route(),
      (Route<dynamic> route) => false,
    );
  }
}
