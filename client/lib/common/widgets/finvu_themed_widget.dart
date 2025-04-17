import 'package:flutter/material.dart';
import '../../finvu_ui_manager.dart';

class FinvuThemedWidget extends StatelessWidget {
  final Widget child;

  const FinvuThemedWidget({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: FinvuUIManager().getAppTheme(),
      child: child,
    );
  }
}
