import 'package:finvu_flutter_sdk/app.dart';
import 'package:finvu_flutter_sdk/config/finvu_app_config.dart';
import 'package:flutter/material.dart';

void mainCommon(Environment environment) async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initialize(environment);
  // runApp(FinvuApp(
  //   environment: environment,
  // ));
}

Future<void> _initialize(Environment environment) async {
  await FinvuAppConfig.initialize(environment);
}
