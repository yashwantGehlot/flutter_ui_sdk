import 'package:equatable/equatable.dart';
import 'package:finvu_flutter_sdk_internal/finvu_manager_internal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'change_password_event.dart';
part 'change_password_state.dart';

class ChangePasswordBloc
    extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  final FinvuManagerInternal _finvuManagerInternal = FinvuManagerInternal();

  ChangePasswordBloc() : super(const ChangePasswordState()) {
    on<ChangePasswordSubmit>(_onPasswordSubmitted);
  }

  void _onPasswordSubmitted(
    ChangePasswordSubmit event,
    Emitter<ChangePasswordState> emit,
  ) async {
    try {
      await _finvuManagerInternal.changePasscodeRequest(
          event.currentPasscode, event.newPasscode);
      emit(state.copyWith(status: ChangePasswordStatus.success));
    } catch (err) {
      debugPrint("Error while changing password $err");
      emit(state.copyWith(status: ChangePasswordStatus.error));
    }
  }
}
