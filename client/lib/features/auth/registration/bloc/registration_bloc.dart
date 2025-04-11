import 'package:equatable/equatable.dart';
import 'package:finvu_flutter_sdk/config/finvu_app_config.dart';
import 'package:finvu_flutter_sdk/finvu_config.dart';
import 'package:finvu_flutter_sdk/finvu_manager.dart';
import 'package:finvu_flutter_sdk_core/finvu_exception.dart';
import 'package:finvu_flutter_sdk_internal/finvu_manager_internal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'registration_event.dart';
part 'registration_state.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  final FinvuManagerInternal _finvuManagerInternal = FinvuManagerInternal();
  final FinvuManager _finvuManager = FinvuManager();

  RegistrationBloc() : super(const RegistrationState()) {
    on<RegistrationAAHandleChanged>(_onAAHandleChanged);
    on<RegistrationPasscodeChanged>(_onPasscodeChanged);
    on<RegistrationConfirmPasscodeChanged>(_onConfirmPasscodeChanged);
    on<RegistrationMobileNumberChanged>(_onMobileNumberChanged);
    on<RegistrationTermsAcceptanceChanged>(_onTermsAcceptanceChanged);
    on<RegistrationRegisterClicked>(_onRegisterClicked);
    on<InitializeEvent>(_onInitialize);
  }

  Future<void> _onInitialize(
    InitializeEvent event,
    Emitter<RegistrationState> emit,
  ) async {
    try {
      var isConnected = await _finvuManager.isConnected();
      if (!isConnected) {
        _finvuManager.initialize(
          FinvuConfig(
            finvuEndpoint: FinvuAppConfig.apiUrl,
            certificatePins: FinvuAppConfig.certificatePins,
          ),
        );

        await _finvuManager.connect();
      }
      emit(state.copyWith(status: RegistrationStatus.connectionEstablished));
    } on FinvuException catch (err) {
      debugPrint("err when trying to connect ${err.code}");
      emit(state.copyWith(status: RegistrationStatus.error));
    }
  }

  void _onAAHandleChanged(
    RegistrationAAHandleChanged event,
    Emitter<RegistrationState> emit,
  ) {
    emit(state.copyWith(
      aaHandle: event.aaHandle,
      status: RegistrationStatus.unknown,
    ));
  }

  void _onMobileNumberChanged(
    RegistrationMobileNumberChanged event,
    Emitter<RegistrationState> emit,
  ) {
    emit(state.copyWith(
      mobileNumber: event.mobileNumber,
      status: RegistrationStatus.unknown,
    ));
  }

  void _onPasscodeChanged(
    RegistrationPasscodeChanged event,
    Emitter<RegistrationState> emit,
  ) {
    emit(state.copyWith(
      passcode: event.passcode,
      doesPasscodeMatch:
          !state.doesPasscodeMatch && event.passcode == state.confirmPasscode
              ? true
              : state.doesPasscodeMatch,
      status: RegistrationStatus.unknown,
    ));
  }

  void _onConfirmPasscodeChanged(
    RegistrationConfirmPasscodeChanged event,
    Emitter<RegistrationState> emit,
  ) {
    emit(state.copyWith(
      confirmPasscode: event.passcode,
      doesPasscodeMatch:
          !state.doesPasscodeMatch && event.passcode == state.passcode
              ? true
              : state.doesPasscodeMatch,
      status: RegistrationStatus.unknown,
    ));
  }

  void _onTermsAcceptanceChanged(
    RegistrationTermsAcceptanceChanged event,
    Emitter<RegistrationState> emit,
  ) {
    emit(state.copyWith(
      didAcceptTerms: event.didAccept,
      status: RegistrationStatus.unknown,
    ));
  }

  void _onRegisterClicked(
    RegistrationRegisterClicked event,
    Emitter<RegistrationState> emit,
  ) async {
    final doesPasscodeMatch = state.passcode == state.confirmPasscode;

    if (!doesPasscodeMatch) {
      emit(state.copyWith(
        status: state.status,
        doesPasscodeMatch: doesPasscodeMatch,
      ));
      return;
    }

    emit(state.copyWith(
      status: RegistrationStatus.isRegistering,
    ));

    // Check whether any of the mandatory field is empty and terms are not accepted.
    if (state.aaHandle.isEmpty ||
        state.aaHandle == '@finvu' ||
        state.mobileNumber.isEmpty ||
        state.passcode.isEmpty ||
        state.confirmPasscode.isEmpty ||
        !state.didAcceptTerms) {
      emit(state.copyWith(
        status: RegistrationStatus.emptyFields,
      ));
      return;
    }

    try {
      await _finvuManagerInternal.register(
        state.aaHandle,
        state.mobileNumber,
        state.passcode,
      );

      emit(state.copyWith(
        status: RegistrationStatus.success,
      ));
    } catch (err) {
      debugPrint("Error while verifying OTP $err");
      emit(state.copyWith(
        status: RegistrationStatus.error,
      ));
    }
  }
}
