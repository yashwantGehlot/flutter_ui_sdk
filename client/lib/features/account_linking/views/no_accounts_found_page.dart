import 'package:finvu_flutter_sdk/common/widgets/finvu_fip_icon.dart';
import 'package:finvu_flutter_sdk/common/widgets/finvu_scaffold.dart';
import 'package:finvu_flutter_sdk_core/finvu_fip_info.dart';
import 'package:flutter/material.dart';
import 'package:finvu_flutter_sdk/l10n/app_localizations.dart';

class NoAccountsFoundPage extends StatelessWidget {
  final String mobileNumber;
  final FinvuFIPInfo fip;

  const NoAccountsFoundPage(
      {super.key, required this.mobileNumber, required this.fip});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FinvuScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    children: [
                      TextSpan(
                          text: AppLocalizations.of(context)!
                              .noAccountsFoundAssociatedWith),
                      const TextSpan(text: ": "),
                      TextSpan(
                        text: mobileNumber,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 24),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        FinvuFipIcon(
                          iconUri: fip.productIconUri,
                          size: 30,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          fip.productName ?? "",
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  AppLocalizations.of(context)!.noAccountsDiscoveredReason1,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w400,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                Text(
                  AppLocalizations.of(context)!.noAccountsDiscoveredReason2,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w400,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                Text(
                  AppLocalizations.of(context)!.noAccountsDiscoveredReason3,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w400,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
