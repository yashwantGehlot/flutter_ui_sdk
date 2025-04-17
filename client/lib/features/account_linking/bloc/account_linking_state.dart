part of 'account_linking_bloc.dart';

enum AccountLinkingStatus {
  unknown,
  isInitializing,
  initializingComplete,
  mobileNumberAdded,
  mobileVerificationOtpSent,
  mobileVerificatioOtpVerified,
  isDiscoveringAccounts,
  didDiscoverAccounts,
  additionalIdentifiersRequired,
  isLinkingAccounts,
  didSendOtp,
  didReSendOtp,
  isVerifyingOtp,
  linkingSuccess,
  error,
}

final class AccountLinkingState extends Equatable {
  final FinvuFIPInfo? selectedFipInfo;
  final FinvuFIPDetails? selectedFipDetails;
  final List<String> availableAccounts;
  final List<FinvuDiscoveredAccountInfo> selectedAccounts;
  final List<String> mobileNumbers;
  final String mobileNumber;
  final String mobileNumberOtp;
  final String newMobileNumber;
  final AccountLinkingStatus status;
  final int errorTimestamp;
  final FinvuUserInfo? userInfo;
  final List<FinvuFIPInfo> fipInfoList;
  final Map<String, Identifier> typeToAdditionalRequiredIdentifierMap;
  final List<DiscoveredAccountInfo> discoveredAccounts;
  final Map<String, Identifier> typeToAdditionalIdentifierMap;
  final FinvuAccountLinkingRequestReference? linkingReference;
  final FinvuError? error;

  const AccountLinkingState({
    this.selectedFipInfo,
    this.selectedFipDetails,
    this.availableAccounts = const [],
    this.selectedAccounts = const [],
    this.mobileNumbers = const [],
    this.mobileNumber = "",
    this.newMobileNumber = "",
    this.mobileNumberOtp = "",
    this.status = AccountLinkingStatus.unknown,
    this.errorTimestamp = 0,
    this.userInfo,
    this.fipInfoList = const [],
    this.typeToAdditionalRequiredIdentifierMap = const {},
    this.discoveredAccounts = const [],
    this.typeToAdditionalIdentifierMap = const {},
    this.linkingReference,
    this.error,
  });

  AccountLinkingState copyWith({
    FinvuFIPInfo? selectedFipInfo,
    FinvuFIPDetails? selectedFipDetails,
    List<String>? availableAccounts,
    List<FinvuDiscoveredAccountInfo>? selectedAccounts,
    String? mobileNumber,
    String? newMobileNumber,
    String? mobileNumberOtp,
    List<String>? mobileNumbers,
    FinvuUserInfo? userInfo,
    List<FinvuFIPInfo>? fipInfoList,
    Map<String, Identifier>? typeToAdditionalRequiredIdentifierMap,
    List<DiscoveredAccountInfo>? discoveredAccounts,
    Map<String, Identifier>? typeToAdditionalIdentifierMap,
    FinvuAccountLinkingRequestReference? linkingReference,
    FinvuError? error,
    required AccountLinkingStatus status,
  }) {
    int errorTimestamp = this.errorTimestamp;
    if (status == AccountLinkingStatus.error) {
      errorTimestamp = DateTime.now().millisecondsSinceEpoch;
    }

    return AccountLinkingState(
      userInfo: userInfo ?? this.userInfo,
      selectedFipInfo: selectedFipInfo ?? this.selectedFipInfo,
      selectedFipDetails: selectedFipDetails ?? this.selectedFipDetails,
      availableAccounts: availableAccounts ?? this.availableAccounts,
      selectedAccounts: selectedAccounts ?? this.selectedAccounts,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      newMobileNumber: newMobileNumber ?? this.newMobileNumber,
      mobileNumberOtp: mobileNumberOtp ?? this.mobileNumberOtp,
      mobileNumbers: mobileNumbers ?? this.mobileNumbers,
      status: status,
      errorTimestamp: errorTimestamp,
      fipInfoList: fipInfoList ?? this.fipInfoList,
      typeToAdditionalRequiredIdentifierMap:
          typeToAdditionalRequiredIdentifierMap ??
              this.typeToAdditionalRequiredIdentifierMap,
      discoveredAccounts: discoveredAccounts ?? this.discoveredAccounts,
      typeToAdditionalIdentifierMap:
          typeToAdditionalIdentifierMap ?? this.typeToAdditionalIdentifierMap,
      linkingReference: linkingReference ?? this.linkingReference,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
        selectedFipInfo,
        selectedFipDetails,
        availableAccounts,
        selectedAccounts,
        mobileNumber,
        newMobileNumber,
        mobileNumberOtp,
        mobileNumbers,
        status,
        errorTimestamp,
        userInfo,
        fipInfoList,
        typeToAdditionalRequiredIdentifierMap,
        discoveredAccounts,
        typeToAdditionalIdentifierMap,
        linkingReference,
        error,
      ];
}
