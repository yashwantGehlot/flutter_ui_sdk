import 'package:finvu_flutter_sdk/common/models/finvu_error.dart';
import 'package:finvu_flutter_sdk/common/models/linked_account_with_fip.dart';
import 'package:finvu_flutter_sdk/finvu_manager.dart';
import 'package:finvu_flutter_sdk_core/finvu_exception.dart';
import 'package:finvu_flutter_sdk_core/finvu_fip_info.dart';
import 'package:finvu_flutter_sdk_internal/finvu_manager_internal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'accounts_event.dart';
part 'accounts_state.dart';

class AccountsBloc extends Bloc<AccountsEvent, AccountsState> {
  final FinvuManager _finvuManager = FinvuManager();
  final FinvuManagerInternal _finvuManagerInternal = FinvuManagerInternal();

  AccountsBloc() : super(const AccountsState()) {
    on<AccountsRefresh>(_onAccountsRefresh);
    on<AccountsDelink>(_onAccountsDelink);
  }

  void _onAccountsRefresh(
    AccountsRefresh event,
    Emitter<AccountsState> emit,
  ) async {
    emit(
      state.copyWith(
        status: AccountsStatus.isFetchingAccounts,
      ),
    );

    try {
      final finvuLinkedAccounts = await _finvuManager.fetchLinkedAccounts();

      final fipInfos = await _finvuManager.fipsAllFIPOptions();
      final Map<String, FinvuFIPInfo> fipInfoMap = {
        for (var fip in fipInfos) fip.fipId: fip
      };

      final linkedAccounts = finvuLinkedAccounts
          .map(
            (account) => LinkedAccountInfo(
              linkedAccountDetailsInfo: account,
              fipInfo: fipInfoMap[account.fipId]!,
            ),
          )
          .toList();

      emit(
        state.copyWith(
          linkedAccounts: linkedAccounts,
          status: AccountsStatus.accountsFetched,
        ),
      );
    } on FinvuException catch (err) {
      debugPrint("Error while fetching linked accounts ${err.code}");
      emit(
        state.copyWith(
          status: AccountsStatus.error,
          error: err.toFinvuError(),
        ),
      );
    } catch (err) {
      debugPrint("Error while fetching accounts $err");
      emit(
        state.copyWith(
          status: AccountsStatus.error,
        ),
      );
    }
  }

  void _onAccountsDelink(
    AccountsDelink event,
    Emitter<AccountsState> emit,
  ) async {
    emit(
      state.copyWith(
        status: AccountsStatus.isDelinkingAccount,
      ),
    );

    try {
      await _finvuManagerInternal.unlinkAccount(event.account);
      final linkedAccounts = state.linkedAccounts
          .where(
            (account) =>
                account.accountReferenceNumber !=
                event.account.accountReferenceNumber,
          )
          .toList();
      emit(
        state.copyWith(
          status: AccountsStatus.accountDelinked,
          linkedAccounts: linkedAccounts,
        ),
      );
    } on FinvuException catch (err) {
      debugPrint("Error while delinking account $err");
      emit(
        state.copyWith(
          status: AccountsStatus.error,
          error: err.toFinvuError(),
        ),
      );
    } catch (err) {
      debugPrint("Error while delinking account $err");
      emit(
        state.copyWith(
          status: AccountsStatus.error,
        ),
      );
    }
  }
}
