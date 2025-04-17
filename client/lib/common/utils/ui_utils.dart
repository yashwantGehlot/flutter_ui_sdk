import 'package:finvu_flutter_sdk/common/utils/finvu_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UIUtils {
  static AppBar getFinvuAppBar({
    final Widget? leading,
    final List<Widget>? actions,
  }) {
    return AppBar(
      leading: leading,
      iconTheme: const IconThemeData(color: FinvuColors.blue),
      actions: actions,
    );
  }

  static AppBar getFinvuAppBackBar({final List<Widget>? actions}) {
    return AppBar(
      title: const Align(alignment: Alignment.centerLeft),
      titleSpacing: 0,
      iconTheme: const IconThemeData(color: FinvuColors.blue),
      actions: actions,
    );
  }

  static String toSentenceCase(String text) {
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  static void copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
  }
}
