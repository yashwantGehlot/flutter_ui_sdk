import 'package:finvu_flutter_sdk/app.dart';
import 'package:finvu_flutter_sdk/common/utils/finvu_colors.dart';
import 'package:finvu_flutter_sdk/config/finvu_app_config.dart';
import 'package:finvu_flutter_sdk_core/finvu_fip_details.dart';
import 'package:finvu_flutter_sdk_core/finvu_ui_initialization.dart';
import 'package:flutter/material.dart';

class FinvuUIManager {
  static final FinvuUIManager instance = FinvuUIManager._internal();

  factory FinvuUIManager() {
    return instance;
  }

  FinvuUIManager._internal();

  late SDKConfig _sdkConfig;
  late FIUDetails _fiuDetails;
  late LoginConfig _loginConfig;
  List<FinvuFIPDetails>? _fipDetailsList;
  FinvuUIConfig? _uiConfig;
  String? _appLocale;

  // Getters
  SDKConfig get sdkConfig => _sdkConfig;
  FIUDetails get fiuDetails => _fiuDetails;
  FinvuUIConfig? get uiConfig => _uiConfig;
  LoginConfig get loginConfig => _loginConfig;
  List<FinvuFIPDetails>? get fipDetailsList => _fipDetailsList;
  String? get appLocale => _appLocale;

  // Initialize method
  void initialize({
    required BuildContext context,
    required SDKConfig sdkConfig,
    required FIUDetails fiuDetails,
    required LoginConfig loginConfig,
    required Environment environment,
    FinvuUIConfig? uiConfig,
    List<FinvuFIPDetails>? fipDetailsList,
  }) {
    _sdkConfig = sdkConfig;
    _fiuDetails = fiuDetails;
    _loginConfig = loginConfig;
    _fipDetailsList = fipDetailsList;
    _uiConfig = uiConfig ?? _getDefaultUIConfig();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FinvuApp(
          consentHandleId: loginConfig.consentHandle,
          mobileNumber: loginConfig.mobileNumber,
          environment: environment,
        ),
      ),
    );
  }

  FinvuUIConfig _getDefaultUIConfig() {
    const primaryColor = FinvuColors.blue;
    const secondaryColor = Color(0xFF64748B); // Slate grey
    const currentColor = Color(0xFF0F172A); // Dark slate

    final defaultElevatedButtonTheme = ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );

    final defaultOutlinedButtonTheme = OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: primaryColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );

    const textTheme = TextTheme(
      // Large titles for main headers
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: currentColor,
        letterSpacing: -0.5,
      ),
      // Medium titles for section headers
      displayMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: currentColor,
        letterSpacing: -0.5,
      ),
      // Small titles for subsections
      displaySmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w500,
        color: currentColor,
      ),
      // Primary headings
      headlineLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: currentColor,
      ),
      // Secondary headings
      headlineMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: currentColor,
      ),
      // Tertiary headings
      headlineSmall: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: currentColor,
      ),
      // Body text
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: currentColor,
        height: 1.5,
      ),
      // Default body text
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: currentColor,
        height: 1.5,
      ),
      // Labels and buttons
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: currentColor,
        letterSpacing: 0.5,
      ),
    );

    return FinvuUIConfig(
      primaryColor: primaryColor,
      secondaryColor: secondaryColor,
      currentColor: currentColor,
      textTheme: textTheme,
      loderWidget: const CircularProgressIndicator(
        color: primaryColor,
        strokeWidth: 3,
      ),
      fontFamily: 'Roboto',
      elevatedButtonTheme: defaultElevatedButtonTheme,
      outlinedButtonTheme: defaultOutlinedButtonTheme,
    );
  }

  ThemeData getAppTheme() {
    final primaryColor = _uiConfig?.primaryColor ?? FinvuColors.blue;

    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
      useMaterial3: true,
      textTheme: _uiConfig?.textTheme,
      fontFamily: _uiConfig?.fontFamily,
      elevatedButtonTheme: _uiConfig?.elevatedButtonTheme,
      outlinedButtonTheme: _uiConfig?.outlinedButtonTheme,
    );
  }
}
