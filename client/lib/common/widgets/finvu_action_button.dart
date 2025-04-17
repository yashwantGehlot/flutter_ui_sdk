import 'package:flutter/material.dart';

enum FinvuButtonStyleType {
  elevated,
  outlined,
  text,
}

class FinvuActionButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final FinvuButtonStyleType styleType;
  final ButtonStyle? style;

  const FinvuActionButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.styleType = FinvuButtonStyleType.elevated,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    switch (styleType) {
      case FinvuButtonStyleType.outlined:
        return OutlinedButton(
          onPressed: onPressed,
          style: style,
          child: child,
        );
      case FinvuButtonStyleType.text:
        return TextButton(
          onPressed: onPressed,
          style: style,
          child: child,
        );
      case FinvuButtonStyleType.elevated:
      default:
        return ElevatedButton(
          onPressed: onPressed,
          style: style,
          child: child,
        );
    }
  }
}
