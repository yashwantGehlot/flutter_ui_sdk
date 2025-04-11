import 'package:finvu_flutter_sdk/common/models/finvu_error.dart';
import 'package:finvu_flutter_sdk/common/utils/finvu_date_utils.dart';
import 'package:finvu_flutter_sdk/features/account_data_fetch/bloc/account_data_event.dart';
import 'package:finvu_flutter_sdk/features/account_data_fetch/bloc/account_data_state.dart';
import 'package:finvu_flutter_sdk_core/finvu_exception.dart';
import 'package:finvu_flutter_sdk_internal/finvu_manager_internal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountDataBloc extends Bloc<AccountDataEvent, AccountDataState> {
  final FinvuManagerInternal _finvuManagerInternal = FinvuManagerInternal();

  AccountDataBloc() : super(const AccountDataState()) {
    on<AccountDataFetchRequestSubmitted>(_onAccountDataFetchRequest);
    on<AccountDataFetchSubmitted>(_onAccountDataFetch);
  }

  void _onAccountDataFetchRequest(
    AccountDataFetchRequestSubmitted event,
    Emitter<AccountDataState> emit,
  ) async {
    try {
      final from = FinvuDateUtils.formatToDateFromStringZ(
          event.consent.dataDateTimeRange.from!);
      final dateNow = DateTime.now();
      final to = FinvuDateUtils.formatToDateFromStringZ(dateNow);
      final publicKeyExpiry = FinvuDateUtils.formatToDateFromStringZ(
        dateNow.add(
          const Duration(hours: 23),
        ),
      );

      final accountDataRequest =
          await _finvuManagerInternal.initiateAccountDataRequest(
        from,
        to,
        event.consent.consentId!,
        publicKeyExpiry,
      );

      emit(
        state.copyWith(
            consentId: accountDataRequest.consentId,
            sessionId: accountDataRequest.sessionId,
            status: AccountDataStatus.accountDataRequestInitiated),
      );
    } on FinvuException catch (err) {
      emit(
        state.copyWith(
          status: AccountDataStatus.error,
          error: err.toFinvuError(),
        ),
      );
      debugPrint("FINVU EX while DATA REQUEST:  $err");
    } catch (err) {
      emit(state.copyWith(
          status: AccountDataStatus.accountDataRequestInitialisationFailed));
      debugPrint("CATCH Error while DATA REQUEST:  $err");
    }
  }

  void _onAccountDataFetch(
    AccountDataFetchSubmitted event,
    Emitter<AccountDataState> emit,
  ) async {
    try {
      final accountData = await _finvuManagerInternal.fetchAccountData(
        state.sessionId,
        state.consentId,
      );

      emit(
        state.copyWith(
          status: AccountDataStatus.accountDataFetched,
          accountData: accountData,
        ),
      );
    } on FinvuException catch (err) {
      emit(
        state.copyWith(
          status: AccountDataStatus.error,
          error: err.toFinvuError(),
        ),
      );
      debugPrint("FINVU EX while fetching account data:  $err");
    } catch (err) {
      emit(state.copyWith(status: AccountDataStatus.accountDataFetchFailed));
      debugPrint("FINVU EX while fetching account data:  $err");
    }
  }
}
