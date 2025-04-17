part of 'home_bloc.dart';

enum HomeStatus {
  unknown,
  isFetchingPendingConsents,
  pendingConsentsFetched,
  error,
}

class HomeState extends Equatable {
  final HomeStatus status;
  final int errorTimestamp;
  final List<LinkedAccountInfo> bankAccounts;
  final List<LinkedAccountInfo> equityHoldings;
  final List<LinkedAccountInfo> insurancePolicies;
  final FinvuError? error;

  const HomeState({
    this.status = HomeStatus.unknown,
    this.errorTimestamp = 0,
    this.bankAccounts = const [],
    this.equityHoldings = const [],
    this.insurancePolicies = const [],
    this.error,
  });

  HomeState copyWith({
    HomeStatus? status,
    List<LinkedAccountInfo>? bankAccounts,
    List<LinkedAccountInfo>? equityHoldings,
    List<LinkedAccountInfo>? insurancePolicies,
    FinvuError? error,
  }) {
    int errorTimestamp = this.errorTimestamp;
    if (status == HomeStatus.error) {
      errorTimestamp = DateTime.now().millisecondsSinceEpoch;
    }

    return HomeState(
      status: status ?? this.status,
      bankAccounts: bankAccounts ?? this.bankAccounts,
      equityHoldings: equityHoldings ?? this.equityHoldings,
      insurancePolicies: insurancePolicies ?? this.insurancePolicies,
      errorTimestamp: errorTimestamp,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
        status,
        errorTimestamp,
        bankAccounts,
        equityHoldings,
        insurancePolicies,
        error,
      ];
}
