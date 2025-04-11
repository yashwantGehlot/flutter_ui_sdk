import 'package:finvu_flutter_sdk/common/utils/finvu_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FinvuDialog extends StatelessWidget {
  final String title;
  final List<TextSpan> subtitle;
  final Widget content;
  final String? buttonText;
  final bool isButtonLoading;
  final VoidCallback? onPressed;
  final bool dismissible;
  final bool shouldShowCancelButton;
  final TextAlign textAlign;

  const FinvuDialog({
    super.key,
    required this.title,
    this.subtitle = const [],
    required this.content,
    this.onPressed,
    this.buttonText,
    this.isButtonLoading = false,
    this.dismissible = true,
    this.shouldShowCancelButton = false,
    this.textAlign = TextAlign.left,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(25),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: (textAlign == TextAlign.left)
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: (dismissible || textAlign == TextAlign.left)
                  ? MainAxisAlignment.spaceBetween
                  : MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                ),
                Visibility(
                  visible: dismissible,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                )
              ],
            ),
            _subtitleWidget(context),
            const SizedBox(height: 16),
            content,
            Visibility(
              visible: buttonText != null,
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  isButtonLoading
                      ? const Align(
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(),
                        )
                      : SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: onPressed,
                            child: Text(buttonText ?? ""),
                          ),
                        ),
                ],
              ),
            ),
            Visibility(
              visible: shouldShowCancelButton,
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(AppLocalizations.of(context)!.cancel),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _subtitleWidget(BuildContext context) {
    if (subtitle.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Text.rich(
        TextSpan(
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 12,
            color: FinvuColors.grey81858F,
          ),
          children: subtitle,
        ),
        textAlign: textAlign,
      ),
    );
  }
}
