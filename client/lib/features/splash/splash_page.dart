import 'package:finvu_flutter_sdk/common/utils/analytics_events.dart';
import 'package:finvu_flutter_sdk/common/utils/update_utils.dart';
import 'package:finvu_flutter_sdk/common/widgets/base_page.dart';
import 'package:finvu_flutter_sdk/common/widgets/finvu_dialog.dart';
import 'package:finvu_flutter_sdk/features/auth/login/login_page.dart';
import 'package:finvu_flutter_sdk/features/splash/bloc/splash_bloc.dart';
import 'package:finvu_flutter_sdk/finvu_ui_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finvu_flutter_sdk/l10n/app_localizations.dart';

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
                  LoginPage.route(LoginType.mobileNumberOTP);
              Navigator.of(context)
                  .pushAndRemoveUntil(route, (Route<dynamic> route) => false);
              return;
            }
          },
          child: Center(
            child: FinvuUIManager().uiConfig?.loderWidget ??
                const CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
