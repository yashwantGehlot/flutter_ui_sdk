import 'package:finvu_flutter_sdk/config/finvu_app_config.dart';
import 'package:finvu_flutter_sdk/features/language/language_cubit.dart';
import 'package:finvu_flutter_sdk/finvu_ui_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'features/splash/splash_page.dart';
import 'package:finvu_flutter_sdk/l10n/app_localizations.dart';

class FinvuApp extends StatefulWidget {
  const FinvuApp({
    super.key,
    required this.consentHandleId,
    required this.mobileNumber,
    required this.environment,
    this.locale,
  });

  final String mobileNumber;
  final String consentHandleId;
  final Environment environment;
  final Locale? locale;

  @override
  State<StatefulWidget> createState() => _FinvuAppState();
}

enum FinvuButtonStyleType {
  elevated,
  outlined,
}

class _FinvuAppState extends State<FinvuApp> {
  bool _loadedFonts = false;
  Locale? _sdkLocale;
  Future<void> _loadFonts() async {
    final fontFamily = FinvuUIManager().uiConfig?.fontFamily ?? 'Roboto';
    final fontLoader = FontLoader(fontFamily);
    await fontLoader.load();
    if (mounted) {
      setState(() => _loadedFonts = true);
    }
  }

  @override
  void initState() {
    super.initState();
    FinvuAppConfig.initialize(widget.environment);
    _loadFonts();
    _loadLocale();
  }

  void _loadLocale() {
    final localeStr = FinvuUIManager().appLocale;
    if (localeStr != null) {
      _sdkLocale = Locale(localeStr);
    } else {
      _sdkLocale = widget.locale;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_loadedFonts) {
      return MaterialApp(
        theme: FinvuUIManager().getAppTheme(),
        home: const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    return BlocProvider(
      create: (context) => LanguageCubit()..initialize(locale: _sdkLocale),
      child: BlocBuilder<LanguageCubit, Locale?>(
        builder: (context, locale) {
          return WillPopScope(
            onWillPop: () async {
              bool shouldExit = await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Exit AA Journey"),
                    content: const Text("Do you want to exit the journey?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text("No"),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text("Yes"),
                      ),
                    ],
                  );
                },
              );
              return shouldExit;
            },
            child: MaterialApp(
              title: 'Finvu',
              theme: FinvuUIManager.instance.getAppTheme(),
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: AppLocalizations.supportedLocales,
              locale: locale ?? widget.locale,
              home: const SplashPage(),
            ),
          );
        },
      ),
    );
  }
}
