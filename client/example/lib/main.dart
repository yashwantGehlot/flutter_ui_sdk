import 'package:finvu_flutter_sdk/finvu_config.dart';
import 'package:finvu_flutter_sdk/finvu_manager.dart';
import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final FinvuManager _finvuManager = FinvuManager();
  final TextEditingController _controller = TextEditingController();
  String otpReference = "";
  String _displayText = '';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  void _onPress() {
    setState(() {
      _displayText = _controller.text;
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  void _initFinvuManager() async {
    var isConnected = await _finvuManager.isConnected();
    if (!isConnected) {
      _finvuManager.initialize(
        FinvuConfig(
          finvuEndpoint: 'wss://webvwdev.finvu.in/consentapi',
          certificatePins: [
            "wvA3hq0mPnRbojshLn3F8fDbaEt9VqG8GYI1dzvJAgc=",
            "K7rZOrXHknnsEhUH8nLL4MZkejquUuIvOIr6tCa0rbo="
          ],
        ),
      );

      var connected = await _finvuManager.connect();
      debugPrint('Connected');
    }
  }

  void login() async {
    var login =
        await _finvuManager.loginWithUsernameOrMobileNumberAndConsentHandle(
      '7338500280@finvu',
      null,
      '10615d19-0e85-453b-8c4b-0f9dc86e512d',
    );

    otpReference = login.reference;

    debugPrint('LoggedIn');
  }

  void verify(String otp) async {
    var login = await _finvuManager.verifyLoginOtp(
      otp,
      otpReference,
    );

    debugPrint('LoggedIn');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: [
            ElevatedButton(
              onPressed: () => {_initFinvuManager()},
              child: Text('Init'),
            ),
            ElevatedButton(
              onPressed: () => {login()},
              child: Text('Login'),
            ),
            ElevatedButton(
              onPressed: () => {verify(_controller.text)},
              child: Text('Verify'),
            ),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter text',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
