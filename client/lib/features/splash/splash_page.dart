import 'package:finvu_flutter_sdk/common/utils/analytics_events.dart';
import 'package:finvu_flutter_sdk/common/utils/update_utils.dart';
import 'package:finvu_flutter_sdk/common/widgets/base_page.dart';
import 'package:finvu_flutter_sdk/common/widgets/finvu_dialog.dart';
import 'package:finvu_flutter_sdk/features/auth/login/login_page.dart';
import 'package:finvu_flutter_sdk/features/splash/bloc/splash_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finvu_flutter_sdk/l10n/app_localizations.dart';
import 'package:otpless_flutter/otpless_flutter.dart';

class SplashPage extends BasePage {
  const SplashPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const SplashPage(),
    );
  }

  @override
  State<SplashPage> createState() => _SplashPageState();

  @override
  String routeName() {
    return FinvuScreens.splashPage;
  }
}

class _SplashPageState extends BasePageState<SplashPage> {
  @override
  void initState() {
    super.initState();
    var otplessFlutterPlugin = Otpless();
    otplessFlutterPlugin.initHeadless("TY1MBN9BFM4D9HJOS8M3");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => SplashBloc()..add(SplashLoading()),
        child: BlocListener<SplashBloc, SplashState>(
          listener: (context, state) async {
            if (!context.mounted) {
              return;
            }
            if (state is SplashNavigateLogin) {
              final Route<void> route =
                  LoginPage.route(LoginType.aaHandlePasscode);
              Navigator.of(context)
                  .pushAndRemoveUntil(route, (Route<dynamic> route) => false);
              return;
            }
          },
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}

Future<void> goToStore() async {
  await UpdateUtils.goToStore();
}

void _showForceUpdateDialog(BuildContext context) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (_) {
      return FinvuDialog(
        dismissible: false,
        textAlign: TextAlign.center,
        title: AppLocalizations.of(context)!.forceUpdateTitle,
        subtitle: [
          TextSpan(text: AppLocalizations.of(context)!.forceUpdateSubtitle),
        ],
        buttonText: AppLocalizations.of(context)!.okay,
        content: Container(),
        onPressed: goToStore,
      );
    },
  );
}
