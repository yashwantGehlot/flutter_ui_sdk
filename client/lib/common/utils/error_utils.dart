import 'package:finvu_flutter_sdk/common/models/finvu_error.dart';
import 'package:flutter/material.dart';
import 'package:finvu_flutter_sdk/l10n/app_localizations.dart';

class ErrorUtils {
  static bool hasSessionExpired(
    FinvuError? error,
  ) {
    if (error == null) {
      return false;
    }

    return error.code == FinvuErrorCode.logout ||
        error.code == FinvuErrorCode.sessionDisconnected;
  }

  static String getErrorMessage(
      final BuildContext context, final FinvuError? error,
      {final bool returnRawMessage = false}) {
    if (error == null) {
      return AppLocalizations.of(context)!.somethingWentWrongPleaseTryAgain;
    }

    switch (error.code) {
      case FinvuErrorCode.authLoginFailed:
        return _getLoginFailedErrorMessage(context, error.message);
      case FinvuErrorCode.sslPinningFailureError:
        return AppLocalizations.of(context)!.networkInsecure;
      default:
        if (returnRawMessage) {
          return error.message ??
              AppLocalizations.of(context)!.somethingWentWrongPleaseTryAgain;
        } else {
          return AppLocalizations.of(context)!.somethingWentWrongPleaseTryAgain;
        }
    }
  }

  static String _getLoginFailedErrorMessage(
    final BuildContext context,
    final String? message,
  ) {
    if (message == null) {
      return AppLocalizations.of(context)!.loginFailed;
    }

    if (message.toLowerCase().contains("invalid")) {
      return AppLocalizations.of(context)!.invalidUsernameOrPin;
    }

    return AppLocalizations.of(context)!.loginFailed;
  }
}
