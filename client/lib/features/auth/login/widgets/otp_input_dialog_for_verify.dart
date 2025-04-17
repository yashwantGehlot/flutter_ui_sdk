import 'package:finvu_flutter_sdk/common/widgets/finvu_dialog.dart';
import 'package:finvu_flutter_sdk/common/widgets/otp_input.dart';
import 'package:finvu_flutter_sdk/features/auth/login/bloc/login_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finvu_flutter_sdk/l10n/app_localizations.dart';

class OtpInputDialogForVerify extends StatefulWidget {
  const OtpInputDialogForVerify(this.mobileNumber, {super.key});

  final String mobileNumber;

  @override
  State<OtpInputDialogForVerify> createState() =>
      OtpInputDialogForVerifyState();
}

class OtpInputDialogForVerifyState extends State<OtpInputDialogForVerify> {
  String _otp = "";

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      return FinvuDialog(
        title: AppLocalizations.of(context)!.enterOtp,
        subtitle: [
          TextSpan(
            text: AppLocalizations.of(context)!.verifyOtp,
          ),
        ],
        content: OtpInput(onChanged: (otp) {
          setState(() {
            _otp = otp;
          });
        }),
        buttonText: AppLocalizations.of(context)!.submit,
        onPressed: () {
          if (_otp.isNotEmpty) {
            context.read<LoginBloc>().add(
                  LoginMobileVerificationComplete(
                    widget.mobileNumber,
                    _otp,
                  ),
                );
          }
        },
      );
    });
  }
}
