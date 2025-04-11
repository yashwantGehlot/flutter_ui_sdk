part of 'profile_bloc.dart';

enum ProfileStatus {
  profileFetched,
  logoutInitiated,
  logoutComplete,
  closeFinvuAccountInitiated,
  closeFinvuAccountCompleted,
  logoutError,
  error,
  unknown
}

final class ProfileState extends Equatable {
  final String userId;
  final String mobileNumber;
  final ProfileStatus status;
  final int errorTimestamp;
  final FinvuError? error;

  const ProfileState({
    this.userId = "",
    this.mobileNumber = "",
    this.status = ProfileStatus.unknown,
    this.errorTimestamp = 0,
    this.error,
  });

  ProfileState copyWith({
    String? userId,
    String? mobileNumber,
    required ProfileStatus status,
    FinvuError? error,
  }) {
    int errorTimestamp = this.errorTimestamp;
    if (status == ProfileStatus.error) {
      errorTimestamp = DateTime.now().millisecondsSinceEpoch;
    }
    return ProfileState(
      userId: userId ?? this.userId,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      status: status,
      errorTimestamp: errorTimestamp,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
        userId,
        mobileNumber,
        status,
        errorTimestamp,
        error,
      ];
}
