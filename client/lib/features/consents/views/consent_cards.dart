import 'package:finvu_flutter_sdk/common/models/consent.dart';
import 'package:finvu_flutter_sdk/common/widgets/consents_card.dart';
import 'package:finvu_flutter_sdk/common/widgets/finvu_dialog.dart';
import 'package:finvu_flutter_sdk/features/consents/consent_approval_page.dart';
import 'package:finvu_flutter_sdk/features/consents/consents_list_page.dart';
import 'package:finvu_flutter_sdk/features/consents/bloc/consent_bloc.dart';
import 'package:finvu_flutter_sdk/features/consents/consent_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finvu_flutter_sdk/l10n/app_localizations.dart';

class ConsentCards extends StatelessWidget {
  const ConsentCards({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConsentBloc, ConsentState>(
      builder: (context, state) {
        if (state.status == ConsentStatus.isFetchingConsents) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              _pendingConsents(context, state),
              state.pendingConsents.isNotEmpty
                  ? const SizedBox(height: 20)
                  : const SizedBox(),
              _activeConsents(context, state),
              const SizedBox(height: 20),
              _activeSelfConsents(context, state),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _pendingConsents(BuildContext context, ConsentState state) {
    return ConsentsCard(
      title: AppLocalizations.of(context)!.pendingConsents,
      showAll: false,
      consents: state.pendingConsents,
      primaryButtonTitle: AppLocalizations.of(context)!.details,
      secondaryButtonTitle: AppLocalizations.of(context)!.reject,
      onPrimaryButtonClicked: (consent) async {
        final route = MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: context.read<ConsentBloc>(),
            child: ConsentApprovalPage(consent: consent),
          ),
        );
        Navigator.push(context, route);
      },
      onSecondaryButtonClicked: (consent) {
        context.read<ConsentBloc>().add(ConsentReject(consent: consent));
      },
      onViewAllClicked: () {
        final route = MaterialPageRoute<void>(
          builder: (_) => BlocProvider.value(
            value: context.read<ConsentBloc>(),
            child: ConsentsListPage(
              title: AppLocalizations.of(context)!.pendingConsents,
              primaryButtonTitle: AppLocalizations.of(context)!.details,
              secondaryButtonTitle: AppLocalizations.of(context)!.reject,
              consents: state.pendingConsents,
              onPrimaryButtonClicked: (consent) async {
                final route = MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: context.read<ConsentBloc>(),
                    child: ConsentApprovalPage(consent: consent),
                  ),
                );
                final result = await Navigator.push(context, route);
                if (context.mounted && result != null && result is String) {
                  Navigator.pop(context, result);
                }
              },
              onSecondaryButtonClicked: (consent) async {
                context
                    .read<ConsentBloc>()
                    .add(ConsentReject(consent: consent));
              },
            ),
          ),
        );
        Navigator.push(context, route);
      },
    );
  }

  Widget _activeConsents(BuildContext context, ConsentState state) {
    return ConsentsCard(
      title: AppLocalizations.of(context)!.activeConsents,
      showAll: false,
      consents: state.activeConsents,
      primaryButtonTitle: AppLocalizations.of(context)!.details,
      secondaryButtonTitle: AppLocalizations.of(context)!.revoke,
      onPrimaryButtonClicked: (consent) async {
        final route = MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: context.read<ConsentBloc>(),
            child: ConsentDetailsPage(consent: consent),
          ),
        );
        Navigator.push(context, route);
      },
      onSecondaryButtonClicked: (consent) {
        if (consent.finvuUserConsentInfo != null) {
          _showRevokeConsentConfirmationDialog(context, consent);
        }
      },
      onViewAllClicked: () {
        final route = MaterialPageRoute<void>(
          builder: (_) => BlocProvider.value(
            value: context.read<ConsentBloc>(),
            child: ConsentsListPage(
              title: AppLocalizations.of(context)!.activeConsents,
              primaryButtonTitle: AppLocalizations.of(context)!.details,
              secondaryButtonTitle: AppLocalizations.of(context)!.revoke,
              consents: state.activeConsents,
              onPrimaryButtonClicked: (consent) async {
                final route = MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: context.read<ConsentBloc>(),
                    child: ConsentDetailsPage(consent: consent),
                  ),
                );
                final result = await Navigator.push(context, route);
                if (context.mounted && result != null && result is String) {
                  Navigator.pop(context, result);
                }
              },
              onSecondaryButtonClicked: (consent) async {
                if (consent.finvuUserConsentInfo != null) {
                  _showRevokeConsentConfirmationDialog(context, consent);
                }
              },
            ),
          ),
        );
        Navigator.push(context, route);
      },
    );
  }

  Widget _activeSelfConsents(BuildContext context, ConsentState state) {
    return ConsentsCard(
      title: AppLocalizations.of(context)!.activeSelfConsents,
      showAll: false,
      consents: state.activeSelfConsents,
      primaryButtonTitle: AppLocalizations.of(context)!.details,
      secondaryButtonTitle: AppLocalizations.of(context)!.revoke,
      onPrimaryButtonClicked: (consent) async {
        final route = MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: context.read<ConsentBloc>(),
            child: ConsentDetailsPage(consent: consent),
          ),
        );
        final result = await Navigator.push(context, route);
        if (context.mounted && result != null && result is String) {
          Navigator.pop(context, result);
        }
      },
      onSecondaryButtonClicked: (consent) {
        if (consent.finvuUserConsentInfo != null) {
          _showRevokeConsentConfirmationDialog(context, consent);
        }
      },
      onViewAllClicked: () {
        final route = MaterialPageRoute<void>(
          builder: (_) => BlocProvider.value(
            value: context.read<ConsentBloc>(),
            child: ConsentsListPage(
              title: AppLocalizations.of(context)!.activeSelfConsents,
              primaryButtonTitle: AppLocalizations.of(context)!.details,
              secondaryButtonTitle: AppLocalizations.of(context)!.revoke,
              consents: state.activeSelfConsents,
              onPrimaryButtonClicked: (consent) async {
                final route = MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: context.read<ConsentBloc>(),
                    child: ConsentDetailsPage(consent: consent),
                  ),
                );
                final result = await Navigator.push(context, route);
                if (context.mounted && result != null && result is String) {
                  Navigator.pop(context, result);
                }
              },
              onSecondaryButtonClicked: (consent) async {
                if (consent.finvuUserConsentInfo != null) {
                  _showRevokeConsentConfirmationDialog(context, consent);
                }
              },
            ),
          ),
        );
        Navigator.push(context, route);
      },
    );
  }

  void _showRevokeConsentConfirmationDialog(
      BuildContext context, ConsentDetails consent) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return FinvuDialog(
            title: AppLocalizations.of(context)!.confirmation,
            subtitle: [
              TextSpan(
                text: AppLocalizations.of(context)!.revokeConsentConfirmation,
              ),
            ],
            content: const SizedBox(height: 0, width: 0),
            buttonText: AppLocalizations.of(context)!.continuee,
            onPressed: () {
              context.read<ConsentBloc>().add(ConsentRevoke(consent: consent));
              Navigator.of(context).pop();
            },
            shouldShowCancelButton: true,
          );
        });
  }
}
