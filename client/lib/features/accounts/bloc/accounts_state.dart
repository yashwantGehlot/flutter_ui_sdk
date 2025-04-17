part of 'accounts_bloc.dart';

enum AccountsStatus {
  unknown,
  isFetchingAccounts,
  accountsFetched,
  isDelinkingAccount,
  accountDelinked,
  error,
}

class AccountsState extends Equatable {
  final AccountsStatus status;
  final List<LinkedAccountInfo> linkedAccounts;
  final int errorTimestamp;
  final FinvuError? error;

  const AccountsState({
    this.status = AccountsStatus.unknown,
    this.errorTimestamp = 0,
    this.linkedAccounts = const [],
    this.error,
  });

  AccountsState copyWith({
    List<LinkedAccountInfo>? linkedAccounts,
    required AccountsStatus status,
    FinvuError? error,
  }) {
    int errorTimestamp = this.errorTimestamp;
    if (status == AccountsStatus.error) {
      errorTimestamp = DateTime.now().millisecondsSinceEpoch;
    }

    return AccountsState(
      linkedAccounts: linkedAccounts ?? this.linkedAccounts,
      status: status,
      errorTimestamp: errorTimestamp,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
        linkedAccounts,
        status,
        error,
        errorTimestamp,
      ];
}
