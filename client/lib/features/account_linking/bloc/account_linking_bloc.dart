import 'package:equatable/equatable.dart';
import 'package:finvu_flutter_sdk/common/models/finvu_error.dart';
import 'package:finvu_flutter_sdk/common/utils/collection_utils.dart';
import 'package:finvu_flutter_sdk/common/utils/linked_accounts_identifier_util.dart';
import 'package:finvu_flutter_sdk/features/account_linking/models/discovered_account.dart';
import 'package:finvu_flutter_sdk/features/account_linking/models/identifier.dart';
import 'package:finvu_flutter_sdk/finvu_manager.dart';
import 'package:finvu_flutter_sdk_core/finvu_discovered_accounts.dart';
import 'package:finvu_flutter_sdk_core/finvu_exception.dart';
import 'package:finvu_flutter_sdk_core/finvu_fip_details.dart';
import 'package:finvu_flutter_sdk_core/finvu_fip_info.dart';
import 'package:finvu_flutter_sdk_core/finvu_linked_accounts.dart';
import 'package:finvu_flutter_sdk_core/finvu_user_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'account_linking_event.dart';
part 'account_linking_state.dart';

class AccountLinkingBloc
    extends Bloc<AccountLinkingEvent, AccountLinkingState> {
  final FinvuManager _finvuManager = FinvuManager();

  AccountLinkingBloc() : super(const AccountLinkingState()) {
//    on<AccountLinkingInitialized>(_onInitialize);
    on<AccountLinkingMobileNumberSelected>(_onMobileNumberSelected);
    on<AccountLinkingMobileNumberAdded>(_onMobileNumberAdded);
    on<AccountLinkingFipSelected>(_onFipSelected);
    on<AccountLinkingDiscoveryInitiated>(_onDiscoveryInitiated);
    on<AccountLinkingAdditionalIdentifierChanged>(
        _onAdditionalIdentifierChanged);
    on<AccountLinkingAdditionalIdentifierSubmitted>(
        _onAdditionalIdentifierSubmitted);
    on<AccountLinkingInitiated>(_onLinkingInitiated);
    on<AccountLinkingMobileNumberOtpSubmitted>(_onMobileNumberOtpSubmitted);
    on<AccountLinkingMobileNumberVerificationSubmitted>(
        _onMobileNumberVerificationSubmitted);
  }

  // void _onInitialize(
  //   AccountLinkingInitialized event,
  //   Emitter<AccountLinkingState> emit,
  // ) async {
  //   emit(
  //     state.copyWith(
  //       status: AccountLinkingStatus.isInitializing,
  //     ),
  //   );
  //   try {
  //     final FinvuUserInfo userInfo =
  //         await _finvuManagerInternal.fetchUserInfo();
  //     final List<FinvuFIPInfo> fipInfoList =
  //         await _finvuManager.fipsAllFIPOptions();

  //     // filter out fips which are not enabled.
  //     fipInfoList.retainWhere((fipInfo) => fipInfo.enabled);

  //     final List<String> mobileNumbers = [];
  //     mobileNumbers.add(userInfo.mobileNumber);
  //     emit(
  //       state.copyWith(
  //         userInfo: userInfo,
  //         mobileNumber: userInfo.mobileNumber,
  //         mobileNumbers: mobileNumbers,
  //         fipInfoList: fipInfoList,
  //         status: AccountLinkingStatus.initializingComplete,
  //       ),
  //     );
  //   } on FinvuException catch (err) {
  //     debugPrint("Error while fetcing user info $err");
  //     emit(
  //       state.copyWith(
  //         status: AccountLinkingStatus.error,
  //         error: err.toFinvuError(),
  //       ),
  //     );
  //   } catch (err) {
  //     debugPrint("Error while fetching user info $err");
  //     emit(
  //       state.copyWith(
  //         status: AccountLinkingStatus.error,
  //       ),
  //     );
  //   }
  // }

  void _onFipSelected(
    AccountLinkingFipSelected event,
    Emitter<AccountLinkingState> emit,
  ) {
    emit(
      state.copyWith(
        selectedFipInfo: event.fipInfo,
        status: AccountLinkingStatus.initializingComplete,
      ),
    );
  }

  void _onMobileNumberSelected(
    AccountLinkingMobileNumberSelected event,
    Emitter<AccountLinkingState> emit,
  ) {
    emit(
      state.copyWith(
        mobileNumber: event.mobileNumber,
        status: AccountLinkingStatus.initializingComplete,
      ),
    );
  }

  Future<void> _onMobileNumberAdded(
    AccountLinkingMobileNumberAdded event,
    Emitter<AccountLinkingState> emit,
  ) async {
    try {
      await _finvuManager.initiateMobileVerification(event.newMobileNumber);

      emit(
        state.copyWith(
          mobileNumbers: state.mobileNumbers,
          newMobileNumber: event.newMobileNumber,
          status: AccountLinkingStatus.mobileVerificationOtpSent,
        ),
      );
    } on FinvuException catch (err) {
      debugPrint("Error while adding mobile number $err");
      emit(
        state.copyWith(
          status: AccountLinkingStatus.error,
          error: err.toFinvuError(),
        ),
      );
    } catch (err) {
      debugPrint("Error while adding mobile number $err");
      emit(state.copyWith(status: AccountLinkingStatus.error));
    }
  }

  void _onDiscoveryInitiated(
    AccountLinkingDiscoveryInitiated event,
    Emitter<AccountLinkingState> emit,
  ) async {
    emit(state.copyWith(status: AccountLinkingStatus.isDiscoveringAccounts));
    try {
      final fipDetails =
          await _finvuManager.fetchFIPDetails(state.selectedFipInfo!.fipId);

      final requiredIdentifiers = fipDetails.typeIdentifiers
          .expand(
            (typeIdentifier) => typeIdentifier.identifiers
                .map(
                  (identifier) => Identifier(
                    fiType: typeIdentifier.fiType,
                    type: identifier.type,
                    category: identifier.category,
                  ),
                )
                .toList(),
          )
          .toList()
          .distinctBy((identifier) => identifier.type);

      final List<Identifier> additionalRequiredIdentifiers = requiredIdentifiers
          .where((identifier) => identifier.type != "MOBILE")
          .where((identifier) =>
              !state.typeToAdditionalIdentifierMap.containsKey(identifier.type))
          .toList();

      if (additionalRequiredIdentifiers.isNotEmpty) {
        final Map<String, Identifier> additionalRequiredIdentifiersMap = {
          for (var identifier in additionalRequiredIdentifiers)
            identifier.type: identifier
        };
        emit(
          state.copyWith(
            typeToAdditionalRequiredIdentifierMap:
                additionalRequiredIdentifiersMap,
            status: AccountLinkingStatus.additionalIdentifiersRequired,
          ),
        );
        return;
      }

      final finvuTypeIdentifiers = requiredIdentifiers.map(
        (identifier) {
          if (identifier.type == "MOBILE") {
            return FinvuTypeIdentifierInfo(
              category: identifier.category,
              type: identifier.type,
              value: state.mobileNumber,
            );
          }

          return FinvuTypeIdentifierInfo(
            category: identifier.category,
            type: identifier.type,
            value: state.typeToAdditionalIdentifierMap[identifier.type]!.value!,
          );
        },
      ).toList();

      final discoveredAccounts = await _finvuManager.discoverAccounts(
        state.selectedFipInfo!.fipId,
        state.selectedFipInfo!.fipFitypes.nonNulls.toList(),
        finvuTypeIdentifiers,
      );

      final existingLinkedAccounts = await _finvuManager.fetchLinkedAccounts();
      final linkedAccountIdentifiers = existingLinkedAccounts
          .map((account) =>
              LinkedAccountsIdentifierUtil().generateAccountIdentifier(
                fiType: account.fiType,
                maskedAccountNumber: account.maskedAccountNumber,
                accountType: account.accountType,
              ))
          .toSet();

      final presentIdentifiers = <String>{};
      final discoveredAccountsWithStatus = discoveredAccounts
          .where((account) {
            final accountIdentifier =
                LinkedAccountsIdentifierUtil().generateAccountIdentifier(
              fiType: account.fiType,
              maskedAccountNumber: account.maskedAccountNumber,
              accountType: account.accountType,
            );
            if (presentIdentifiers.contains(accountIdentifier)) return false;
            presentIdentifiers.add(accountIdentifier);
            return true;
          })
          .map((account) => DiscoveredAccountInfo.from(
                account,
                linkedAccountIdentifiers.contains(
                  LinkedAccountsIdentifierUtil().generateAccountIdentifier(
                    fiType: account.fiType,
                    maskedAccountNumber: account.maskedAccountNumber,
                    accountType: account.accountType,
                  ),
                ),
              ))
          .toList();

      emit(
        state.copyWith(
          selectedFipDetails: fipDetails,
          discoveredAccounts: discoveredAccountsWithStatus,
          status: AccountLinkingStatus.didDiscoverAccounts,
        ),
      );
    } on FinvuException catch (err) {
      debugPrint("Error while discovering accounts ${err.code}");
      emit(
        state.copyWith(
          status: AccountLinkingStatus.error,
          error: err.toFinvuError(),
        ),
      );
    } catch (err) {
      debugPrint("Error while discovering accounts $err");
      emit(state.copyWith(status: AccountLinkingStatus.error));
    }
  }

  void _onAdditionalIdentifierChanged(
    AccountLinkingAdditionalIdentifierChanged event,
    Emitter<AccountLinkingState> emit,
  ) async {
    final typeToAdditionalIdentifierMap = {
      ...state.typeToAdditionalIdentifierMap,
      event.identifier.type: event.identifier,
    };
    emit(
      state.copyWith(
        typeToAdditionalIdentifierMap: typeToAdditionalIdentifierMap,
        status: AccountLinkingStatus.initializingComplete,
      ),
    );
  }

  void _onAdditionalIdentifierSubmitted(
    AccountLinkingAdditionalIdentifierSubmitted event,
    Emitter<AccountLinkingState> emit,
  ) async {
    final typeToAdditionalRequiredIdentifierMap = {
      ...state.typeToAdditionalRequiredIdentifierMap,
    };
    typeToAdditionalRequiredIdentifierMap.remove(event.identifierType);
    if (typeToAdditionalRequiredIdentifierMap.isEmpty) {
      add(const AccountLinkingDiscoveryInitiated());
    } else {
      emit(state.copyWith(status: AccountLinkingStatus.isDiscoveringAccounts));
      emit(
        state.copyWith(
          typeToAdditionalRequiredIdentifierMap:
              typeToAdditionalRequiredIdentifierMap,
          status: AccountLinkingStatus.additionalIdentifiersRequired,
        ),
      );
    }
  }

  void _onLinkingInitiated(
    AccountLinkingInitiated event,
    Emitter<AccountLinkingState> emit,
  ) async {
    emit(state.copyWith(status: AccountLinkingStatus.isLinkingAccounts));

    try {
      final linkingReference = await _finvuManager.linkAccounts(
        state.selectedFipDetails!,
        event.selectedAccounts,
      );
      emit(
        state.copyWith(
          selectedAccounts: event.selectedAccounts,
          linkingReference: linkingReference,
          status: event.shouldResendOtp
              ? AccountLinkingStatus.didReSendOtp
              : AccountLinkingStatus.didSendOtp,
        ),
      );
    } on FinvuException catch (err) {
      debugPrint("Error while linking accounts $err");
      emit(
        state.copyWith(
          status: AccountLinkingStatus.error,
          error: err.toFinvuError(),
        ),
      );
    } catch (err) {
      debugPrint("Error while linking accounts $err");
      emit(state.copyWith(status: AccountLinkingStatus.error));
    }
  }

  void _onMobileNumberOtpSubmitted(
    AccountLinkingMobileNumberOtpSubmitted event,
    Emitter<AccountLinkingState> emit,
  ) async {
    emit(state.copyWith(status: AccountLinkingStatus.isVerifyingOtp));

    try {
      await _finvuManager.confirmAccountLinking(
        state.linkingReference!,
        event.otp,
      );
      emit(state.copyWith(status: AccountLinkingStatus.linkingSuccess));
    } on FinvuException catch (err) {
      debugPrint("Error while verifying OTP during account linking $err");
      emit(
        state.copyWith(
          status: AccountLinkingStatus.error,
          error: err.toFinvuError(),
        ),
      );
    } catch (err) {
      debugPrint("Error while verifying OTP during account linking $err");
      emit(state.copyWith(status: AccountLinkingStatus.error));
    }
  }

  void _onMobileNumberVerificationSubmitted(
    AccountLinkingMobileNumberVerificationSubmitted event,
    Emitter<AccountLinkingState> emit,
  ) async {
    try {
      await _finvuManager.completeMobileVerification(
        event.newMobileNumber,
        event.otp,
      );
      final mobileNumbers = state.mobileNumbers.toList();
      mobileNumbers.add(event.newMobileNumber);
      emit(state.copyWith(
        status: AccountLinkingStatus.mobileVerificatioOtpVerified,
        mobileNumbers: mobileNumbers,
      ));
    } on FinvuException catch (err) {
      debugPrint("Error while verifying OTP during account linking $err");
      emit(
        state.copyWith(
          status: AccountLinkingStatus.error,
          error: err.toFinvuError(),
        ),
      );
    } catch (err) {
      debugPrint("Error while verifying OTP during account linking $err");
      emit(state.copyWith(status: AccountLinkingStatus.error));
    }
  }
}
