import 'package:finvu_flutter_sdk/common/utils/error_utils.dart';
import 'package:finvu_flutter_sdk/common/utils/finvu_colors.dart';
import 'package:finvu_flutter_sdk/common/widgets/finvu_dialog.dart';
import 'package:finvu_flutter_sdk/features/account_linking/bloc/account_linking_bloc.dart';
import 'package:finvu_flutter_sdk/features/account_linking/models/identifier.dart';
import 'package:finvu_flutter_sdk/features/account_linking/discovered_accounts_page.dart';
import 'package:finvu_flutter_sdk/features/account_linking/widgets/add_new_mobile_number_dialog.dart';
import 'package:finvu_flutter_sdk/features/account_linking/widgets/identifier_input_dialog.dart';
import 'package:finvu_flutter_sdk/features/account_linking/views/no_accounts_found_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NextButton extends StatefulWidget {
  const NextButton({super.key});

  @override
  State<NextButton> createState() => _NextButtonState();
}

class _NextButtonState extends State<NextButton> {
  bool _enabled = false;
  bool _isShowingDiscoveringAccountsDialog = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AccountLinkingBloc, AccountLinkingState>(
      listener: (context, state) async {
        if (_enabled) {
          if (state.status == AccountLinkingStatus.isDiscoveringAccounts) {
            _showDiscoveringAccountsDialog(context);
          } else if (state.status ==
              AccountLinkingStatus.additionalIdentifiersRequired) {
            _dismissDiscoveringAccountsDialog(context);
            final identifier =
                state.typeToAdditionalRequiredIdentifierMap.values.first;
            _collectAdditionalIdentifier(
              context,
              identifier,
            );
          } else if (state.status == AccountLinkingStatus.didDiscoverAccounts) {
            _dismissDiscoveringAccountsDialog(context);
            if (state.discoveredAccounts.isNotEmpty) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DiscoveredAccountsPage(
                    bloc: context.read<AccountLinkingBloc>(),
                  ),
                ),
              );
            } else {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NoAccountsFoundPage(
                      mobileNumber: state.mobileNumber,
                      fip: state.selectedFipInfo!),
                ),
              );
            }
          } else if (state.status == AccountLinkingStatus.error) {
            if (ErrorUtils.hasSessionExpired(state.error)) {
              return;
            }
            _dismissDiscoveringAccountsDialog(context);
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(
                    ErrorUtils.getErrorMessage(
                      context,
                      state.error,
                      returnRawMessage: true,
                    ),
                  ),
                ),
              );
          }
        }

        if (state.mobileNumber.isNotEmpty && state.selectedFipInfo != null) {
          setState(() {
            _enabled = true;
          });
        } else if (_enabled) {
          setState(() {
            _enabled = false;
          });
        }
      },
      builder: (builderContext, state) {
        if (!_enabled) {
          return const SizedBox.shrink();
        }
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: ElevatedButton(
            style: ButtonStyle(
              minimumSize:
                  const WidgetStatePropertyAll(Size(double.infinity, 50)),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              backgroundColor: const WidgetStatePropertyAll(FinvuColors.blue),
              foregroundColor: const WidgetStatePropertyAll(Colors.white),
            ),
            onPressed: () {
              context
                  .read<AccountLinkingBloc>()
                  .add(const AccountLinkingDiscoveryInitiated());
            },
            child: Text(AppLocalizations.of(builderContext)!.next),
          ),
        );
      },
    );
  }

  void _showAddMobileNumberDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) {
        return BlocProvider.value(
          value: context.read<AccountLinkingBloc>(),
          child: AddNewMobileNumberDialog(
            onDialogButtonPressed: (mobileNumber) {
              context
                  .read<AccountLinkingBloc>()
                  .add(AccountLinkingMobileNumberAdded(mobileNumber));
            },
            subtitle: AppLocalizations.of(context)!.pleaseEnterMobileNumber,
          ),
        );
      },
    );
  }

  void _dismissDiscoveringAccountsDialog(BuildContext context) {
    if (_isShowingDiscoveringAccountsDialog) {
      Navigator.pop(context);
      setState(() {
        _isShowingDiscoveringAccountsDialog = false;
      });
    }
  }

  void _showDiscoveringAccountsDialog(BuildContext context) {
    if (_isShowingDiscoveringAccountsDialog) {
      return;
    }

    setState(() {
      _isShowingDiscoveringAccountsDialog = true;
    });

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) {
        return BlocProvider.value(
          value: context.read<AccountLinkingBloc>(),
          child: FinvuDialog(
            dismissible: false,
            textAlign: TextAlign.center,
            title: AppLocalizations.of(context)!.approachingYourBank,
            subtitle: [
              TextSpan(text: AppLocalizations.of(context)!.sitBackAndRelax),
            ],
            content: Image.asset(
              "lib/assets/finvu_discovering_accounts.png",
            ),
            onPressed: null,
          ),
        );
      },
    );
  }

  void _collectAdditionalIdentifier(
    BuildContext context,
    Identifier identifier,
  ) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) {
        return BlocProvider.value(
          value: context.read<AccountLinkingBloc>(),
          child: IdentifierInputDialog(
            identifier: identifier,
          ),
        );
      },
    );
  }
}
