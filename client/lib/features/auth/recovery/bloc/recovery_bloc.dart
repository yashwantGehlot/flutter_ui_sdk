import 'package:equatable/equatable.dart';
import 'package:finvu_flutter_sdk/common/utils/remote_config_service.dart';
import 'package:finvu_flutter_sdk/common/utils/secure_storage_util.dart';
import 'package:finvu_flutter_sdk/common/utils/totp_generator.dart';
import 'package:finvu_flutter_sdk/config/finvu_app_config.dart';
import 'package:finvu_flutter_sdk/finvu_config.dart';
import 'package:finvu_flutter_sdk/finvu_manager.dart';
import 'package:finvu_flutter_sdk_core/finvu_exception.dart';
import 'package:finvu_flutter_sdk_internal/finvu_manager_internal.dart';
import 'package:finvu_flutter_sdk/common/models/finvu_error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'recovery_event.dart';
part 'recovery_state.dart';

class RecoveryBloc extends Bloc<RecoveryEvent, RecoveryState> {
  final FinvuManagerInternal _finvuManagerInternal = FinvuManagerInternal();
  final FinvuManager _finvuManager = FinvuManager();
  final storage = SecureStorageUtil();
  final remoteConfig = RemoteConfigService();

  RecoveryBloc() : super(const RecoveryState()) {
    on<InitializeEvent>(_onInitialize);
    on<RecoveryAAHandleChanged>(_onAAHandleChanged);
    on<RecoveryNewPasscodeChanged>(_onNewPasscodeChanged);
    on<RecoveryConfirmNewPasscodeChanged>(_onConfirmNewPasscodeChanged);
    on<RecoveryMobileNumberChanged>(_onMobileNumberChanged);
    on<RecoveryOTPChanged>(_onOTPChanged);

    on<RecoveryForgotAaHandleClicked>(_onForgotAaHandleClicked);
    on<RecoveryForgotPasscodeClicked>(_onForgotPasscodeClicked);

    on<RecoveryGetOtpClicked>(_onGetOtpClicked);
    on<RecoveryOTPSubmitted>(_onOtpSubmitted);

    on<LoginWithRecoveredAaHandle>(_onLoginWithRecoveredAaHandle);
  }

  Future<void> _onInitialize(
    InitializeEvent event,
    Emitter<RecoveryState> emit,
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
      emit(state.copyWith(status: RecoveryStatus.connectionEstablished));
    } on FinvuException catch (err) {
      debugPrint("err when trying to connect ${err.code}");
      final error = err.toFinvuError();
      emit(state.copyWith(status: RecoveryStatus.error, error: error));
    }
  }

  void _onLoginWithRecoveredAaHandle(
    LoginWithRecoveredAaHandle event,
    Emitter<RecoveryState> emit,
  ) async {
    emit(state.copyWith(status: RecoveryStatus.isLoggingIn));
    try {
      if (remoteConfig.deviceBindingEnabled) {
        final secret = await storage.read(storage.SECRET_KEY);
        final deviceID = await storage.read(storage.DEVICE_ID_KEY);
        String? totp;
        if (secret != null) {
          totp = TOTPGenerator().generateTOTP(secret);
        }
        final loginResponse =
            await _finvuManagerInternal.loginWithUsernameAndPasscode(
          state.aaHandle,
          state.newPasscode,
          totp,
          deviceID,
        );

        if (remoteConfig.deviceBindingAPIEnabled) {
          if (loginResponse.deviceBindingValid != true) {
            var userInfo = await _finvuManagerInternal.fetchUserInfo();
            emit(
              state.copyWith(
                status: RecoveryStatus.needAuthentication,
                mobileNumber: userInfo.mobileNumber,
              ),
            );
          } else {
            emit(state.copyWith(status: RecoveryStatus.loggedIn));
          }
        } else {
          emit(state.copyWith(status: RecoveryStatus.loggedIn));
        }
      } else {
        await _finvuManagerInternal.loginWithUsernameAndPasscode(
          state.aaHandle,
          state.newPasscode,
          null,
          null,
        );
        emit(state.copyWith(status: RecoveryStatus.loggedIn));
      }
    } on FinvuException catch (err) {
      debugPrint("Error while logging in ${err.code}");
      emit(
        state.copyWith(
          status: RecoveryStatus.error,
          error: err.toFinvuError(),
        ),
      );
    } catch (err) {
      debugPrint("Error while logging in $err");
      emit(state.copyWith(status: RecoveryStatus.error));
    }
  }

  void _onAAHandleChanged(
    RecoveryAAHandleChanged event,
    Emitter<RecoveryState> emit,
  ) {
    emit(state.copyWith(
      aaHandle: event.aaHandle,
      status: RecoveryStatus.unknown,
    ));
  }

  void _onNewPasscodeChanged(
    RecoveryNewPasscodeChanged event,
    Emitter<RecoveryState> emit,
  ) {
    emit(state.copyWith(
      newPasscode: event.passcode,
      doesPasscodeMatch:
          !state.doesPasscodeMatch && event.passcode == state.confirmNewPasscode
              ? true
              : state.doesPasscodeMatch,
      status: RecoveryStatus.otpSent,
    ));
  }

  void _onConfirmNewPasscodeChanged(
    RecoveryConfirmNewPasscodeChanged event,
    Emitter<RecoveryState> emit,
  ) {
    emit(state.copyWith(
      confirmNewPasscode: event.passcode,
      doesPasscodeMatch:
          !state.doesPasscodeMatch && event.passcode == state.newPasscode
              ? true
              : state.doesPasscodeMatch,
      status: RecoveryStatus.otpSent,
    ));
  }

  void _onMobileNumberChanged(
    RecoveryMobileNumberChanged event,
    Emitter<RecoveryState> emit,
  ) {
    emit(state.copyWith(
      mobileNumber: event.mobileNumber,
      status: RecoveryStatus.unknown,
    ));
  }

  void _onOTPChanged(
    RecoveryOTPChanged event,
    Emitter<RecoveryState> emit,
  ) {
    emit(state.copyWith(otp: event.otp, status: RecoveryStatus.otpSent));
  }

  void _onOtpSubmitted(
    RecoveryOTPSubmitted event,
    Emitter<RecoveryState> emit,
  ) async {
    final doesPasscodeMatch = state.newPasscode == state.confirmNewPasscode;

    if (!doesPasscodeMatch) {
      emit(state.copyWith(
        status: state.status,
        doesPasscodeMatch: doesPasscodeMatch,
      ));
      return;
    }

    emit(state.copyWith(status: RecoveryStatus.isVerifyingOtp));

    try {
      if (state.type == RecoveryType.aaHandle) {
        final finvuHandleInfo =
            await _finvuManagerInternal.verifyForgotHandleOTP(state.otp);
        emit(
          state.copyWith(
            status: RecoveryStatus.userIdsFound,
            userIds: finvuHandleInfo.userIds,
          ),
        );
      } else {
        await _finvuManagerInternal.verifyForgotPasscodeOTP(
          state.aaHandle,
          state.mobileNumber,
          state.otp,
          state.newPasscode,
        );

        if (remoteConfig.deviceBindingEnabled) {
          final secret = await storage.read(storage.SECRET_KEY);
          final deviceID = await storage.read(storage.DEVICE_ID_KEY);
          String? totp;
          if (secret != null) {
            totp = TOTPGenerator().generateTOTP(secret);
          }
          final loginResponse =
              await _finvuManagerInternal.loginWithUsernameAndPasscode(
            state.aaHandle,
            state.newPasscode,
            totp,
            deviceID,
          );

          if (remoteConfig.deviceBindingAPIEnabled) {
            if (loginResponse.deviceBindingValid != true) {
              var userInfo = await _finvuManagerInternal.fetchUserInfo();
              emit(
                state.copyWith(
                  status: RecoveryStatus.needAuthentication,
                  mobileNumber: userInfo.mobileNumber,
                ),
              );
            } else {
              emit(state.copyWith(status: RecoveryStatus.loggedIn));
            }
          } else {
            emit(state.copyWith(status: RecoveryStatus.loggedIn));
          }
        } else {
          await _finvuManagerInternal.loginWithUsernameAndPasscode(
            state.aaHandle,
            state.newPasscode,
            null,
            null,
          );
          emit(state.copyWith(status: RecoveryStatus.loggedIn));
        }
      }
    } on FinvuException catch (err) {
      debugPrint("Error while verifying OTP ${err.code}");
      emit(
        state.copyWith(
          status: RecoveryStatus.error,
          error: err.toFinvuError(),
        ),
      );
    } catch (err) {
      debugPrint("Error while verifying OTP $err");
      emit(state.copyWith(status: RecoveryStatus.error));
    }
  }

  void _onForgotAaHandleClicked(
    RecoveryForgotAaHandleClicked event,
    Emitter<RecoveryState> emit,
  ) async {
    emit(state.copyWith(
      type: RecoveryType.aaHandle,
      status: RecoveryStatus.unknown,
    ));
  }

  void _onForgotPasscodeClicked(
    RecoveryForgotPasscodeClicked event,
    Emitter<RecoveryState> emit,
  ) async {
    emit(state.copyWith(
      type: RecoveryType.passcode,
      status: RecoveryStatus.unknown,
    ));
  }

  void _onGetOtpClicked(
    RecoveryGetOtpClicked event,
    Emitter<RecoveryState> emit,
  ) async {
    emit(
      state.copyWith(
        status: !event.resend
            ? RecoveryStatus.isSendingOtp
            : RecoveryStatus.isResendingOtp,
      ),
    );
    try {
      if (state.type == RecoveryType.aaHandle) {
        await _finvuManagerInternal
            .initiateForgotHandleRequest(state.mobileNumber);
      } else {
        await _finvuManagerInternal.initiateForgotPasscodeRequest(
          state.aaHandle,
          state.mobileNumber,
        );
      }
      emit(state.copyWith(status: RecoveryStatus.otpSent));
    } on FinvuException catch (err) {
      debugPrint("Error while forgot handle ${err.code}");
      final error = err.toFinvuError();
      emit(
        state.copyWith(
          status: RecoveryStatus.error,
          error: error,
        ),
      );
    } catch (err) {
      debugPrint("Error while recovery $err");
      emit(state.copyWith(status: RecoveryStatus.error));
    }
  }
}
