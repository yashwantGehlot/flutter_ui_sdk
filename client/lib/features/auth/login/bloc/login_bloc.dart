import 'package:equatable/equatable.dart';
import 'package:finvu_flutter_sdk/common/models/finvu_error.dart';
import 'package:finvu_flutter_sdk/common/utils/remote_config_service.dart';
import 'package:finvu_flutter_sdk/common/utils/secure_storage_util.dart';
import 'package:finvu_flutter_sdk/common/utils/totp_generator.dart';
import 'package:finvu_flutter_sdk/config/finvu_app_config.dart';
import 'package:finvu_flutter_sdk/finvu_config.dart';
import 'package:finvu_flutter_sdk/finvu_manager.dart';
import 'package:finvu_flutter_sdk_core/finvu_exception.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final FinvuManager _finvuManager = FinvuManager();
//  final storage = SecureStorageUtil();
  final remoteConfig = RemoteConfigService();

  LoginBloc() : super(const LoginState()) {
    on<InitializeEvent>(_onInitialize);
    on<LoginAAHandleChanged>(_onAAHandleChanged);
    on<LoginPasscodeChanged>(_onPasscodeChanged);
    on<LoginAAHandlePasscodeSubmitted>(_onAAHandlePasscodeSubmitted);

    on<LoginMobileNumberChanged>(_onMobileNumberChanged);
    on<LoginOTPChanged>(_onOTPChanged);
    on<LoginMobileNumberSubmitted>(_onMobileNumberSubmitted);
    on<LoginOTPSubmitted>(_onOtpSubmittedSubmitted);
    on<LoginMobileVerificationInitiated>(_onMobileNumberVerificationInitiated);
    on<LoginMobileVerificationComplete>(_onMobileNumberVerificationComplete);
  }

  Future<void> _onInitialize(
    InitializeEvent event,
    Emitter<LoginState> emit,
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
      emit(state.copyWith(status: LoginStatus.connectionEstablished));
    } on FinvuException catch (err) {
      debugPrint("err when trying to connect ${err.code}");
      final error = err.toFinvuError();
      emit(state.copyWith(status: LoginStatus.error, error: error));
    }
  }

  void _onAAHandleChanged(
    LoginAAHandleChanged event,
    Emitter<LoginState> emit,
  ) {
    emit(state.copyWith(aaHandle: event.aaHandle, status: LoginStatus.unknown));
  }

  void _onPasscodeChanged(
    LoginPasscodeChanged event,
    Emitter<LoginState> emit,
  ) {
    emit(state.copyWith(passcode: event.passcode, status: LoginStatus.unknown));
  }

  void _onAAHandlePasscodeSubmitted(
    LoginAAHandlePasscodeSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(status: LoginStatus.isAuthenticatingUsernamePasscode));
    try {
      await _finvuManager.loginWithUsernameOrMobileNumberAndConsentHandle(
        state.aaHandle,
        "8459177562",
        "6b2423a3-399b-4732-82d4-8e0b8586d8d9",
      );
      emit(state.copyWith(status: LoginStatus.loggedIn));
    } on FinvuException catch (err) {
      debugPrint("Error while login ${err.code}");
      final authError = err.toFinvuError();
      emit(
        state.copyWith(
          status: LoginStatus.error,
          error: authError,
        ),
      );
    } catch (err) {
      debugPrint("Error while login $err");
      emit(
        state.copyWith(
          status: LoginStatus.error,
        ),
      );
    }
  }

  void _onMobileNumberChanged(
    LoginMobileNumberChanged event,
    Emitter<LoginState> emit,
  ) {
    emit(state.copyWith(
        mobileNumber: event.mobileNumber, status: LoginStatus.unknown));
  }

  void _onOTPChanged(
    LoginOTPChanged event,
    Emitter<LoginState> emit,
  ) {
    emit(state.copyWith(otp: event.otp, status: LoginStatus.otpSent));
  }

  void _onMobileNumberSubmitted(
    LoginMobileNumberSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    // TODO: some validation for mobile number
    emit(state.copyWith(status: LoginStatus.isSendingOtp));

    // TODO: make actual network call for send OTP and handle failure
    await Future.delayed(const Duration(seconds: 4));

    emit(state.copyWith(status: LoginStatus.otpSent));
  }

  void _onOtpSubmittedSubmitted(
    LoginOTPSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(status: LoginStatus.isAuthenticatingOtp));

    // TODO: make actual network call for verify OTP and handle failure
    await Future.delayed(const Duration(seconds: 4));
    emit(state.copyWith(status: LoginStatus.loggedIn));
  }

  void _onMobileNumberVerificationInitiated(
    LoginMobileVerificationInitiated event,
    Emitter<LoginState> emit,
  ) async {
    try {
      await _finvuManager.initiateMobileVerification(event.mobileNumber);

      emit(
        state.copyWith(
          mobileNumber: event.mobileNumber,
          status: LoginStatus.isSendingOtp,
        ),
      );
    } catch (err) {
      debugPrint("Error while adding mobile number $err");
      emit(state.copyWith(status: LoginStatus.error));
    }
  }

  void _onMobileNumberVerificationComplete(
    LoginMobileVerificationComplete event,
    Emitter<LoginState> emit,
  ) async {
    try {
      await _finvuManager.completeMobileVerification(
          event.mobileNumber, event.otp);

      emit(
        state.copyWith(
          mobileNumber: state.mobileNumber,
          status: LoginStatus.mobileNumberVerified,
        ),
      );
    } catch (err) {
      debugPrint("Error while verifing otp");
      emit(
        state.copyWith(
          status: LoginStatus.invalidOtp,
        ),
      );
    }
  }
}
