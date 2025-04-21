import 'dart:async';
import 'dart:io';
import 'package:app_settings/app_settings.dart';
import 'package:finvu_flutter_sdk/common/widgets/otp_input.dart';
import 'package:finvu_flutter_sdk/common/widgets/finvu_dialog.dart';
import 'package:finvu_flutter_sdk/features/accounts/accounts_page.dart';
import 'package:finvu_flutter_sdk/features/auth/login/bloc/login_bloc.dart';
import 'package:finvu_flutter_sdk/common/utils/finvu_colors.dart';
import 'package:finvu_flutter_sdk/finvu_ui_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finvu_flutter_sdk/l10n/app_localizations.dart';

class MobileNumberOTPForm extends StatefulWidget {
  const MobileNumberOTPForm({super.key});

  @override
  State<MobileNumberOTPForm> createState() => _MobileNumberOTPFormState();
}

class _MobileNumberOTPFormState extends State<MobileNumberOTPForm> {
  int _resendOtpSecondsRemaining = 60;
  bool _enableResend = false;
  Timer? _resendOtpTimer;

  void _startResendOtpTimer() {
    if (_resendOtpTimer != null) {
      return;
    }
    _resendOtpTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendOtpSecondsRemaining != 0) {
        setState(() {
          _resendOtpSecondsRemaining--;
        });
      } else {
        setState(() {
          timer.cancel();
          _enableResend = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _resendOtpTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(listener: (context, state) {
      debugPrint('Login state: ${state.status}');
      if (state.status == LoginStatus.loggedIn) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute<void>(
              builder: (_) => const AccountsPage(),
            ),
            (Route<dynamic> route) => false);
      } else if (state.status == LoginStatus.connectionEstablished) {
        context.read<LoginBloc>().add(const LoginAAHandlePasscodeSubmitted());
      } else if (state.status == LoginStatus.error) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.loginFailed),
            ),
          );
      } else if (state.status == LoginStatus.otpSent) {
        _startResendOtpTimer();
      }
    }, builder: (context, state) {
      if (state.status == LoginStatus.isAuthenticatingUsernamePasscode ||
          (state.status == LoginStatus.unknown &&
              (state.mobileNumber.isEmpty &&
                  state.aaHandle.isEmpty &&
                  state.consentHandleId.isEmpty))) {
        return Center(
          child: FinvuUIManager().uiConfig?.loderWidget ??
              const CircularProgressIndicator(),
        );
      }
      final List<Widget> children = [];
      children.add(const Padding(padding: EdgeInsets.only(top: 40)));

      final String headerText = AppLocalizations.of(context)!.verifyOtp;

      children.add(
        Text(
          headerText,
          style: Theme.of(context).textTheme.headlineLarge,
        ),
      );

      children.add(const Padding(padding: EdgeInsets.only(top: 35)));

      children.add(_OtpInput());
      children.add(const Padding(padding: EdgeInsets.only(top: 15)));
      children.add(_buildResendOtpWidget(context));

      children.add(const Padding(padding: EdgeInsets.only(top: 25)));

      children.add(_SubmitButton());

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      );
    });
  }

  Widget _buildResendOtpWidget(BuildContext context) {
    if (_enableResend) {
      return InkWell(
        onTap: () {
          context.read<LoginBloc>().add(const LoginAAHandlePasscodeSubmitted());
          _startResendOtpTimer();
          setState(() {
            _resendOtpSecondsRemaining = 60;
            _enableResend = false;
          });
        },
        child: Text(
          AppLocalizations.of(context)!.resendOtp,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: FinvuUIManager().uiConfig!.currentColor,
                fontWeight: FontWeight.w400,
              ),
        ),
      );
    }

    return Row(children: [
      Text(AppLocalizations.of(context)!.resendOtpIn,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: FinvuUIManager().uiConfig!.primaryColor,
                fontWeight: FontWeight.w400,
              )),
      const Padding(padding: EdgeInsets.only(right: 4)),
      Text(
        _resendOtpSecondsRemaining.toString(),
        style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
      ),
      const Padding(padding: EdgeInsets.only(right: 2)),
      Text(
        AppLocalizations.of(context)!.secs,
        style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
      ),
    ]);
  }
}

class _OtpInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.otp != current.otp,
      builder: (context, state) {
        return OtpInput(
          onChanged: (otp) =>
              context.read<LoginBloc>().add(LoginOTPChanged(otp)),
          localizations: AppLocalizations.of(context)!,
        );
      },
    );
  }
}

class _SubmitButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        if (state.status == LoginStatus.isAuthenticatingOtp) {
          return Align(
            alignment: Alignment.center,
            child: FinvuUIManager().uiConfig?.loderWidget ??
                const CircularProgressIndicator(),
          );
        }

        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(48),
          ),
          onPressed: (state.status == LoginStatus.otpSent)
              ? () async {
                  try {
                    context.read<LoginBloc>().add(const LoginOTPSubmitted());
                  } catch (error) {
                    debugPrint('Error checking device security: $error');
                  }
                }
              : null,
          child: Text(AppLocalizations.of(context)!.submit),
        );
      },
    );
  }

  void _showSecureErrorDialog(BuildContext context, String title,
      String content, bool showSettingsButton) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentContext = context;
      showDialog(
        context: currentContext,
        builder: (context) => FinvuDialog(
          title: title,
          content: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(content),
              ),
              if (showSettingsButton)
                SizedBox(
                  width: double.maxFinite,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      AppSettingsType type = Platform.isIOS
                          ? AppSettingsType.settings
                          : AppSettingsType.lockAndPassword;
                      AppSettings.openAppSettings(type: type);
                    },
                    child:
                        Text(AppLocalizations.of(currentContext)!.goTOSettings),
                  ),
                ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.maxFinite,
                height: 48,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(AppLocalizations.of(context)!.okay),
                ),
              )
            ],
          ),
          dismissible: false,
        ),
      );
    });
  }
}
