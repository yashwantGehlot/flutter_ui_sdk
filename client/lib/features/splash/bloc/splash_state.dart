part of 'splash_bloc.dart';

enum SplashStatus { unknown, error }

final class SplashState extends Equatable {
  final FinvuError? error;
  final SplashStatus status;

  const SplashState({
    this.error,
    this.status = SplashStatus.unknown,
  });

  SplashState copyWith({
    FinvuError? error,
    required SplashStatus status,
  }) {
    return SplashState(
      error: error ?? this.error,
      status: status,
    );
  }

  @override
  List<Object?> get props => [
        error,
        status,
      ];
}

final class SplashInitial extends SplashState {}

final class SplashNavigateLogin extends SplashState {}
