import 'dart:async';

import 'package:finvu_flutter_sdk/common/models/fi_type.dart';
import 'package:finvu_flutter_sdk/common/utils/constants.dart';
import 'package:finvu_flutter_sdk/common/utils/finvu_colors.dart';
import 'package:finvu_flutter_sdk/common/utils/remote_config_service.dart';
import 'package:finvu_flutter_sdk/common/widgets/finvu_dialog.dart';
import 'package:finvu_flutter_sdk/common/widgets/otp_input.dart';
import 'package:finvu_flutter_sdk/features/account_linking/bloc/account_linking_bloc.dart';
import 'package:finvu_flutter_sdk/finvu_manager.dart';
import 'package:finvu_flutter_sdk/finvu_ui_manager.dart';
import 'package:finvu_flutter_sdk_core/finvu_discovered_accounts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finvu_flutter_sdk/l10n/app_localizations.dart';

const int _resendOtpDuration = 60;

class OtpInputDialog extends StatefulWidget {
  final List<FinvuDiscoveredAccountInfo>? selectedAccounts;
  final AppLocalizations localizations;

  const OtpInputDialog({
    super.key,
    this.selectedAccounts,
    required this.localizations,
  });

  @override
  State<OtpInputDialog> createState() => OtpInputDialogState();
}

class OtpInputDialogState extends State<OtpInputDialog> {
  String _otp = "";
  int _resendOtpSecondsRemaining = _resendOtpDuration;
  bool _enableResend = false;
  Timer? _resendOtpTimer;
  final RemoteConfigService remoteConfig = RemoteConfigService();

  void _resetAndStartOtpTimer(final BuildContext context) {
    if (_resendOtpTimer != null) {
      _resendOtpTimer!.cancel();
    }
    _resendOtpTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!context.mounted) {
        timer.cancel();
        return;
      }

      if (_resendOtpSecondsRemaining > 0) {
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocConsumer<AccountLinkingBloc, AccountLinkingState>(
        listener: (context, state) {
      if (state.status == AccountLinkingStatus.didSendOtp ||
          state.status == AccountLinkingStatus.didReSendOtp) {
        _resetAndStartOtpTimer(context);
      } else if (state.status == AccountLinkingStatus.linkingSuccess) {
        Navigator.pop(context, Constants.linkingSuccessful);
      }
    }, builder: (context, state) {
      final bool hasGstrAccount = widget.selectedAccounts!
          .any((account) => account.fiType == FiType.gstr13b.value);
      return FinvuDialog(
        title: widget.localizations.enterOtp,
        subtitle: [
          TextSpan(
            text: widget.localizations.verifyOtp,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: FinvuUIManager().uiConfig?.currentColor,
            ),
          ),
        ],
        content: Column(
          children: [
            OtpInput(
              onChanged: (otp) {
                setState(() {
                  _otp = otp;
                });
              },
              inputFormatters: hasGstrAccount
                  ? [
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
                    ]
                  : [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(
                        remoteConfig.accountLinkingOtpMaxLength,
                      )
                    ],
              localizations: widget.localizations,
            ),
            Column(children: [
              const Padding(padding: EdgeInsets.only(top: 15)),
              _buildResendOtpWidget(context),
              const Padding(padding: EdgeInsets.only(top: 15)),
            ])
          ],
        ),
        buttonText: widget.localizations.submit,
        isButtonLoading: state.status == AccountLinkingStatus.isVerifyingOtp,
        onPressed: () {
          if (_otp.isNotEmpty) {
            context
                .read<AccountLinkingBloc>()
                .add(AccountLinkingMobileNumberOtpSubmitted(_otp));
          }
        },
      );
    });
  }

  Widget _buildResendOtpWidget(BuildContext context) {
    final theme = Theme.of(context);

    if (_enableResend) {
      return BlocBuilder<AccountLinkingBloc, AccountLinkingState>(
          builder: (context, state) {
        return Align(
          alignment: Alignment.centerLeft,
          child: InkWell(
            onTap: () {
              _resetAndStartOtpTimer(context);
              setState(() {
                _resendOtpSecondsRemaining = _resendOtpDuration;
                _enableResend = false;
              });
              context.read<AccountLinkingBloc>().add(
                    AccountLinkingInitiated(widget.selectedAccounts!,
                        shouldResendOtp: true),
                  );
            },
            child: Text(
              widget.localizations.resendOtp,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: FinvuUIManager().uiConfig?.primaryColor,
              ),
            ),
          ),
        );
      });
    }

    _resetAndStartOtpTimer(context);
    return Row(children: [
      Text(
        widget.localizations.resendOtpIn,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: FinvuUIManager().uiConfig?.primaryColor,
        ),
      ),
      const Padding(padding: EdgeInsets.only(right: 4)),
      Text(
        _resendOtpSecondsRemaining.toString(),
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.error,
          fontWeight: FontWeight.bold,
        ),
      ),
      const Padding(padding: EdgeInsets.only(right: 2)),
      Text(
        widget.localizations.secs,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.error,
          fontWeight: FontWeight.bold,
        ),
      ),
    ]);
  }
}
