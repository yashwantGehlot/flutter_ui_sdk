import 'dart:async';
import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:finvu_flutter_sdk/common/utils/security_utils.dart';
import 'package:finvu_flutter_sdk/common/widgets/mobile_number_input.dart';
import 'package:finvu_flutter_sdk/common/widgets/otp_input.dart';
import 'package:finvu_flutter_sdk/common/widgets/finvu_dialog.dart';
import 'package:finvu_flutter_sdk/features/auth/login/bloc/login_bloc.dart';
import 'package:finvu_flutter_sdk/features/auth/login/login_page.dart';
import 'package:finvu_flutter_sdk/features/main/main_page.dart';
import 'package:finvu_flutter_sdk/common/utils/finvu_colors.dart';
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
      if (state.status == LoginStatus.loggedIn) {
        Navigator.of(context).pushAndRemoveUntil(
            MainPage.route(state.aaHandle), (Route<dynamic> route) => false);
      } else if (state.status == LoginStatus.connectionEstablished) {
        context.read<LoginBloc>().add(const LoginMobileNumberSubmitted());
      } else if (state.status == LoginStatus.error) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(
                AppLocalizations.of(context)!.loginFailed,
              ),
            ),
          );
      } else if (state.status == LoginStatus.otpSent) {
        _startResendOtpTimer();
      }
    }, builder: (context, state) {
      final List<Widget> children = [];
      children.add(const Padding(padding: EdgeInsets.only(top: 40)));

      final showOtpInput = (state.status == LoginStatus.otpSent ||
          state.status == LoginStatus.isAuthenticatingOtp);

      final String headerText = showOtpInput
          ? AppLocalizations.of(context)!.verifyOtp
          : AppLocalizations.of(context)!.signIn;

      children.add(Text(headerText,
          style: const TextStyle(
              fontSize: 20,
              color: FinvuColors.black1D1B20,
              fontWeight: FontWeight.bold)));

      children.add(const Padding(padding: EdgeInsets.only(top: 35)));

      if (showOtpInput) {
        children.add(_OtpInput());
        children.add(const Padding(padding: EdgeInsets.only(top: 15)));
        children.add(_buildResendOtpWidget(context));
      } else {
        children.add(_MobileNumberInput());
      }

      children.add(const Padding(padding: EdgeInsets.only(top: 25)));

      if (showOtpInput) {
        children.add(_SubmitButton());
      } else {
        children.add(_GetOtpButton());
        children.addAll([
          const Padding(padding: EdgeInsets.only(top: 20)),
          _buildOrWidget(context),
          _buildUsePasscodeToSignInWidget(context),
        ]);
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      );
    });
  }

  Widget _buildOrWidget(BuildContext context) {
    return Row(children: [
      const Expanded(
          child: Divider(
        indent: 50,
        endIndent: 10,
      )),
      Text(AppLocalizations.of(context)!.or),
      const Expanded(
          child: Divider(
        indent: 10,
        endIndent: 50,
      ))
    ]);
  }

  Widget _buildUsePasscodeToSignInWidget(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: TextButton(
        style: TextButton.styleFrom(
            textStyle: const TextStyle(fontWeight: FontWeight.bold)),
        onPressed: () => Navigator.pushAndRemoveUntil(
          context,
          LoginPage.route(LoginType.aaHandlePasscode),
          (Route<dynamic> route) => false,
        ),
        child: Text(AppLocalizations.of(context)!.usePinToSignIn),
      ),
    );
  }

  Widget _buildResendOtpWidget(BuildContext context) {
    if (_enableResend) {
      return InkWell(
        onTap: () {
          // TODO: resend OTP
          _startResendOtpTimer();
          setState(() {
            _resendOtpSecondsRemaining = 60;
            _enableResend = false;
          });
        },
        child: Text(
          AppLocalizations.of(context)!.resendOtp,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: FinvuColors.blue,
          ),
        ),
      );
    }

    return Row(children: [
      Text(AppLocalizations.of(context)!.resendOtpIn),
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

class _MobileNumberInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) =>
          previous.mobileNumber != current.mobileNumber,
      builder: (context, state) {
        return MobileNumberInput(
          onChanged: (mobileNumber) => context
              .read<LoginBloc>()
              .add(LoginMobileNumberChanged(mobileNumber)),
        );
      },
    );
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
        );
      },
    );
  }
}

class _GetOtpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        if (state.status == LoginStatus.isSendingOtp) {
          return const Align(
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          );
        }

        return ElevatedButton(
            style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(48)),
            onPressed: state.status == LoginStatus.unknown
                ? () {
                    context.read<LoginBloc>().add(InitializeEvent());
                  }
                : null,
            child: Text(AppLocalizations.of(context)!.getOtp));
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
          return const Align(
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          );
        }

        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(48),
          ),
          onPressed: (state.status == LoginStatus.otpSent)
              ? () async {
                  try {
                    final currentContext = context;
                    bool isSecure = await SecurityUtils.isSecureLockEnabled();
                    if (!currentContext.mounted) {
                      return;
                    }
                    if (!isSecure) {
                      _showSecureErrorDialog(
                          context,
                          AppLocalizations.of(context)!.securityError,
                          AppLocalizations.of(context)!
                              .securityPasscodeLockErrorDescription,
                          true);
                    } else {
                      currentContext
                          .read<LoginBloc>()
                          .add(const LoginAAHandlePasscodeSubmitted());
                    }
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
