// import 'dart:async';
// import 'dart:io';

// import 'package:finvu_flutter_sdk/common/utils/analytics_events.dart';
// import 'package:finvu_flutter_sdk/common/utils/analytics_utils.dart';
// import 'package:finvu_flutter_sdk/common/utils/finvu_colors.dart';
// import 'package:finvu_flutter_sdk/common/utils/remote_config_service.dart';
// import 'package:finvu_flutter_sdk/common/utils/secure_storage_util.dart';
// import 'package:finvu_flutter_sdk/common/widgets/base_page.dart';
// import 'package:finvu_flutter_sdk/features/main/main_page.dart';
// import 'package:finvu_flutter_sdk/features/splash/splash_page.dart';
// import 'package:finvu_flutter_sdk_core/finvu_user_info.dart';
// import 'package:flutter/material.dart';
// import 'package:finvu_flutter_sdk/l10n/app_localizations.dart';
// import 'package:otpless_flutter/otpless_flutter.dart';
// import 'package:package_info_plus/package_info_plus.dart';
// import 'package:uuid/uuid.dart';
// import 'package:finvu_flutter_sdk/common/utils/url_utils.dart';

// class Devicebindingpage extends BasePage {
//   final String mobileNumber;
//   final String handleId;

//   const Devicebindingpage(
//       {super.key, required this.mobileNumber, required this.handleId});

//   @override
//   State<Devicebindingpage> createState() => _DevicebindingpageState();

//   static Route<void> route(
//     String mobileNumber,
//     String handleId,
//   ) {
//     return MaterialPageRoute<void>(
//       builder: (_) => Devicebindingpage(
//         mobileNumber: mobileNumber,
//         handleId: handleId,
//       ),
//     );
//   }

//   @override
//   String routeName() {
//     return FinvuScreens.deviceBindingPage;
//   }
// }

// class _DevicebindingpageState extends BasePageState<Devicebindingpage> {
//   final Uri contactSupportUrl = Uri.parse('https://finvu.in/helpdesk');
//   final _otplessFlutterPlugin = Otpless();
//   final storage = SecureStorageUtil();
//   final remoteConfig = RemoteConfigService();
//   final FinvuManagerInternal finvuManagerInternal = FinvuManagerInternal();
//   final TextEditingController otpController = TextEditingController();
//   late FinvuUserInfo userInfo;
//   bool _showOtpLayout = false;
//   bool _showErrorLayout = false;
//   String deliveryMethod = 'SMS';
//   Timer? _timer;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: FinvuColors.lightBlue,
//       body: SingleChildScrollView(
//         child: Center(
//           child: Container(
//             child: _showErrorLayout
//                 ? _buildErrorSection()
//                 : _showOtpLayout
//                     ? _buildOtpSection()
//                     : _buildLoadingSection(),
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   void initState() {
//     super.initState();
//     _otplessFlutterPlugin.setHeadlessCallback(onHeadlessResult);
//     startHeadless(null);
//     FinvuAnalytics.logEvent(
//       AnalyticsEvent.deviceBindingInitSNA,
//       parameters: {
//         'deliveryChannel': 'SNA',
//       },
//     );
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _timer?.cancel();
//   }

//   void startTimer() {
//     var interval = remoteConfig.deviceBindingOtpTimerInterval;
//     _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
//       if (interval == 0) {
//         timer.cancel();
//         setState(() {
//           _showErrorLayout = true;
//         });
//       } else {
//         setState(() {
//           interval--;
//           debugPrint("OTPLESS: TIMER INTERVAL: $interval");
//         });
//       }
//     });
//   }

//   Widget _buildErrorSection() {
//     return Padding(
//       padding: const EdgeInsets.all(32.0),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const SizedBox(height: 80),
//           Image.asset('lib/assets/finvu_logo.png', height: 50),
//           const SizedBox(height: 60),
//           Text(
//             AppLocalizations.of(context)!.oopsDeviceRegistrationFailed,
//             style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 8),
//           Container(
//             alignment: Alignment.center,
//             child: Text(
//               AppLocalizations.of(context)!.pleaseCheckYourConnectionOrSim,
//               style: const TextStyle(fontSize: 14),
//               textAlign: TextAlign.center,
//             ),
//           ),
//           const SizedBox(height: 20),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pushAndRemoveUntil(
//                 context,
//                 SplashPage.route(),
//                 (Route<dynamic> route) => false,
//               );
//             },
//             style: ElevatedButton.styleFrom(
//               minimumSize: const Size(
//                 double.infinity,
//                 50,
//               ),
//             ),
//             child: Text(AppLocalizations.of(context)!.retryLogin),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildLoadingSection() {
//     return Padding(
//       padding: const EdgeInsets.all(32.0),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const SizedBox(height: 80),
//           Image.asset('lib/assets/finvu_logo.png', height: 50),
//           const SizedBox(height: 60),
//           const SizedBox(
//             height: 130,
//             width: 130,
//             child: CircularProgressIndicator(
//               strokeWidth: 8,
//               valueColor: AlwaysStoppedAnimation<Color>(FinvuColors.blue),
//             ),
//           ),
//           const SizedBox(height: 40),
//           Text(
//             AppLocalizations.of(context)!.registeringYourDevice,
//             style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 8),
//           Container(
//             alignment: Alignment.center,
//             child: Text(
//               AppLocalizations.of(context)!.justAMonentDeviceBinding,
//               style: const TextStyle(fontSize: 14),
//               textAlign: TextAlign.center,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildOtpSection() {
//     return Padding(
//       padding: const EdgeInsets.all(32.0),
//       child: Column(
//         children: [
//           const SizedBox(height: 80),
//           Image.asset('lib/assets/finvu_logo.png', height: 50),
//           const SizedBox(height: 20),
//           Text(
//             AppLocalizations.of(context)!.verifyDeviceViaOtp,
//             style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 8),
//           Container(
//             alignment: Alignment.center,
//             child: Text(
//               AppLocalizations.of(context)!.finvuHasSentOtp(
//                 deliveryMethod,
//                 widget.mobileNumber,
//               ),
//               style: const TextStyle(
//                 fontSize: 12,
//                 fontWeight: FontWeight.bold,
//                 color: FinvuColors.grey81858F,
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ),
//           const SizedBox(height: 40),
//           TextField(
//             controller: otpController,
//             keyboardType: TextInputType.number,
//             maxLength: 6,
//             decoration: InputDecoration(
//               border: const OutlineInputBorder(),
//               labelText: AppLocalizations.of(context)!.sixDigitOtp,
//             ),
//             onTapOutside: (event) {
//               FocusManager.instance.primaryFocus?.unfocus();
//             },
//           ),
//           const SizedBox(height: 30),
//           ElevatedButton(
//             onPressed: () {
//               startHeadless(otpController.text);
//             },
//             style: ElevatedButton.styleFrom(
//               minimumSize: const Size(
//                 double.infinity,
//                 50,
//               ),
//             ),
//             child: Text(AppLocalizations.of(context)!.registerDevice),
//           ),
//           const SizedBox(height: 20),
//           GestureDetector(
//             onTap: () => launch(contactSupportUrl),
//             child: RichText(
//               text: TextSpan(
//                 children: [
//                   TextSpan(
//                     text: AppLocalizations.of(context)!.facingIssues,
//                     style: const TextStyle(
//                       color: Colors.black,
//                     ),
//                   ),
//                   TextSpan(
//                     text: AppLocalizations.of(context)!.support,
//                     style: const TextStyle(
//                       color: Colors.blue,
//                       decoration: TextDecoration.underline,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void startHeadless(String? otp) async {
//     Map<String, dynamic> arg = {};
//     arg["phone"] = widget.mobileNumber;
//     arg["countryCode"] = "91";
//     if (otp != null) {
//       arg["otp"] = otp;
//     }
//     _otplessFlutterPlugin.startHeadless(onHeadlessResult, arg);
//     debugPrint("OTPLESS: startHeadless");
//   }

//   void onHeadlessResult(dynamic result) async {
//     if (result['statusCode'] == 200) {
//       debugPrint("OTPLESS: $result");
//       switch (result['responseType'] as String) {
//         case 'INITIATE':
//           {
//             FinvuAnalytics.logEvent(
//               AnalyticsEvent.deviceBindingInitNonSNA,
//               parameters: {
//                 'deliveryChannel': result['response']['deliveryChannel'],
//               },
//             );

//             debugPrint("OTPLESS: INITIATE");
//             if (Platform.isIOS) {
//               setState(() {
//                 deliveryMethod = result['response']['deliveryChannel'];
//                 debugPrint("Delivery Method 1: $deliveryMethod");
//                 _showOtpLayout = true;
//               });
//             }
//             WidgetsBinding.instance.addPostFrameCallback((_) {
//               setState(() {
//                 deliveryMethod = result['response']['deliveryChannel'];
//                 debugPrint(
//                     "Delivery Method updated after frame callback: $deliveryMethod");
//               });
//             });

//             if (result['response']['deliveryChannel'] == "SMS" &&
//                 Platform.isAndroid) {
//               startTimer();
//             }
//           }
//           break;
//         case 'VERIFY':
//           {
//             debugPrint("OTPLESS: VERIFY");
//           }
//           break;
//         case 'OTP_AUTO_READ':
//           {
//             debugPrint("OTPLESS: OTP AUTO READ");
//             if (Platform.isAndroid) {
//               var otp = result['response']['otp'] as String;
//               startHeadless(otp);
//             }
//           }
//           break;
//         case 'ONETAP':
//           {
//             FinvuAnalytics.logEvent(
//               AnalyticsEvent.deviceBindingComplete,
//               parameters: {
//                 'deliveryChannel': deliveryMethod,
//               },
//             );
//             try {
//               debugPrint("OTPLESS: ONE TAP");
//               final token = result["response"]["token"];
//               debugPrint("OTPLESS: TOKEN RECEIVED: LOGGING IN ..");
//               final deviceID = const Uuid().v4();
//               PackageInfo packageInfo = await PackageInfo.fromPlatform();
//               final resp = await finvuManagerInternal.deviceBindingRequest(
//                 token,
//                 deviceID,
//                 Platform.operatingSystem,
//                 Platform.operatingSystemVersion,
//                 packageInfo.packageName,
//                 packageInfo.version,
//                 null,
//               );

//               if (resp.secret != null) {
//                 storage.store(
//                   storage.SECRET_KEY,
//                   resp.secret!,
//                 );
//                 storage.store(
//                   storage.DEVICE_ID_KEY,
//                   deviceID,
//                 );
//                 storage.store(
//                   storage.SECRET_TIMESTAMP_KEY,
//                   DateTime.now().millisecondsSinceEpoch.toString(),
//                 );
//                 Navigator.of(context).pushAndRemoveUntil(
//                     MainPage.route(widget.handleId),
//                     (Route<dynamic> route) => false);
//               } else {
//                 setState(() {
//                   _showErrorLayout = true;
//                 });
//               }
//             } catch (e) {
//               setState(() {
//                 _showErrorLayout = true;
//               });
//             }
//           }
//           break;
//       }
//     } else {
//       FinvuAnalytics.logEvent(
//         AnalyticsEvent.deviceBindingError,
//         parameters: {
//           'error': result['response']['errorMessage'].toString(),
//         },
//       );
//       setState(() {
//         _showErrorLayout = true;
//       });

//       if (result['response']['errorMessage'].toString().contains("invalid")) {
//         ScaffoldMessenger.of(context)
//           ..hideCurrentSnackBar()
//           ..showSnackBar(
//             SnackBar(
//               content: Text(
//                 AppLocalizations.of(context)!.invalidOtp,
//               ),
//             ),
//           );
//       }
//     }
//   }
// }
