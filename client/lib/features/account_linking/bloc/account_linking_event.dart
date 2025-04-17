part of 'account_linking_bloc.dart';

sealed class AccountLinkingEvent extends Equatable {
  const AccountLinkingEvent();

  @override
  List<Object> get props => [];
}

final class AccountLinkingInitialized extends AccountLinkingEvent {
  const AccountLinkingInitialized();
}

final class AccountLinkingFipSelected extends AccountLinkingEvent {
  const AccountLinkingFipSelected(this.fipInfo);

  final FinvuFIPInfo fipInfo;

  @override
  List<Object> get props => [fipInfo];
}

final class AccountLinkingMobileNumberSelected extends AccountLinkingEvent {
  const AccountLinkingMobileNumberSelected(this.mobileNumber);

  final String mobileNumber;

  @override
  List<Object> get props => [mobileNumber];
}

final class AccountLinkingMobileNumberAdded extends AccountLinkingEvent {
  const AccountLinkingMobileNumberAdded(this.newMobileNumber);

  final String newMobileNumber;

  @override
  List<Object> get props => [newMobileNumber];
}

final class AccountLinkingDiscoveryInitiated extends AccountLinkingEvent {
  const AccountLinkingDiscoveryInitiated();
}

final class AccountLinkingInitiated extends AccountLinkingEvent {
  const AccountLinkingInitiated(this.selectedAccounts, { this.shouldResendOtp = false });

  final List<FinvuDiscoveredAccountInfo> selectedAccounts;
  final bool shouldResendOtp;

  @override
  List<Object> get props => [selectedAccounts, shouldResendOtp];
}


final class AccountLinkingMobileNumberOtpSubmitted extends AccountLinkingEvent {
  const AccountLinkingMobileNumberOtpSubmitted(this.otp);

  final String otp;

  @override
  List<Object> get props => [otp];
}

final class AccountLinkingMobileNumberVerificationSubmitted
    extends AccountLinkingEvent {
  const AccountLinkingMobileNumberVerificationSubmitted(
      this.otp, this.newMobileNumber);

  final String otp;
  final String newMobileNumber;

  @override
  List<Object> get props => [otp, newMobileNumber];
}

final class AccountLinkingAdditionalIdentifierChanged
    extends AccountLinkingEvent {
  const AccountLinkingAdditionalIdentifierChanged(this.identifier);

  final Identifier identifier;

  @override
  List<Object> get props => [identifier];
}

final class AccountLinkingAdditionalIdentifierSubmitted
    extends AccountLinkingEvent {
  const AccountLinkingAdditionalIdentifierSubmitted(this.identifierType);

  final String identifierType;

  @override
  List<Object> get props => [identifierType];
}
