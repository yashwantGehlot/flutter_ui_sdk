import 'package:finvu_flutter_sdk/config/finvu_app_config.dart';
import 'package:finvu_flutter_sdk/features/language/language_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'common/utils/finvu_colors.dart';
import 'features/splash/splash_page.dart';
import 'package:finvu_flutter_sdk/l10n/app_localizations.dart';

class FinvuApp extends StatefulWidget {
  const FinvuApp({
    super.key,
    required this.consentHandleId,
    required this.mobileNumber,
    required this.environment,
    this.theme,
    this.locale,
  });

  final String mobileNumber;
  final String consentHandleId;
  final Environment environment;
  final ThemeData? theme;
  final Locale? locale;
  @override
  State<StatefulWidget> createState() => _FinvuAppState();
}

class _FinvuAppState extends State<FinvuApp> {
  @override
  void initState() {
    super.initState();
    FinvuAppConfig.initialize(widget.environment);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LanguageCubit()..initialize(),
      child: BlocBuilder<LanguageCubit, Locale?>(
        builder: (context, locale) {
          return MaterialApp(
            title: 'Finvu',
            theme: widget.theme ??
                ThemeData(
                  colorScheme:
                      ColorScheme.fromSeed(seedColor: FinvuColors.blue),
                  useMaterial3: true,
                  elevatedButtonTheme: ElevatedButtonThemeData(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: FinvuColors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                  outlinedButtonTheme: OutlinedButtonThemeData(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: FinvuColors.blue),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            locale: locale,
            home: const SplashPage(),
          );
        },
      ),
    );
  }
}
