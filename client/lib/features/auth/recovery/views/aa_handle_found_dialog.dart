import 'package:finvu_flutter_sdk/common/widgets/finvu_dialog.dart';
import 'package:finvu_flutter_sdk/features/auth/recovery/bloc/recovery_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AAHandleFoundDialog extends StatelessWidget {
  const AAHandleFoundDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecoveryBloc, RecoveryState>(
      builder: (context, state) {
        return FinvuDialog(
          title: AppLocalizations.of(context)!.yourAAHandleIs(state.aaHandle),
          content: Column(
            children: [
              const SizedBox(height: 16),
              state.status == RecoveryStatus.isLoggingIn
                  ? const Align(
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(),
                    )
                  : SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          context
                              .read<RecoveryBloc>()
                              .add(const LoginWithRecoveredAaHandle());
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          AppLocalizations.of(context)!.continueSignIn,
                        ),
                      ),
                    ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
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
        );
      },
    );
  }
}
