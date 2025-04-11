import 'dart:async';

import 'package:finvu_flutter_sdk/common/models/finvu_error.dart';
import 'package:finvu_flutter_sdk/common/utils/error_utils.dart';
import 'package:finvu_flutter_sdk/common/widgets/aa_handle_input.dart';
import 'package:finvu_flutter_sdk/common/widgets/mobile_number_input.dart';
import 'package:finvu_flutter_sdk/common/widgets/otp_input.dart';
import 'package:finvu_flutter_sdk/common/widgets/passcode_input.dart';
import 'package:finvu_flutter_sdk/features/auth/login/login_page.dart';
import 'package:finvu_flutter_sdk/features/auth/recovery/bloc/recovery_bloc.dart';
import 'package:finvu_flutter_sdk/features/auth/recovery/widgets/aa_handles_list_dialog.dart';
import 'package:finvu_flutter_sdk/features/deviceBinding/device_binding_page.dart';
import 'package:finvu_flutter_sdk/features/main/main_page.dart';
import 'package:finvu_flutter_sdk/common/utils/finvu_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ForgotAaHandleOrPasscodeForm extends StatefulWidget {
  const ForgotAaHandleOrPasscodeForm({super.key});

  @override
  State<ForgotAaHandleOrPasscodeForm> createState() =>
      _ForgotAaHandleOrPasscodeFormState();
}

class _ForgotAaHandleOrPasscodeFormState
    extends State<ForgotAaHandleOrPasscodeForm> {
  int _resendOtpSecondsRemaining = 60;
  bool _enableResend = false;
  Timer? _resendOtpTimer;
  bool hasRetriedLogin = false;

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
    return BlocConsumer<RecoveryBloc, RecoveryState>(
        listener: (context, state) {
      if (state.status == RecoveryStatus.connectionEstablished) {
        context.read<RecoveryBloc>().add(const RecoveryGetOtpClicked(false));
      } else if (state.status == RecoveryStatus.needAuthentication) {
        Navigator.of(context).push(
          Devicebindingpage.route(state.mobileNumber, state.aaHandle),
        );
      } else if (state.status == RecoveryStatus.loggedIn) {
        Navigator.pushAndRemoveUntil(
          context,
          MainPage.route(state.aaHandle),
          (Route<dynamic> route) => false,
        );
      } else if (state.status == RecoveryStatus.error) {
        if (state.error?.code == FinvuErrorCode.authLoginRetry &&
            !hasRetriedLogin) {
          context.read<RecoveryBloc>().add(const LoginWithRecoveredAaHandle());
          setState(() {
            hasRetriedLogin = true;
          });
        } else {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  ErrorUtils.getErrorMessage(
                    context,
                    state.error,
                    returnRawMessage: true,
                  ),
                ),
              ),
            );
        }
      } else if (state.status == RecoveryStatus.otpSent) {
        _startResendOtpTimer();
      } else if (state.status == RecoveryStatus.userIdsFound) {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => AAHandlesListDialog(
            mobileNumber: state.mobileNumber,
            list: state.userIds,
            onOkay: () {
              Navigator.of(context).pushAndRemoveUntil(
                  LoginPage.route(LoginType.aaHandlePasscode),
                  (Route<dynamic> route) => false);
            },
          ),
        );
      }
    }, builder: (context, state) {
      final List<Widget> children = [];
      children.add(const Padding(padding: EdgeInsets.only(top: 40)));

      final showOtpInput = (state.status == RecoveryStatus.otpSent ||
          state.status == RecoveryStatus.isResendingOtp ||
          state.status == RecoveryStatus.isVerifyingOtp);

      final String headerText = showOtpInput
          ? state.type == RecoveryType.aaHandle
              ? AppLocalizations.of(context)!.verifyOtp
              : AppLocalizations.of(context)!.verifyOtpAndSetPin
          : AppLocalizations.of(context)!.forgot;

      children.add(
        Text(
          headerText,
          style: const TextStyle(
              fontSize: 20,
              color: FinvuColors.black1D1B20,
              fontWeight: FontWeight.bold),
        ),
      );

      children.add(const Padding(padding: EdgeInsets.only(top: 35)));

      if (showOtpInput) {
        children.add(_OtpInput());
        children.add(const Padding(padding: EdgeInsets.only(top: 15)));
        children.add(_buildResendOtpWidget(context));
        if (state.type != RecoveryType.aaHandle) {
          children.add(const Padding(padding: EdgeInsets.only(top: 25)));
          children.add(_NewPasscodeInput());
          children.add(const Padding(padding: EdgeInsets.only(top: 25)));
          children.add(_ConfirmNewPasscodeInput());
          children
              .add(_PasscodeMismatchError(isError: !state.doesPasscodeMatch));
        }
      } else {
        children.add(const _ForgotAaHandleOrPasscodeWidget());
        children.add(const Padding(padding: EdgeInsets.only(top: 25)));
        children.add(_MobileNumberInput());
        if (state.type == RecoveryType.passcode) {
          children.add(const Padding(padding: EdgeInsets.only(top: 25)));
          children.add(_AAHandleInput());
        }

        children.add(const Padding(padding: EdgeInsets.only(top: 25)));
        children.add(_buildMobileNumberNoteWidget(context));
      }

      children.add(const Padding(padding: EdgeInsets.only(top: 25)));

      if (showOtpInput) {
        children.add(_SubmitButton());
      } else {
        children.add(_GetOtpButton());
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      );
    });
  }

  Widget _buildResendOtpWidget(BuildContext context) {
    if (_enableResend) {
      return BlocBuilder<RecoveryBloc, RecoveryState>(
          builder: (context, state) {
        return InkWell(
          onTap: () {
            _startResendOtpTimer();
            setState(() {
              _resendOtpSecondsRemaining = 60;
              _enableResend = false;
            });

            context.read<RecoveryBloc>().add(const RecoveryGetOtpClicked(true));
          },
          child: Text(
            AppLocalizations.of(context)!.resendOtp,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: FinvuColors.blue,
            ),
          ),
        );
      });
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

  Widget _buildMobileNumberNoteWidget(BuildContext context) {
    return Container(
      height: 45,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(14)),
          color: FinvuColors.greyF3F5FD),
      child: Center(
        child: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text(
              AppLocalizations.of(context)!
                  .enterMobileNumberLinkedToFinvuAAHandle,
              style:
                  const TextStyle(color: FinvuColors.grey81858F, fontSize: 12),
            ),
          ),
        ),
      ),
    );
  }
}

class _AAHandleInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecoveryBloc, RecoveryState>(
      buildWhen: (previous, current) => previous.aaHandle != current.aaHandle,
      builder: (context, state) {
        return AAHandleInput(
          onChanged: (aaHandle) => context
              .read<RecoveryBloc>()
              .add(RecoveryAAHandleChanged(aaHandle)),
        );
      },
    );
  }
}

class _MobileNumberInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecoveryBloc, RecoveryState>(
      buildWhen: (previous, current) =>
          previous.mobileNumber != current.mobileNumber,
      builder: (context, state) {
        return MobileNumberInput(
          onChanged: (mobileNumber) => context
              .read<RecoveryBloc>()
              .add(RecoveryMobileNumberChanged(mobileNumber)),
        );
      },
    );
  }
}

class _OtpInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecoveryBloc, RecoveryState>(
      buildWhen: (previous, current) => previous.otp != current.otp,
      builder: (context, state) {
        return OtpInput(
          onChanged: (otp) =>
              context.read<RecoveryBloc>().add(RecoveryOTPChanged(otp)),
        );
      },
    );
  }
}

class _ForgotAaHandleOrPasscodeWidget extends StatefulWidget {
  const _ForgotAaHandleOrPasscodeWidget();

  @override
  State<_ForgotAaHandleOrPasscodeWidget> createState() =>
      _ForgotAaHandleOrPasscodeWidgetState();
}

class _ForgotAaHandleOrPasscodeWidgetState
    extends State<_ForgotAaHandleOrPasscodeWidget> {
  RecoveryType _recoveryType = RecoveryType.aaHandle;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecoveryBloc, RecoveryState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildRadioButtonWidget(
              context,
              AppLocalizations.of(context)!.aaHandle,
              RecoveryType.aaHandle,
            ),
            const Padding(
              padding: EdgeInsets.only(right: 25),
            ),
            _buildRadioButtonWidget(
              context,
              AppLocalizations.of(context)!.pin,
              RecoveryType.passcode,
            ),
          ],
        );
      },
    );
  }

  Widget _buildRadioButtonWidget(
    BuildContext context,
    String title,
    RecoveryType type,
  ) {
    return Expanded(
      child: InkWell(
        onTap: () => _handleRadioButtonChanged(context, type),
        borderRadius: const BorderRadius.all(Radius.circular(14)),
        child: DecoratedBox(
          decoration: BoxDecoration(
              border: Border.all(
                color: FinvuColors.greyD8E1EE,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(14))),
          child: Row(
            children: [
              const Padding(padding: EdgeInsets.only(left: 20)),
              Text(
                title,
                style: const TextStyle(
                    color: FinvuColors.black1D1B20,
                    fontWeight: FontWeight.bold),
              ),
              Radio<RecoveryType>(
                value: type,
                groupValue: _recoveryType,
                onChanged: (RecoveryType? value) =>
                    _handleRadioButtonChanged(context, type),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleRadioButtonChanged(BuildContext context, RecoveryType type) {
    switch (type) {
      case RecoveryType.aaHandle:
        context.read<RecoveryBloc>().add(const RecoveryForgotAaHandleClicked());
        break;
      case RecoveryType.passcode:
        context.read<RecoveryBloc>().add(const RecoveryForgotPasscodeClicked());
        break;
    }
    setState(() {
      _recoveryType = type;
    });
  }
}

class _GetOtpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecoveryBloc, RecoveryState>(
      builder: (context, state) {
        if (state.status == RecoveryStatus.isSendingOtp) {
          return const Align(
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          );
        }

        return ElevatedButton(
            style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(48)),
            onPressed: (state.status == RecoveryStatus.unknown ||
                    state.status == RecoveryStatus.error)
                ? () {
                    context.read<RecoveryBloc>().add(InitializeEvent());
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
    return BlocBuilder<RecoveryBloc, RecoveryState>(
      builder: (context, state) {
        if (state.status == RecoveryStatus.isVerifyingOtp ||
            state.status == RecoveryStatus.isResendingOtp) {
          return const Align(
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          );
        }

        return ElevatedButton(
            style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(48)),
            onPressed: (state.status == RecoveryStatus.otpSent ||
                    state.status == RecoveryStatus.error)
                ? () {
                    context
                        .read<RecoveryBloc>()
                        .add(const RecoveryOTPSubmitted());
                  }
                : null,
            child: Text(AppLocalizations.of(context)!.submit));
      },
    );
  }
}

class _NewPasscodeInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecoveryBloc, RecoveryState>(
      buildWhen: (previous, current) =>
          previous.newPasscode != current.newPasscode,
      builder: (context, state) {
        return PasscodeInput(
          onChanged: (passcode) => context
              .read<RecoveryBloc>()
              .add(RecoveryNewPasscodeChanged(passcode)),
        );
      },
    );
  }
}

class _ConfirmNewPasscodeInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecoveryBloc, RecoveryState>(
      buildWhen: (previous, current) =>
          previous.confirmNewPasscode != current.confirmNewPasscode,
      builder: (context, state) {
        return PasscodeInput(
          onChanged: (passcode) => context
              .read<RecoveryBloc>()
              .add(RecoveryConfirmNewPasscodeChanged(passcode)),
          label: AppLocalizations.of(context)!.confirmPin,
        );
      },
    );
  }
}

class _PasscodeMismatchError extends StatelessWidget {
  final bool isError;

  const _PasscodeMismatchError({
    required this.isError,
  });

  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: isError,
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            AppLocalizations.of(context)!.pinsDoNotMatch,
            style: const TextStyle(
              color: Colors.red,
              fontSize: 12,
            ),
          ),
        ));
  }
}
