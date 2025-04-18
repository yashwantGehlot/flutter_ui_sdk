import 'package:equatable/equatable.dart';
import 'package:finvu_flutter_sdk/common/models/consent.dart';
import 'package:finvu_flutter_sdk/common/models/finvu_error.dart';
import 'package:finvu_flutter_sdk/common/models/linked_account_with_fip.dart';
import 'package:finvu_flutter_sdk/finvu_manager.dart';
import 'package:finvu_flutter_sdk_core/finvu_consent_history.dart';
import 'package:finvu_flutter_sdk_core/finvu_consent_info.dart';
import 'package:finvu_flutter_sdk_core/finvu_exception.dart';
import 'package:finvu_flutter_sdk_core/finvu_fip_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'consent_event.dart';
part 'consent_state.dart';

class ConsentBloc extends Bloc<ConsentEvent, ConsentState> {
  final FinvuManager _finvuManager = FinvuManager();

  ConsentBloc() : super(const ConsentState()) {
    on<FetchConsentDetails>(_fetchConsentDetails);
    on<LinkedAccountsRefresh>(_onLinkedAccountsRefresh);
    on<ConsentApprove>(_onConsentApprove);
    on<ConsentReject>(_onConsentReject);
    on<ConsentRevoke>(_onConsentRevoke);
  }

  void _fetchConsentDetails(
    FetchConsentDetails event,
    Emitter<ConsentState> emit,
  ) async {
    emit(
      state.copyWith(
        status: ConsentStatus.isFetchingConsentDetails,
      ),
    );
    try {
      final consentDetails = await _finvuManager.getConsentRequestDetails(
        event.consentHandleId,
      );

      emit(
        state.copyWith(
          status: ConsentStatus.consentDetailsFetched,
          consent: consentDetails,
        ),
      );
    } catch (err) {
      debugPrint('Error fetching consent details: $err');
      emit(
        state.copyWith(status: ConsentStatus.error),
      );
    }
  }

  void _onLinkedAccountsRefresh(
    LinkedAccountsRefresh event,
    Emitter<ConsentState> emit,
  ) async {
    emit(
      state.copyWith(
        status: ConsentStatus.isFetchingLinkedAccounts,
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
          status: ConsentStatus.linkedAccountsFetched,
          linkedAccounts: linkedAccounts,
        ),
      );
    } on FinvuException catch (err) {
      debugPrint("Error while fetcing consents $err");
      emit(
        state.copyWith(
          status: ConsentStatus.error,
          error: err.toFinvuError(),
        ),
      );
    } catch (err) {
      debugPrint('Error fetching linked accounts: $err');
      emit(
        state.copyWith(status: ConsentStatus.error),
      );
    }
  }

  void _onConsentApprove(
    ConsentApprove event,
    Emitter<ConsentState> emit,
  ) async {
    emit(
      state.copyWith(
        status: ConsentStatus.isApprovingConsent,
      ),
    );

    try {
      await _finvuManager.approveConsentRequest(
        event.consent.consentRequestDetailInfo!,
        event.selectedAccounts,
      );

      emit(
        state.copyWith(
          status: ConsentStatus.consentApproved,
        ),
      );
    } on FinvuException catch (err) {
      debugPrint("Error while fetcing consents $err");
      emit(
        state.copyWith(
          status: ConsentStatus.error,
          error: err.toFinvuError(),
        ),
      );
    } catch (err) {
      debugPrint('Error approving consent: $err');
      emit(
        state.copyWith(status: ConsentStatus.error),
      );
    }
  }

  void _onConsentReject(
    ConsentReject event,
    Emitter<ConsentState> emit,
  ) async {
    emit(
      state.copyWith(
        status: ConsentStatus.isRejectingConsent,
      ),
    );

    try {
      await _finvuManager
          .denyConsentRequest(event.consent.consentRequestDetailInfo!);

      emit(
        state.copyWith(
          status: ConsentStatus.consentRejected,
        ),
      );
    } on FinvuException catch (err) {
      debugPrint("Error while fetcing consents $err");
      emit(
        state.copyWith(
          status: ConsentStatus.error,
          error: err.toFinvuError(),
        ),
      );
    } catch (err) {
      debugPrint('Error rejecting consent: $err');
      emit(
        state.copyWith(status: ConsentStatus.error),
      );
    }
  }

  void _onConsentRevoke(
    ConsentRevoke event,
    Emitter<ConsentState> emit,
  ) async {
    if (event.consent.finvuUserConsentInfo != null) {
      emit(
        state.copyWith(
          status: ConsentStatus.isRevokingConsent,
        ),
      );

      final fip = event.consent.financialInformationProvider;
      final fipDetails =
          fip != null ? FIPReference(fipId: fip.id, fipName: fip.name) : null;
      try {
        // consentId and consentIntentId are the same only same for regular consents
        await _finvuManager.revokeConsent(
            event.consent.consentId ??
                event.consent.finvuUserConsentInfo!.consentIntentId,
            event.consent.finvuUserConsentInfo!,
            event.consent.accountAggregator,
            fipDetails);

        emit(
          state.copyWith(
            status: ConsentStatus.consentRevoked,
          ),
        );
      } on FinvuException catch (err) {
        debugPrint("Error revoking consent: $err");
        emit(
          state.copyWith(
            status: ConsentStatus.error,
            error: err.toFinvuError(),
          ),
        );
      } catch (err) {
        debugPrint('Error revoking consent: $err');
        emit(
          state.copyWith(status: ConsentStatus.error),
        );
      }
    }
  }
}
