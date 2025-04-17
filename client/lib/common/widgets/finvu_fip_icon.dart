import 'package:finvu_flutter_sdk/common/utils/finvu_colors.dart';
import 'package:flutter/material.dart';

class FinvuFipIcon extends StatelessWidget {
  const FinvuFipIcon({
    super.key,
    required this.iconUri,
    required this.size,
    this.applyTint = false,
  });

  final String? iconUri;
  final int size;
  final bool applyTint;

  @override
  Widget build(BuildContext context) {
    Widget? imageWidget;
    try {
      debugPrint("image for $iconUri");
      if (iconUri == null ||
          iconUri!.isEmpty ||
          !(iconUri!.endsWith(".png") ||
              iconUri!.endsWith(".jpg") ||
              iconUri!.endsWith(".jpeg"))) {
        return _placeholderImage();
      }

      imageWidget = Image.network(
        width: size.toDouble(),
        height: size.toDouble(),
        iconUri!.trim(),
        fit: BoxFit.contain,
        errorBuilder: ((context, exception, stacktrace) => _placeholderImage()),
      );

      if (applyTint) {
        imageWidget = _tintedImage(imageWidget);
      }
    } on Exception catch (e) {
      debugPrint("DEBUG: EXCEPTION:: ${e.toString()}");
    }
    return imageWidget ?? _placeholderImage();
  }

  Widget _placeholderImage() {
    Widget imageWidget = Icon(
      Icons.account_balance_outlined,
      size: size.toDouble(),
      color: Colors.grey,
    );

    if (applyTint) {
      imageWidget = _tintedImage(imageWidget);
    }

    return imageWidget;
  }

  Widget _tintedImage(Widget imageWidget) {
    return ColorFiltered(
      colorFilter: ColorFilter.mode(
          FinvuColors.greyF5F5F5.withOpacity(0.5), BlendMode.srcATop),
      child: imageWidget,
    );
  }
}
