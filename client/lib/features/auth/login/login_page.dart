import 'package:finvu_flutter_sdk/common/models/finvu_error.dart';
import 'package:finvu_flutter_sdk/common/utils/analytics_events.dart';
import 'package:finvu_flutter_sdk/common/utils/error_utils.dart';
import 'package:finvu_flutter_sdk/common/widgets/base_page.dart';
import 'package:finvu_flutter_sdk/common/widgets/finvu_auth_header.dart';
import 'package:finvu_flutter_sdk/common/widgets/finvu_scaffold.dart';
import 'package:finvu_flutter_sdk/features/auth/login/bloc/login_bloc.dart';
import 'package:finvu_flutter_sdk/features/auth/login/views/mobile_number_otp_form.dart';
import 'package:finvu_flutter_sdk/common/utils/finvu_colors.dart';
import 'package:finvu_flutter_sdk/finvu_ui_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finvu_flutter_sdk/l10n/app_localizations.dart';

enum LoginType { mobileNumberOTP }

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
    final mobileNumber = FinvuUIManager.instance.loginConfig.mobileNumber;
    final aaHandle = '$mobileNumber@finvu';
    final consentHandleId = FinvuUIManager.instance.loginConfig.consentHandleId;

    return Scaffold(
      body: SafeArea(
        child: FinvuScaffold(
          child: Padding(
            padding: const EdgeInsets.only(left: 25, right: 25),
            child: BlocProvider(
              create: (_) => LoginBloc()
                ..add(
                  InitializeEvent(
                    mobileNumber: mobileNumber,
                    aaHandle: aaHandle,
                    consentHandleId: consentHandleId,
                  ),
                ),
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
      ),
      // bottomNavigationBar: _buildRegistrationButtonWidget(context),
    );
  }

  Widget getForm() {
    switch (widget.loginType) {
      case LoginType.mobileNumberOTP:
        return const MobileNumberOTPForm();
      default:
        throw UnimplementedError('${widget.loginType} not implemented');
    }
  }
}
