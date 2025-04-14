import 'package:equatable/equatable.dart';
import 'package:finvu_flutter_sdk/common/models/consent.dart';
import 'package:finvu_flutter_sdk/common/models/finvu_error.dart';
import 'package:finvu_flutter_sdk/common/models/linked_account_with_fip.dart';
import 'package:finvu_flutter_sdk/common/models/self_consent_details.dart';
import 'package:finvu_flutter_sdk/common/utils/constants.dart';
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
//    on<ConsentsRefresh>(_onConsentRefresh);
    on<LinkedAccountsRefresh>(_onLinkedAccountsRefresh);
    on<ConsentApprove>(_onConsentApprove);
    on<ConsentReject>(_onConsentReject);
    on<ConsentRevoke>(_onConsentRevoke);
//    on<ConsentHistory>(_onConsentHistory);
//    on<SelfConsentRequest>(_onSelfConsentRequest);
  }

  // void _onConsentRefresh(
  //   ConsentsRefresh event,
  //   Emitter<ConsentState> emit,
  // ) async {
  //   emit(
  //     state.copyWith(
  //       status: ConsentStatus.isFetchingConsents,
  //     ),
  //   );

  //   try {
  //     final finvuPendingConsents =
  //         await _finvuManagerInternal.fetchPendingConsents();
  //     final userConsents = await _finvuManagerInternal.getUserConsents();

  //     final otherConsents = userConsents
  //         .where((consent) => consent.consentIntentEntityId != null)
  //         .toList();

  //     final Set<String> uniqueFiuIds = {};

  //     for (var consent in finvuPendingConsents) {
  //       uniqueFiuIds.add(consent.financialInformationUser.id);
  //     }

  //     for (var consent in otherConsents) {
  //       uniqueFiuIds.add(consent.consentIntentEntityId!);
  //     }

  //     final Map<String, FinvuEntityInfo> fiuInfoMap = {};
  //     for (var fiuId in uniqueFiuIds) {
  //       final fiuInfo = await _finvuManager.getEntityInfo(fiuId, "FIU");
  //       fiuInfoMap[fiuId] = fiuInfo;
  //     }

  //     final List<ConsentDetails> pendingConsents = [];
  //     for (var consent in finvuPendingConsents) {
  //       final consentDetails = ConsentDetails.fromConsentRequestDetailInfo(
  //         consent,
  //         fiuInfoMap[consent.financialInformationUser.id]!,
  //       );
  //       pendingConsents.add(consentDetails);
  //     }

  //     final List<ConsentDetails> activeConsents = [];
  //     final List<ConsentDetails> inactiveConsents = [];
  //     final List<ConsentDetails> pausedConsents = [];
  //     for (var consent in otherConsents) {
  //       final finvuConsentDetails =
  //           await _finvuManagerInternal.getUserConsentDetails(consent);

  //       for (var accounts in finvuConsentDetails.accounts) {
  //         var entityInfo =
  //             await _finvuManager.getEntityInfo(accounts.fipId, "FIP");
  //         accounts.fipName = entityInfo.entityName;
  //       }

  //       final consentDetails = ConsentDetails.fromConsentInfoDetail(
  //           finvuConsentDetails,
  //           fiuInfoMap[consent.consentIntentEntityId]!,
  //           consent);

  //       if (consentDetails.consentStatus == Constants.active) {
  //         activeConsents.add(consentDetails);
  //       } else if (consentDetails.consentStatus == Constants.paused) {
  //         pausedConsents.add(consentDetails);
  //       } else {
  //         inactiveConsents.add(consentDetails);
  //       }
  //     }

  //     final List<ConsentDetails> activeSelfConsents = [];
  //     final finvuConsents = userConsents
  //         .where((consent) => consent.consentIntentEntityName == "Finvu")
  //         .toList();
  //     if (finvuConsents.isNotEmpty) {
  //       for (var consentId in finvuConsents.first.consentIdList) {
  //         FinvuEntityInfo? finvuFipEntityInfo;
  //         final finvuConsentDetails =
  //             await _finvuManagerInternal.getUserConsentDetailsForId(consentId);

  //         finvuFipEntityInfo ??= await _finvuManager.getEntityInfo(
  //           finvuConsentDetails.financialInformationProvider!.id,
  //           "FIP",
  //         );

  //         for (var accounts in finvuConsentDetails.accounts) {
  //           var entityInfo =
  //               await _finvuManager.getEntityInfo(accounts.fipId, "FIP");
  //           accounts.fipName = entityInfo.entityName;
  //         }

  //         final consentDetails = ConsentDetails.fromConsentInfoDetail(
  //             finvuConsentDetails, finvuFipEntityInfo, finvuConsents.first);

  //         if (finvuConsentDetails.consentStatus == Constants.active) {
  //           activeSelfConsents.add(consentDetails);
  //         }
  //       }
  //     }

  //     DateTime expiringConsentThreshold = DateTime.now().add(
  //       const Duration(days: 15),
  //     );
  //     final List<ConsentDetails> expiringConsents = activeConsents
  //         .where(
  //           (consent) =>
  //               consent.consentDateTimeRange.to != null &&
  //               consent.consentDateTimeRange.to!
  //                   .isBefore(expiringConsentThreshold),
  //         )
  //         .toList();

  //     emit(
  //       state.copyWith(
  //         status: ConsentStatus.consentsFetched,
  //         pendingConsents: pendingConsents,
  //         activeConsents: activeConsents,
  //         pausedConsnets: pausedConsents,
  //         inactiveConsents: inactiveConsents,
  //         activeSelfConsents: activeSelfConsents,
  //         expiringConsents: expiringConsents,
  //       ),
  //     );
  //   } on FinvuException catch (err) {
  //     debugPrint("Error while fetcing consents $err");
  //     emit(
  //       state.copyWith(
  //         status: ConsentStatus.error,
  //         error: err.toFinvuError(),
  //       ),
  //     );
  //   } catch (err) {
  //     debugPrint('Error fetching pending consents: $err');
  //     emit(
  //       state.copyWith(status: ConsentStatus.error),
  //     );
  //   }
  // }

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

  // void _onSelfConsentRequest(
  //   SelfConsentRequest event,
  //   Emitter<ConsentState> emit,
  // ) async {
  //   emit(
  //     state.copyWith(
  //       status: ConsentStatus.isRequestingSelfConsent,
  //     ),
  //   );

  //   try {
  //     await _finvuManagerInternal.requestSelfConsent(
  //       event.selfConsentDetails.createTime,
  //       event.selfConsentDetails.startTime,
  //       event.selfConsentDetails.expireTime,
  //       event.selfConsentDetails.linkedAccounts,
  //       event.selfConsentDetails.consentTypes,
  //       event.selfConsentDetails.fiTypes,
  //       event.selfConsentDetails.mode,
  //       event.selfConsentDetails.fetchType,
  //       event.selfConsentDetails.frequency,
  //       event.selfConsentDetails.dataLife,
  //       event.selfConsentDetails.purposeText,
  //       event.selfConsentDetails.purposeType,
  //     );

  //     emit(
  //       state.copyWith(
  //         status: ConsentStatus.selfConsentRequested,
  //       ),
  //     );
  //   } on FinvuException catch (err) {
  //     debugPrint("Error while requesting self consent $err");
  //     emit(
  //       state.copyWith(
  //         status: ConsentStatus.error,
  //         error: err.toFinvuError(),
  //       ),
  //     );
  //   } catch (err) {
  //     debugPrint('Error revoking consent: $err');
  //     emit(
  //       state.copyWith(status: ConsentStatus.error),
  //     );
  //   }
  // }

  // void _onConsentHistory(
  //   ConsentHistory event,
  //   Emitter<ConsentState> emit,
  // ) async {
  //   emit(
  //     state.copyWith(
  //       status: ConsentStatus.isFetchingHistory,
  //     ),
  //   );

  //   try {
  //     // If active self consent then use consentId else use first item from consentIdList
  //     String? consentId;
  //     if (event.consent.entityInfo.entityName.contains("Finvu")) {
  //       consentId = event.consent.consentId!;
  //     } else {
  //       consentId = event.consent.finvuUserConsentInfo?.consentIdList[0];
  //     }
  //     if (consentId != null) {
  //       final consentHistoryResponse =
  //           await _finvuManagerInternal.getConsentHistory(consentId);

  //       if (consentHistoryResponse.consentHistory != null) {
  //         consentHistoryResponse.consentHistory!.sort((a, b) {
  //           if (b.consentTimestamp == null && a.consentTimestamp == null) {
  //             return 0;
  //           } else if (b.consentTimestamp == null) {
  //             return -1;
  //           } else if (a.consentTimestamp == null) {
  //             return 1;
  //           } else {
  //             return b.consentTimestamp!.compareTo(a.consentTimestamp!);
  //           }
  //         });
  //       }

  //       emit(
  //         state.copyWith(
  //           status: ConsentStatus.historyFetched,
  //           consentHistory: consentHistoryResponse.consentHistory,
  //         ),
  //       );
  //     } else {
  //       emit(
  //         state.copyWith(status: ConsentStatus.error),
  //       );
  //     }
  //   } on FinvuException catch (err) {
  //     debugPrint("Error while fetcing consents $err");
  //     emit(
  //       state.copyWith(
  //         status: ConsentStatus.error,
  //         error: err.toFinvuError(),
  //       ),
  //     );
  //   } catch (err) {
  //     debugPrint('Error revoking consent: $err');
  //     emit(
  //       state.copyWith(status: ConsentStatus.error),
  //     );
  //   }
  // }
}
