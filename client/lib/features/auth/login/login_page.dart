import 'package:finvu_flutter_sdk/common/models/finvu_error.dart';
import 'package:finvu_flutter_sdk/common/utils/analytics_events.dart';
import 'package:finvu_flutter_sdk/common/utils/error_utils.dart';
import 'package:finvu_flutter_sdk/common/widgets/base_page.dart';
import 'package:finvu_flutter_sdk/common/widgets/finvu_auth_header.dart';
import 'package:finvu_flutter_sdk/features/auth/login/bloc/login_bloc.dart';
import 'package:finvu_flutter_sdk/features/auth/login/views/aa_handle_passcode_form.dart';
import 'package:finvu_flutter_sdk/features/auth/login/views/mobile_number_otp_form.dart';
import 'package:finvu_flutter_sdk/common/utils/finvu_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finvu_flutter_sdk/l10n/app_localizations.dart';

enum LoginType { aaHandlePasscode, mobileNumberOTP }

class LoginPage extends BasePage {
  const LoginPage({super.key, required this.loginType});

  final LoginType loginType;

  static Route<void> route(final LoginType loginType) {
    return MaterialPageRoute<void>(
      builder: (_) => LoginPage(
        loginType: loginType,
      ),
    );
  }

  @override
  State<LoginPage> createState() => _LoginPageState();

  @override
  String routeName() {
    return FinvuScreens.loginPage;
  }
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 25, right: 25),
          child: BlocProvider(
            create: (_) => LoginBloc(),
            child: BlocListener<LoginBloc, LoginState>(
              listener: (context, state) {
                if (state.status == LoginStatus.error) {
                  if (state.error?.code ==
                      FinvuErrorCode.sslPinningFailureError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          ErrorUtils.getErrorMessage(
                            context,
                            state.error,
                          ),
                        ),
                      ),
                    );
                  }
                }
              },
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const FinvuAuthHeader(),
                    getForm(),
                    const Padding(padding: EdgeInsets.only(top: 30)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildRegistrationButtonWidget(context),
    );
  }

  Widget getForm() {
    switch (widget.loginType) {
      case LoginType.aaHandlePasscode:
        return const AAHandlePasscodeForm();
      case LoginType.mobileNumberOTP:
        return const MobileNumberOTPForm();
      default:
        throw UnimplementedError('${widget.loginType} not implemented');
    }
  }

  Widget _buildRegistrationButtonWidget(BuildContext context) {
    return FilledButton.tonal(
      style: const ButtonStyle(
          padding:
              MaterialStatePropertyAll(EdgeInsets.only(bottom: 30, top: 30)),
          shape: MaterialStatePropertyAll(RoundedRectangleBorder()),
          backgroundColor: MaterialStatePropertyAll(FinvuColors.lightBlue),
          foregroundColor: MaterialStatePropertyAll(FinvuColors.blue)),
      onPressed: () => {},
      child: Text(AppLocalizations.of(context)!.doNotHaveFinvuAccountRegister),
    );
  }
}
