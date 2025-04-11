part of 'accounts_bloc.dart';

sealed class AccountsEvent {
  const AccountsEvent();
}

final class AccountsRefresh extends AccountsEvent {
  const AccountsRefresh();
}

final class AccountsDelink extends AccountsEvent {
  const AccountsDelink(this.account);

  final LinkedAccountInfo account;
}
