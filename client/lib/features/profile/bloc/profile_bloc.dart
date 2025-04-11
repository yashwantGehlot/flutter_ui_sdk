import 'package:equatable/equatable.dart';
import 'package:finvu_flutter_sdk/common/models/finvu_error.dart';
import 'package:finvu_flutter_sdk/finvu_manager.dart';
import 'package:finvu_flutter_sdk_core/finvu_exception.dart';
import 'package:finvu_flutter_sdk_core/finvu_user_info.dart';
import 'package:finvu_flutter_sdk_internal/finvu_manager_internal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final FinvuManager _finvuManager = FinvuManager();
  final FinvuManagerInternal _finvuManagerInternal = FinvuManagerInternal();

  ProfileBloc() : super(const ProfileState()) {
    on<ProfileLoading>(_onProfileLoading);
    on<LogoutInitiated>(_onLogoutInitiated);
    on<CloseFinvuAccountInitiated>(_onCloseFinvuAccount);
  }

  Future<void> _onProfileLoading(
    ProfileLoading event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      final FinvuUserInfo userInfo =
          await _finvuManagerInternal.fetchUserInfo();

      emit(
        state.copyWith(
          userId: userInfo.userId,
          mobileNumber: userInfo.mobileNumber,
          status: ProfileStatus.profileFetched,
        ),
      );
    } on FinvuException catch (err) {
      debugPrint("Error while fetcing user info $err");
      emit(
        state.copyWith(
          status: ProfileStatus.error,
          error: err.toFinvuError(),
        ),
      );
    } catch (err) {
      debugPrint("Error while fetching user info $err");
      emit(
        state.copyWith(
          status: ProfileStatus.error,
        ),
      );
    }
  }

  void _onLogoutInitiated(
    LogoutInitiated event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(
        state.copyWith(
          status: ProfileStatus.logoutInitiated,
        ),
      );
      await _finvuManager.logout();
      emit(
        state.copyWith(
          status: ProfileStatus.logoutComplete,
        ),
      );
    } on FinvuException catch (err) {
      debugPrint("Error while logout $err");
      emit(
        state.copyWith(
          status: ProfileStatus.error,
          error: err.toFinvuError(),
        ),
      );
    } catch (err) {
      debugPrint("Error while logging out $err");
      emit(
        state.copyWith(
          status: ProfileStatus.logoutError,
        ),
      );
    }
  }

  void _onCloseFinvuAccount(
    CloseFinvuAccountInitiated event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(
        state.copyWith(
          status: ProfileStatus.closeFinvuAccountInitiated,
        ),
      );
      await _finvuManagerInternal.closeFinvuAccount(event.password);
      emit(
        state.copyWith(
          status: ProfileStatus.closeFinvuAccountCompleted,
        ),
      );
    } on FinvuException catch (err) {
      debugPrint("Error while closing account $err");
      emit(
        state.copyWith(
          status: ProfileStatus.error,
          error: err.toFinvuError(),
        ),
      );
    } catch (err) {
      debugPrint("Error while closing account $err");
      emit(
        state.copyWith(
          status: ProfileStatus.error,
        ),
      );
    }
  }
}
