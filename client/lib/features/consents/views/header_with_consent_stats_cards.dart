import 'package:finvu_flutter_sdk/common/models/consent.dart';
import 'package:finvu_flutter_sdk/common/utils/finvu_colors.dart';
import 'package:finvu_flutter_sdk/common/widgets/finvu_dialog.dart';
import 'package:finvu_flutter_sdk/features/consents/bloc/consent_bloc.dart';
import 'package:finvu_flutter_sdk/features/consents/consent_approval_page.dart';
import 'package:finvu_flutter_sdk/features/consents/consents_list_page.dart';
import 'package:finvu_flutter_sdk/features/consents/consent_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finvu_flutter_sdk/l10n/app_localizations.dart';

class HeaderWithConsentStatsCards extends StatelessWidget {
  const HeaderWithConsentStatsCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildBackdropWidget(),
        _buildWelcomMessageWidget(context),
        const InfoCardsWidget(),
      ],
    );
  }

  Widget _buildBackdropWidget() {
    return const SizedBox(
      width: double.infinity,
      height: 178,
      child: DecoratedBox(
        decoration: BoxDecoration(color: FinvuColors.darkBlue),
      ),
    );
  }

  Widget _buildWelcomMessageWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25, top: 54),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 30),
          child: Text(
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 20,
              color: Colors.white,
            ),
            AppLocalizations.of(context)!.yourConsents,
          ),
        ),
      ),
    );
  }
}

class InfoCardsWidget extends StatelessWidget {
  static const int _cardIndexPendingConsents = 1;
  static const int _cardIndexActiveConsents = 2;
  static const int _cardIndexActiveSelfConsents = 3;
  static const int _cardIndexInactiveConsents = 4;
  static const int _cardIndexExpiringConsents = 5;
  static const int _cardIndexPausedConsents = 6;

  const InfoCardsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConsentBloc, ConsentState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(top: 108),
          child: SizedBox(
            height: 110,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 7,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return const SizedBox(width: 25);
                }

                return InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () {
                    _navigateToConsentPage(context, index, state);
                  },
                  child: Card(
                    color: _backgroundColorForCardIndex(index),
                    surfaceTintColor: Colors.transparent,
                    child: SizedBox(
                      width: 140,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 15,
                          right: 15,
                          top: 15,
                        ),
                        child: Column(
                          children: [
                            _getWidgetForCardIndex(context, index, state),
                            const SizedBox(height: 8),
                            Align(
                              alignment: AlignmentDirectional.centerStart,
                              child: Text(
                                _getTitleForCardIndex(context, index),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _navigateToConsentPage(
    BuildContext context,
    int index,
    ConsentState state,
  ) {
    Widget page;

    switch (index) {
      case _cardIndexPendingConsents:
        if (state.pendingConsents.isEmpty) {
          return;
        }
        page = ConsentsListPage(
          primaryButtonTitle: AppLocalizations.of(context)!.details,
          secondaryButtonTitle: AppLocalizations.of(context)!.reject,
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
          onSecondaryButtonClicked: (consent) {
            context.read<ConsentBloc>().add(ConsentReject(consent: consent));
          },
          title: AppLocalizations.of(context)!.pendingConsents,
          consents: state.pendingConsents,
        );
        break;
      case _cardIndexActiveConsents:
        if (state.activeConsents.isEmpty) {
          return;
        }
        page = ConsentsListPage(
          title: AppLocalizations.of(context)!.activeConsents,
          primaryButtonTitle: AppLocalizations.of(context)!.details,
          secondaryButtonTitle: AppLocalizations.of(context)!.revoke,
          onPrimaryButtonClicked: (consent) =>
              _handlePrimaryButtonClicked(context, consent),
          onSecondaryButtonClicked: (consent) {
            if (consent.finvuUserConsentInfo != null) {
              _showRevokeConsentConfirmationDialog(context, consent);
            }
          },
          consents: state.activeConsents,
        );
        break;
      case _cardIndexInactiveConsents:
        if (state.inactiveConsents.isEmpty) {
          return;
        }
        page = ConsentsListPage(
          title: AppLocalizations.of(context)!.inactiveConsents,
          primaryButtonTitle: AppLocalizations.of(context)!.details,
          secondaryButtonTitle: null,
          onPrimaryButtonClicked: (consent) =>
              _handlePrimaryButtonClicked(context, consent),
          onSecondaryButtonClicked: null,
          consents: state.inactiveConsents,
        );
        break;
      case _cardIndexExpiringConsents:
        if (state.expiringConsents.isEmpty) {
          return;
        }
        page = ConsentsListPage(
          title: AppLocalizations.of(context)!.expiringSoon,
          primaryButtonTitle: AppLocalizations.of(context)!.details,
          secondaryButtonTitle: null,
          onPrimaryButtonClicked: (consent) =>
              _handlePrimaryButtonClicked(context, consent),
          onSecondaryButtonClicked: null,
          consents: state.expiringConsents,
        );
        break;
      case _cardIndexActiveSelfConsents:
        if (state.activeSelfConsents.isEmpty) {
          return;
        }
        page = ConsentsListPage(
          title: AppLocalizations.of(context)!.activeSelfConsents,
          primaryButtonTitle: AppLocalizations.of(context)!.details,
          secondaryButtonTitle: AppLocalizations.of(context)!.revoke,
          onPrimaryButtonClicked: (consent) =>
              _handlePrimaryButtonClicked(context, consent),
          onSecondaryButtonClicked: (consent) {
            if (consent.finvuUserConsentInfo != null) {
              _showRevokeConsentConfirmationDialog(context, consent);
            }
          },
          consents: state.activeSelfConsents,
        );
        break;
      case _cardIndexPausedConsents:
        if (state.pausedConsnets.isEmpty) {
          return;
        }
        page = ConsentsListPage(
          title: AppLocalizations.of(context)!.pausedConsents,
          primaryButtonTitle: AppLocalizations.of(context)!.details,
          secondaryButtonTitle: AppLocalizations.of(context)!.revoke,
          onPrimaryButtonClicked: (consent) =>
              _handlePrimaryButtonClicked(context, consent),
          onSecondaryButtonClicked: (consent) {
            if (consent.finvuUserConsentInfo != null) {
              _showRevokeConsentConfirmationDialog(context, consent);
            }
          },
          consents: state.pausedConsnets,
        );
        break;
      default:
        return;
    }

    final route = MaterialPageRoute<void>(
      builder: (_) => BlocProvider.value(
        value: context.read<ConsentBloc>(),
        child: page,
      ),
    );
    Navigator.push(context, route);
  }

  void _handlePrimaryButtonClicked(
    BuildContext context,
    ConsentDetails consent,
  ) async {
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

  String _getTitleForCardIndex(BuildContext context, int index) {
    switch (index) {
      case _cardIndexPendingConsents:
        return AppLocalizations.of(context)!.pendingConsents;
      case _cardIndexActiveConsents:
        return AppLocalizations.of(context)!.activeConsents;
      case _cardIndexInactiveConsents:
        return AppLocalizations.of(context)!.inactiveConsents;
      case _cardIndexExpiringConsents:
        return AppLocalizations.of(context)!.expiringSoon;
      case _cardIndexActiveSelfConsents:
        return AppLocalizations.of(context)!.activeSelfConsents;
      case _cardIndexPausedConsents:
        return AppLocalizations.of(context)!.pausedConsents;
      default:
        return '';
    }
  }

  Widget _getWidgetForCardIndex(
    BuildContext context,
    int index,
    ConsentState state,
  ) {
    switch (index) {
      case _cardIndexPendingConsents:
        return _cardContentWidget(state.pendingConsents.length);
      case _cardIndexActiveConsents:
        return _cardContentWidget(state.activeConsents.length);
      case _cardIndexInactiveConsents:
        return _cardContentWidget(state.inactiveConsents.length);
      case _cardIndexExpiringConsents:
        return _cardContentWidget(state.expiringConsents.length);
      case _cardIndexActiveSelfConsents:
        return _cardContentWidget(state.activeSelfConsents.length);
      case _cardIndexPausedConsents:
        return _cardContentWidget(state.pausedConsnets.length);
      default:
        return const SizedBox.shrink();
    }
  }

  Row _cardContentWidget(int value) {
    return Row(
      children: [
        const SizedBox(width: 8),
        Text(
          "$value",
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  Color _backgroundColorForCardIndex(int index) {
    switch (index) {
      case _cardIndexPendingConsents:
        return const Color(0xFFF8D9D9);
      case _cardIndexActiveConsents:
        return const Color(0xFFD9F8F4);
      case _cardIndexInactiveConsents:
        return const Color(0xFFD9DDF8);
      case _cardIndexExpiringConsents:
        return const Color(0xFFFFD9D9);
      case _cardIndexActiveSelfConsents:
        return const Color(0xFFEDD2F9);
      case _cardIndexPausedConsents:
        return const Color(0xFFF8ECD9);
      default:
        return Colors.white;
    }
  }
}
