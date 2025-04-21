import 'package:equatable/equatable.dart';
import 'package:finvu_flutter_sdk/common/models/finvu_error.dart';
import 'package:finvu_flutter_sdk/common/utils/secure_storage_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashInitial()) {
    on<SplashLoading>(_onSplashLoading);
  }

  Future<void> _onSplashLoading(
    SplashLoading event,
    Emitter<SplashState> emit,
  ) async {
    emit(SplashNavigateLogin());
  }
}
