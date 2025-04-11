import 'package:finvu_flutter_sdk/common/utils/url_utils.dart';
import 'package:finvu_flutter_sdk/common/widgets/aa_handle_input.dart';
import 'package:finvu_flutter_sdk/common/widgets/finvu_auth_upsell_page.dart';
import 'package:finvu_flutter_sdk/common/widgets/mobile_number_input.dart';
import 'package:finvu_flutter_sdk/common/widgets/passcode_input.dart';
import 'package:finvu_flutter_sdk/features/auth/login/login_page.dart';
import 'package:finvu_flutter_sdk/features/auth/registration/bloc/registration_bloc.dart';
import 'package:finvu_flutter_sdk/common/utils/finvu_colors.dart';
import 'package:finvu_flutter_sdk/features/auth/registration/widgets/user_registered_dialog.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegistrationForm extends StatelessWidget {
  const RegistrationForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegistrationBloc, RegistrationState>(
        listener: (context, state) {
      if (state.status == RegistrationStatus.success) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(
                AppLocalizations.of(context)!.pleaseVerifyYourMobileNumber,
              ),
            ),
          );
        Navigator.pushAndRemoveUntil(
          context,
          LoginPage.route(LoginType.aaHandlePasscode),
          (Route<dynamic> route) => false,
        );
      } else if (state.status == RegistrationStatus.connectionEstablished) {
        context
            .read<RegistrationBloc>()
            .add(const RegistrationRegisterClicked());
      } else if (state.status == RegistrationStatus.emptyFields) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(
                (state.aaHandle.isEmpty ||
                        state.mobileNumber.isEmpty ||
                        state.passcode.isEmpty ||
                        state.confirmPasscode.isEmpty)
                    ? AppLocalizations.of(context)!.pleaseEnterAllFields
                    : AppLocalizations.of(context)!
                        .pleaseAcceptTermsAndConditions,
              ),
            ),
          );
      } else if (state.status == RegistrationStatus.error) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(
                AppLocalizations.of(context)!.registrationFailed,
              ),
            ),
          );
      }
    }, builder: (context, state) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(padding: EdgeInsets.only(top: 40)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.register,
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
          _MobileNumberInput(),
          const Padding(padding: EdgeInsets.only(top: 25)),
          _AAHandleInput(),
          const Padding(padding: EdgeInsets.only(top: 25)),
          _PasscodeInput(),
          const Padding(padding: EdgeInsets.only(top: 25)),
          _ConfirmPasscodeInput(),
          const Padding(padding: EdgeInsets.only(top: 10)),
          _PasscodeMismatchError(isError: !state.doesPasscodeMatch),
          const Padding(padding: EdgeInsets.only(top: 10)),
          _TermsCheckbox(
            isError: !state.didAcceptTerms &&
                state.status == RegistrationStatus.emptyFields,
          ),
          const Padding(padding: EdgeInsets.only(top: 15)),
          _RegisterButton(),
          const Padding(padding: EdgeInsets.only(top: 15)),
          _buildSignInWidget(context),
        ],
      );
    });
  }

  Widget _buildSignInWidget(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: TextButton(
        style: TextButton.styleFrom(
            textStyle: const TextStyle(fontWeight: FontWeight.bold)),
        onPressed: () => Navigator.pop(context),
        child: Text(AppLocalizations.of(context)!.alreadyAUserSignIn),
      ),
    );
  }
}

void _showUserRegisteredDialog(BuildContext context) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (_) {
      return BlocProvider.value(
        value: context.read<RegistrationBloc>(),
        child: const UserRegisteredDialog(),
      );
    },
  );
}

class _MobileNumberInput extends StatelessWidget {
  @override
  Widget build(Object context) {
    return BlocBuilder<RegistrationBloc, RegistrationState>(
      buildWhen: (previous, current) =>
          previous.mobileNumber != current.mobileNumber,
      builder: (context, state) {
        return MobileNumberInput(
          onChanged: (mobileNumber) => context
              .read<RegistrationBloc>()
              .add(RegistrationMobileNumberChanged(mobileNumber)),
        );
      },
    );
  }
}

class _AAHandleInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegistrationBloc, RegistrationState>(
      buildWhen: (previous, current) => previous.aaHandle != current.aaHandle,
      builder: (context, state) {
        return AAHandleInput(
          onChanged: (aaHandle) => context
              .read<RegistrationBloc>()
              .add(RegistrationAAHandleChanged(aaHandle)),
        );
      },
    );
  }
}

class _PasscodeInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegistrationBloc, RegistrationState>(
      buildWhen: (previous, current) => previous.passcode != current.passcode,
      builder: (context, state) {
        return PasscodeInput(
          onChanged: (passcode) => context
              .read<RegistrationBloc>()
              .add(RegistrationPasscodeChanged(passcode)),
        );
      },
    );
  }
}

class _ConfirmPasscodeInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegistrationBloc, RegistrationState>(
      buildWhen: (previous, current) =>
          previous.confirmPasscode != current.confirmPasscode,
      builder: (context, state) {
        return PasscodeInput(
          onChanged: (passcode) => context
              .read<RegistrationBloc>()
              .add(RegistrationConfirmPasscodeChanged(passcode)),
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

class _TermsCheckbox extends StatefulWidget {
  final bool isError;
  const _TermsCheckbox({
    required this.isError,
  });

  @override
  State<_TermsCheckbox> createState() => _TermsCheckboxState();
}

class _TermsCheckboxState extends State<_TermsCheckbox> {
  bool isChecked = false;
  final Uri _termsAndConditionsUrl = Uri.parse('https://finvu.in/terms');

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: isChecked,
          isError: widget.isError,
          onChanged: (bool? value) {
            context
                .read<RegistrationBloc>()
                .add(RegistrationTermsAcceptanceChanged(value!));
            setState(() {
              isChecked = value;
            });
          },
        ),
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
      ],
    );
  }
}

class _RegisterButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegistrationBloc, RegistrationState>(
      builder: (context, state) {
        if (state.status == RegistrationStatus.isRegistering) {
          return const Align(
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          );
        }

        return ElevatedButton(
            style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(48)),
            onPressed: (state.status == RegistrationStatus.unknown ||
                    state.status == RegistrationStatus.error)
                ? () {
                    context
                        .read<RegistrationBloc>()
                        .add(const InitializeEvent());
                  }
                : null,
            child: Text(AppLocalizations.of(context)!.registerAccount));
      },
    );
  }
}
