import 'package:finvu_flutter_sdk/common/widgets/passcode_input.dart';
import 'package:finvu_flutter_sdk/features/auth/changePassword/bloc/change_password_bloc.dart';
import 'package:finvu_flutter_sdk/common/utils/finvu_colors.dart';
import 'package:finvu_flutter_sdk/features/splash/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChangePasswordForm extends StatefulWidget {
  const ChangePasswordForm({super.key});

  @override
  State<ChangePasswordForm> createState() => _ChangePasswordFormState();
}

String errorText = '';

class _ChangePasswordFormState extends State<ChangePasswordForm> {
  final TextEditingController currentPasscodeController =
      TextEditingController();
  final TextEditingController newPasscodeController = TextEditingController();
  final TextEditingController confirmPasscodeController =
      TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChangePasswordBloc, ChangePasswordState>(
        listener: (context, state) {
      if (state.status == ChangePasswordStatus.error) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(
                AppLocalizations.of(context)!.pinChangeFailed,
              ),
            ),
          );
      } else if (state.status == ChangePasswordStatus.success) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(
                AppLocalizations.of(context)!.pinChangedSuccessfully,
              ),
            ),
          );
        Navigator.pushAndRemoveUntil(
          context,
          SplashPage.route(),
          (Route<dynamic> route) => false,
        );
      }
      setState(() {
        isLoading = false;
      });
    }, builder: (context, state) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(padding: EdgeInsets.only(top: 40)),
          Text(
            AppLocalizations.of(context)!.changePin,
            style: const TextStyle(
                fontSize: 20,
                color: FinvuColors.black1D1B20,
                fontWeight: FontWeight.bold),
          ),
          const Padding(padding: EdgeInsets.only(top: 35)),
          _CurrentPasscodeInput(
            controller: currentPasscodeController,
          ),
          const Padding(padding: EdgeInsets.only(top: 25)),
          _NewPasscodeInput(
            controller: newPasscodeController,
          ),
          const Padding(padding: EdgeInsets.only(top: 25)),
          _ConfirmNewPasscodeInput(
            controller: confirmPasscodeController,
          ),
          _PasscodeMismatchError(),
          const Padding(padding: EdgeInsets.only(top: 25)),
          isLoading
              ? const Align(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(),
                )
              : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48)),
                  onPressed: () {
                    if (newPasscodeController.text !=
                        confirmPasscodeController.text) {
                      setState(() {
                        errorText =
                            AppLocalizations.of(context)!.pinsDoNotMatch;
                      });
                      return;
                    } else if (currentPasscodeController.text ==
                        newPasscodeController.text) {
                      setState(() {
                        errorText = AppLocalizations.of(context)!
                            .newPinAndOldPinCannotBeTheSame;
                      });
                      return;
                    }

                    setState(() {
                      isLoading = true;
                      errorText = "";
                    });
                    context.read<ChangePasswordBloc>().add(
                          ChangePasswordSubmit(
                            currentPasscodeController.text,
                            newPasscodeController.text,
                          ),
                        );
                  },
                  child: Text(AppLocalizations.of(context)!.submit),
                ),
        ],
      );
    });
  }
}

class _PasscodeMismatchError extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: errorText.isNotEmpty,
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Text(
          errorText,
          style: const TextStyle(
            color: Colors.red,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

class _CurrentPasscodeInput extends StatelessWidget {
  final TextEditingController controller;
  const _CurrentPasscodeInput({required this.controller});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChangePasswordBloc, ChangePasswordState>(
      builder: (context, state) {
        return PasscodeInput(
          controller: controller,
          label: AppLocalizations.of(context)!.currentPin,
        );
      },
    );
  }
}

class _NewPasscodeInput extends StatelessWidget {
  final TextEditingController controller;

  const _NewPasscodeInput({required this.controller});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChangePasswordBloc, ChangePasswordState>(
      builder: (context, state) {
        return PasscodeInput(
          controller: controller,
          label: AppLocalizations.of(context)!.newPin,
        );
      },
    );
  }
}

class _ConfirmNewPasscodeInput extends StatelessWidget {
  final TextEditingController controller;

  const _ConfirmNewPasscodeInput({required this.controller});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChangePasswordBloc, ChangePasswordState>(
      builder: (context, state) {
        return PasscodeInput(
          controller: controller,
          label: AppLocalizations.of(context)!.confirmPin,
        );
      },
    );
  }
}
