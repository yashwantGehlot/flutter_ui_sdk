import 'package:equatable/equatable.dart';
import 'package:finvu_flutter_sdk/common/models/finvu_error.dart';
import 'package:finvu_flutter_sdk_core/finvu_initiate_account_data.dart';

enum AccountDataStatus {
  unknown,
  accountDataRequestInitiated,
  accountDataRequestInitialisationFailed,
  accountDataFetched,
  accountDataFetchFailed,
  error
}

final class AccountDataState extends Equatable {
  final AccountDataStatus status;
  final String consentId;
  final String sessionId;
  final FinvuError? error;
  final AccountDataFetchResponse? accountData;

  const AccountDataState({
    this.consentId = "",
    this.sessionId = "",
    this.status = AccountDataStatus.unknown,
    this.accountData,
    this.error,
  });

  AccountDataState copyWith({
    String? consentId,
    String? sessionId,
    required AccountDataStatus status,
    AccountDataFetchResponse? accountData,
    FinvuError? error,
  }) {
    return AccountDataState(
      consentId: consentId ?? this.consentId,
      sessionId: sessionId ?? this.sessionId,
      accountData: accountData ?? this.accountData,
      status: status,
      error: this.error,
    );
  }

  @override
  List<Object?> get props => [
        consentId,
        sessionId,
        accountData,
        status,
        error,
      ];
}
