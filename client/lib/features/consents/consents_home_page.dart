import 'package:finvu_flutter_sdk/common/utils/analytics_events.dart';
import 'package:finvu_flutter_sdk/common/utils/error_utils.dart';
import 'package:finvu_flutter_sdk/common/widgets/base_page.dart';
import 'package:finvu_flutter_sdk/features/consents/bloc/consent_bloc.dart';
import 'package:finvu_flutter_sdk/features/consents/views/consent_cards.dart';
import 'package:finvu_flutter_sdk/features/consents/views/header_with_consent_stats_cards.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finvu_flutter_sdk/l10n/app_localizations.dart';

class ConsentsHomePage extends BasePage {
  const ConsentsHomePage({super.key});

  @override
  State<ConsentsHomePage> createState() => _ConsentsHomePageState();

  @override
  String routeName() {
    return FinvuScreens.consentsHomePage;
  }
}

class _ConsentsHomePageState extends BasePageState<ConsentsHomePage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ConsentBloc()..add(const ConsentsRefresh()),
      child: BlocConsumer<ConsentBloc, ConsentState>(
        listener: (context, state) {
          if (state.status == ConsentStatus.consentApproved ||
              state.status == ConsentStatus.consentRejected ||
              state.status == ConsentStatus.consentRevoked) {
            String message = state.status == ConsentStatus.consentRevoked
                ? AppLocalizations.of(context)!.consentRevoked
                : state.status == ConsentStatus.consentApproved
                    ? AppLocalizations.of(context)!.consentApproved
                    : AppLocalizations.of(context)!.consentRejected;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
              ),
            );

            context.read<ConsentBloc>().add(const ConsentsRefresh());
          } else if (state.status == ConsentStatus.error) {
            if (ErrorUtils.hasSessionExpired(state.error)) {
              handleSessionExpired(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    ErrorUtils.getErrorMessage(context, state.error),
                  ),
                ),
              );
            }
          }
        },
        builder: (context, state) {
          return const SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeaderWithConsentStatsCards(),
                Padding(padding: EdgeInsets.only(top: 15)),
                ConsentCards()
              ],
            ),
          );
        },
      ),
    );
  }
}
