import 'package:finvu_flutter_sdk/common/widgets/finvu_dialog.dart';
import 'package:finvu_flutter_sdk/common/widgets/otp_input.dart';
import 'package:finvu_flutter_sdk/features/account_linking/bloc/account_linking_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MobileVerificatioDialog extends StatefulWidget {
  const MobileVerificatioDialog({super.key, required this.newMobileNumber});
  final String newMobileNumber;

  @override
  State<MobileVerificatioDialog> createState() => OtpInputDialogState();
}

class OtpInputDialogState extends State<MobileVerificatioDialog> {
  String _otp = "";

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountLinkingBloc, AccountLinkingState>(
        builder: (context, state) {
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
            context.read<AccountLinkingBloc>().add(
                AccountLinkingMobileNumberVerificationSubmitted(
                    _otp, widget.newMobileNumber));
          }
        },
      );
    });
  }
}
