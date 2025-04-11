import 'package:equatable/equatable.dart';
import 'package:finvu_flutter_sdk/common/models/fi_type_category.dart';
import 'package:finvu_flutter_sdk/common/models/finvu_error.dart';
import 'package:finvu_flutter_sdk/common/models/linked_account_with_fip.dart';
import 'package:finvu_flutter_sdk/finvu_manager.dart';
import 'package:finvu_flutter_sdk_core/finvu_exception.dart';
import 'package:finvu_flutter_sdk_core/finvu_fip_info.dart';
import 'package:finvu_flutter_sdk_internal/finvu_manager_internal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final FinvuManager _finvuManager = FinvuManager();
  final FinvuManagerInternal _finvuManagerInternal = FinvuManagerInternal();

  HomeBloc() : super(const HomeState()) {
    on<HomeRefresh>(_onHomeRefresh);
  }

  void _onHomeRefresh(
    HomeRefresh event,
    Emitter<HomeState> emit,
  ) async {
    emit(
      state.copyWith(
        status: HomeStatus.isFetchingPendingConsents,
      ),
    );

    try {
      final accounts = await _finvuManager.fetchLinkedAccounts();

      if (accounts.isNotEmpty) {
        final fipInfos = await _finvuManager.fipsAllFIPOptions();
        final Map<String, FinvuFIPInfo> fipInfoMap = {
          for (var fip in fipInfos) fip.fipId: fip
        };

        final linkedAccounts = accounts
            .map(
              (account) => LinkedAccountInfo(
                linkedAccountDetailsInfo: account,
                fipInfo: fipInfoMap[account.fipId]!,
              ),
            )
            .toList();

        final bankAccountFiTypes =
            FiTypeCategory.bankAccounts.fiTypes.map((e) => e.value).toList();
        final bankAccounts = linkedAccounts
            .where((account) => bankAccountFiTypes.contains(account.fiType))
            .toList();

        final equityFiTypes =
            FiTypeCategory.equities.fiTypes.map((e) => e.value).toList();
        final equityHoldings = linkedAccounts
            .where((account) => equityFiTypes.contains(account.fiType))
            .toList();

        final insuranceFiTypes =
            FiTypeCategory.insurance.fiTypes.map((e) => e.value).toList();
        final insurancePolicies = linkedAccounts
            .where((account) => insuranceFiTypes.contains(account.fiType))
            .toList();

        emit(
          state.copyWith(
            status: HomeStatus.pendingConsentsFetched,
            bankAccounts: bankAccounts,
            equityHoldings: equityHoldings,
            insurancePolicies: insurancePolicies,
          ),
        );
      }
    } on FinvuException catch (err) {
      debugPrint("Error while fetcing user info $err");
      emit(
        state.copyWith(
          status: HomeStatus.error,
          error: err.toFinvuError(),
        ),
      );
    } catch (err) {
      emit(
        state.copyWith(status: HomeStatus.error),
      );
    }
  }
}
