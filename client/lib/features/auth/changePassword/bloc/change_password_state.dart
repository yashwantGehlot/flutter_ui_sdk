part of 'change_password_bloc.dart';

enum ChangePasswordStatus { unknown, error, success }

final class ChangePasswordState extends Equatable {
  final ChangePasswordStatus status;

  const ChangePasswordState({
    this.status = ChangePasswordStatus.unknown,
  });

  ChangePasswordState copyWith({
    required ChangePasswordStatus status,
  }) {
    return ChangePasswordState(
      status: status,
    );
  }

  @override
  List<Object> get props => [status];
}
