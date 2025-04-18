import 'package:finvu_flutter_sdk/common/utils/error_utils.dart';
import 'package:finvu_flutter_sdk/common/utils/finvu_colors.dart';
import 'package:finvu_flutter_sdk/common/widgets/finvu_dialog.dart';
import 'package:finvu_flutter_sdk/features/account_linking/bloc/account_linking_bloc.dart';
import 'package:finvu_flutter_sdk/features/account_linking/models/identifier.dart';
import 'package:finvu_flutter_sdk/features/account_linking/discovered_accounts_page.dart';
import 'package:finvu_flutter_sdk/features/account_linking/widgets/add_new_mobile_number_dialog.dart';
import 'package:finvu_flutter_sdk/features/account_linking/widgets/dob_input.dart';
import 'package:finvu_flutter_sdk/features/account_linking/widgets/identifier_input_dialog.dart';
import 'package:finvu_flutter_sdk/features/account_linking/views/no_accounts_found_page.dart';
import 'package:finvu_flutter_sdk/finvu_ui_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finvu_flutter_sdk/l10n/app_localizations.dart';

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
    final theme = Theme.of(context);
    final uiConfig = FinvuUIManager().uiConfig;

    return BlocConsumer<AccountLinkingBloc, AccountLinkingState>(
      listener: (listnerContext, state) async {
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
            await Future.delayed(Duration.zero);
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
              await Navigator.push(
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
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          child: uiConfig?.isElevatedButton ?? true
              ? ElevatedButton(
                  style: theme.elevatedButtonTheme.style?.copyWith(
                    minimumSize: MaterialStateProperty.all(
                      const Size(double.infinity, 50),
                    ),
                  ),
                  onPressed: () {
                    context
                        .read<AccountLinkingBloc>()
                        .add(const AccountLinkingDiscoveryInitiated());
                  },
                  child: Text(
                    AppLocalizations.of(builderContext)!.next,
                  ),
                )
              : OutlinedButton(
                  style: theme.outlinedButtonTheme.style?.copyWith(
                    minimumSize: MaterialStateProperty.all(
                      const Size(double.infinity, 50),
                    ),
                  ),
                  onPressed: () {
                    context
                        .read<AccountLinkingBloc>()
                        .add(const AccountLinkingDiscoveryInitiated());
                  },
                  child: Text(
                    AppLocalizations.of(builderContext)!.next,
                  ),
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
      Navigator.of(context, rootNavigator: true).pop();
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
    final accountLinkingBloc = context.read<AccountLinkingBloc>();
    final title = AppLocalizations.of(context)!.approachingYourBank;
    final subTitle = AppLocalizations.of(context)!.sitBackAndRelax;
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) {
        return BlocProvider.value(
          value: accountLinkingBloc,
          child: FinvuDialog(
            dismissible: false,
            textAlign: TextAlign.center,
            title: title,
            subtitle: [
              TextSpan(
                text: subTitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontFamily: FinvuUIManager().uiConfig?.fontFamily,
                    color: FinvuUIManager().uiConfig?.primaryColor),
              ),
            ],
            content: const Image(
              image: AssetImage(
                "lib/assets/finvu_discovering_accounts.png",
                package: 'finvu_flutter_sdk',
              ),
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
    final accountLinkingBloc = context.read<AccountLinkingBloc>();
    final localizations = AppLocalizations.of(context);

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) {
        return BlocProvider.value(
          value: accountLinkingBloc,
          child: IdentifierInputDialog(
            identifier: identifier,
            localizations: localizations!,
          ),
        );
      },
    );

    DoBInput(
      onChanged: (value) {
        // Handle the date of birth value
      },
      localizations: localizations!,
    );
  }
}
