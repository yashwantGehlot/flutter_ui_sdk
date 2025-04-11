import 'package:finvu_flutter_sdk/app.dart';
import 'package:finvu_flutter_sdk/config/finvu_app_config.dart';
import 'package:flutter/material.dart';
import 'common/utils/remote_config_service.dart';

void mainCommon(Environment environment) async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initialize(environment);
  runApp(const FinvuApp());
}

Future<void> _initialize(Environment environment) async {
  await FinvuAppConfig.initialize(environment);
  final remoteConfigService = RemoteConfigService();
  await remoteConfigService.initialize();
}
