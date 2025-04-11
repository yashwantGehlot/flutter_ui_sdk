import 'package:finvu_flutter_sdk/common/widgets/finvu_dialog.dart';
import 'package:finvu_flutter_sdk/features/auth/login/login_page.dart';
import 'package:finvu_flutter_sdk/features/auth/registration/bloc/registration_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserRegisteredDialog extends StatefulWidget {
  const UserRegisteredDialog({
    super.key,
  });

  @override
  State<UserRegisteredDialog> createState() => UserRegisteredDialogState();
}

class UserRegisteredDialogState extends State<UserRegisteredDialog> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegistrationBloc, RegistrationState>(
        builder: (context, state) {
      return FinvuDialog(
        title: AppLocalizations.of(context)!.accountRegisteredSuccessfully,
        subtitle: [
          TextSpan(
              text: AppLocalizations.of(context)!.yourAccountIsNowRegistered),
        ],
        content: const Text(""),
        buttonText: AppLocalizations.of(context)!.okay,
        onPressed: () {
          Navigator.pushAndRemoveUntil(
            context,
            LoginPage.route(LoginType.aaHandlePasscode),
            (Route<dynamic> route) => false,
          );
        },
      );
    });
  }
}
