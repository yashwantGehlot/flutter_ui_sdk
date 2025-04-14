import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:finvu_flutter_sdk/common/models/finvu_error.dart';
import 'package:finvu_flutter_sdk/common/utils/error_utils.dart';
import 'package:finvu_flutter_sdk/common/utils/security_utils.dart';
import 'package:finvu_flutter_sdk/common/widgets/aa_handle_input.dart';
import 'package:finvu_flutter_sdk/common/widgets/finvu_auth_upsell_page.dart';
import 'package:finvu_flutter_sdk/common/widgets/finvu_dialog.dart';
import 'package:finvu_flutter_sdk/common/widgets/passcode_input.dart';
import 'package:finvu_flutter_sdk/features/account_linking/widgets/add_new_mobile_number_dialog.dart';
import 'package:finvu_flutter_sdk/features/auth/login/bloc/login_bloc.dart';
import 'package:finvu_flutter_sdk/features/auth/login/widgets/otp_input_dialog_for_verify.dart';
import 'package:finvu_flutter_sdk/features/deviceBinding/device_binding_page.dart';
import 'package:finvu_flutter_sdk/features/main/main_page.dart';
import 'package:finvu_flutter_sdk/common/utils/finvu_colors.dart';
import 'package:finvu_flutter_sdk/popup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finvu_flutter_sdk/l10n/app_localizations.dart';

class AAHandlePasscodeForm extends StatefulWidget {
  const AAHandlePasscodeForm({super.key});

  @override
  State<AAHandlePasscodeForm> createState() => _AAHandlePasscodeFormState();
}

class _AAHandlePasscodeFormState extends State<AAHandlePasscodeForm> {
  bool hasRetriedLogin = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.status == LoginStatus.connectionEstablished) {
          context.read<LoginBloc>().add(const LoginAAHandlePasscodeSubmitted());
        } else if (state.status == LoginStatus.loggedIn) {
          Navigator.of(context).pushAndRemoveUntil(
              MainPage.route(state.aaHandle), (Route<dynamic> route) => false);
        } else if (state.status == LoginStatus.isSendingOtp) {
          _showOtpInputDialog(context, state.mobileNumber);
        } else if (state.status == LoginStatus.needAuthentication) {
          // Navigator.of(context).push(
          //   Devicebindingpage.route(state.mobileNumber, state.aaHandle),
          // );
        } else if (state.status == LoginStatus.mobileNumberVerified) {
          context.read<LoginBloc>().add(const LoginAAHandlePasscodeSubmitted());
        } else if (state.status == LoginStatus.invalidOtp) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  AppLocalizations.of(context)!.invalidOtp,
                ),
              ),
            );
        } else if (state.status == LoginStatus.error) {
          if (state.error?.code == FinvuErrorCode.authLoginRetry &&
              !hasRetriedLogin) {
            context
                .read<LoginBloc>()
                .add(const LoginAAHandlePasscodeSubmitted());
            setState(() {
              hasRetriedLogin = true;
            });
          } else if (state.error!.code ==
              FinvuErrorCode.authLoginVerifyMobileNumber) {
            _showAddMobileNumberDialog(context);
          } else {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(
                    ErrorUtils.getErrorMessage(context, state.error),
                  ),
                ),
              );
          }
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(padding: EdgeInsets.only(top: 40)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.signInUsingPin,
                style: const TextStyle(
                  fontSize: 20,
                  color: FinvuColors.black1D1B20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Ink(
                height: 30,
                width: 30,
                decoration: const ShapeDecoration(
                  color: FinvuColors.greyE1E4EF,
                  shape: CircleBorder(),
                ),
                child: IconButton(
                  icon: const Icon(Icons.question_mark_outlined),
                  color: FinvuColors.blue,
                  iconSize: 12,
                  onPressed: () {
                    Navigator.push(context, FinvuAuthUpsellPage.route());
                  },
                ),
              )
            ],
          ),
          const Padding(padding: EdgeInsets.only(top: 35)),
          _AAHandleInput(),
          const Padding(padding: EdgeInsets.only(top: 25)),
          _PasscodeInput(),
          _buildForgotPasscodeOrAAHandleWidget(context),
          const Padding(padding: EdgeInsets.only(top: 15)),
          _LoginButton(),
          const Padding(padding: EdgeInsets.only(top: 20)),
        ],
      ),
    );
  }

  Widget _buildForgotPasscodeOrAAHandleWidget(BuildContext context) {
    return Align(
        alignment: Alignment.centerRight,
        child: TextButton(
          style: TextButton.styleFrom(
              textStyle: const TextStyle(fontWeight: FontWeight.bold),
              foregroundColor: FinvuColors.grey81858F),
          onPressed: () {},
          // onPressed: () => Navigator.push(
          //   context,
          //   RecoveryPage.route(),
          // ),
          child: Text(AppLocalizations.of(context)!.forgotPinOrAAHandle),
        ));
  }
}

void _showOtpInputDialog(BuildContext context, String mobileNumber) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (_) {
      return BlocProvider.value(
        value: context.read<LoginBloc>(),
        child: OtpInputDialogForVerify(mobileNumber),
      );
    },
  );
}

void _showAddMobileNumberDialog(BuildContext context) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (_) {
      return BlocProvider.value(
        value: context.read<LoginBloc>(),
        child: AddNewMobileNumberDialog(
          onDialogButtonPressed: (mobileNumber) {
            context
                .read<LoginBloc>()
                .add(LoginMobileVerificationInitiated(mobileNumber));
          },
          subtitle: AppLocalizations.of(context)!.pleaseEnterLinkedMobileNumber,
        ),
      );
    },
  );
}

class _AAHandleInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.aaHandle != current.aaHandle,
      builder: (context, state) {
        return AAHandleInput(
          onChanged: (aaHandle) =>
              context.read<LoginBloc>().add(LoginAAHandleChanged(aaHandle)),
        );
      },
    );
  }
}

class _PasscodeInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.passcode != current.passcode,
      builder: (context, state) {
        return PasscodeInput(
          onChanged: (passcode) =>
              context.read<LoginBloc>().add(LoginPasscodeChanged(passcode)),
        );
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        if (state.status == LoginStatus.isAuthenticatingUsernamePasscode) {
          return const Align(
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          );
        }

        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(48),
          ),
          onPressed: () {
            PopupScreen().show(context).then((result) {
              print('Popup closed with result: $result');
            });
          },
          // onPressed: (state.status == LoginStatus.unknown ||
          //         state.status == LoginStatus.error)
          //     ? () async {
          //         try {
          //           final currentContext = context;
          //           bool isSecure = await SecurityUtils.isSecureLockEnabled();
          //           if (!currentContext.mounted) {
          //             return;
          //           }
          //           if (!isSecure) {
          //             _showSecureErrorDialog(
          //                 context,
          //                 AppLocalizations.of(context)!.securityError,
          //                 AppLocalizations.of(context)!
          //                     .securityPasscodeLockErrorDescription,
          //                 true);
          //           } else {
          //             bool isCompromised =
          //                 await SecurityUtils.isDeviceSecurityCompromised();

          //             if (!currentContext.mounted) {
          //               return;
          //             }

          //             if (isCompromised) {
          //               _showSecureErrorDialog(
          //                   context,
          //                   AppLocalizations.of(currentContext)!.securityError,
          //                   AppLocalizations.of(currentContext)!
          //                       .securityCompromisedErrorDescription,
          //                   false);
          //             } else {
          //               currentContext.read<LoginBloc>().add(InitializeEvent());
          //             }
          //           }
          //         } catch (error) {
          //           debugPrint('Error checking device security: $error');
          //         }
          //       }
          //     : null,
          child: Text(AppLocalizations.of(context)!.signIn),
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
