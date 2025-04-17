import 'package:equatable/equatable.dart';
import 'package:finvu_flutter_sdk/common/models/finvu_error.dart';
import 'package:finvu_flutter_sdk/common/utils/secure_storage_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otpless_flutter/otpless_flutter.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final _otplessFlutterPlugin = Otpless();
  SplashBloc() : super(SplashInitial()) {
    on<SplashLoading>(_onSplashLoading);
  }

  Future<void> _onSplashLoading(
    SplashLoading event,
    Emitter<SplashState> emit,
  ) async {
    // List<Map<String, dynamic>> data =
    //     await _otplessFlutterPlugin.getEjectedSimEntries();
    // debugPrint("OTPLESS: Ejected Sim Entries $data");

    // checkAbsentTimeStamp(data);

    // _otplessFlutterPlugin.setSimEventListener((data) {
    //   checkAbsentTimeStamp(data);
    //   debugPrint("OTPLESS: Ejected Sim Listener Data:  $data");
    // });

    emit(SplashNavigateLogin());
  }

  // void checkAbsentTimeStamp(List<Map<String, dynamic>> data) async {
  //   var storage = SecureStorageUtil();
  //   var secret = await storage.read(storage.SECRET_KEY);

  //   if (secret != null) {
  //     String? storedAbsentTransactionTime =
  //         await storage.read(storage.SECRET_TIMESTAMP_KEY);

  //     String? firstAbsentTransactionTime;

  //     // Find the first occurrence of ABSENT
  //     for (var item in data) {
  //       if (item['state'] == 'ABSENT') {
  //         firstAbsentTransactionTime = item['transactionTime'].toString();
  //         break; // Exit after finding the first "ABSENT"
  //       }
  //     }

  //     // If we found an "ABSENT" entry, proceed to compare it
  //     if (firstAbsentTransactionTime != null) {
  //       if (storedAbsentTransactionTime == null ||
  //           (int.parse(firstAbsentTransactionTime) >
  //               int.parse(storedAbsentTransactionTime))) {
  //         await storage.delete(storage.SECRET_TIMESTAMP_KEY);
  //         await storage.delete(storage.DEVICE_ID_KEY);
  //         await storage.delete(storage.SECRET_KEY);
  //       }
  //     }
  //   }
  // }
}
