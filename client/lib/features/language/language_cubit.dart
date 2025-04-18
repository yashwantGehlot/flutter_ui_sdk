import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageCubit extends Cubit<Locale?> {
  LanguageCubit() : super(null);

  void initialize({Locale? locale}) {
    emit(locale ?? const Locale('en'));
  }

  // Optional: if you want to allow runtime updates (not saved)
  void changeLanguage(Locale locale) {
    emit(locale);
  }
}
