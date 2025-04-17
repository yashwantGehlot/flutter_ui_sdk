import 'dart:ui';

import 'package:finvu_flutter_sdk/common/utils/finvu_colors.dart';

class FinvuInputStyleConfig {
  final Color borderColor;
  final Color focusBorderColor;
  final double borderRadius;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final TextStyle? labelStyle;

  const FinvuInputStyleConfig({
    this.borderColor = FinvuColors.greyD8E1EE,
    this.focusBorderColor = FinvuColors.blue,
    this.borderRadius = 14.0,
    this.textStyle,
    this.hintStyle,
    this.labelStyle,
  });
}
