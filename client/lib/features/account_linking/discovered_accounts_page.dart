import 'package:finvu_flutter_sdk/common/utils/analytics_events.dart';
import 'package:finvu_flutter_sdk/common/utils/constants.dart';
import 'package:finvu_flutter_sdk/common/widgets/base_page.dart';
import 'package:finvu_flutter_sdk/common/widgets/finvu_fip_icon.dart';
import 'package:finvu_flutter_sdk/common/widgets/finvu_page_header.dart';
import 'package:finvu_flutter_sdk/common/widgets/finvu_scaffold.dart';
import 'package:finvu_flutter_sdk/features/account_linking/bloc/account_linking_bloc.dart';
import 'package:finvu_flutter_sdk/features/account_linking/models/discovered_account.dart';
import 'package:finvu_flutter_sdk/features/account_linking/widgets/otp_input_dialog.dart';
import 'package:finvu_flutter_sdk/finvu_ui_manager.dart';
import 'package:finvu_flutter_sdk_core/finvu_discovered_accounts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finvu_flutter_sdk/l10n/app_localizations.dart';

class DiscoveredAccountsPage extends BasePage {
  const DiscoveredAccountsPage({
    super.key,
    required this.bloc,
  });

  final AccountLinkingBloc bloc;

  @override
  State<DiscoveredAccountsPage> createState() => _DiscoveredAccountsPageState();

  @override
  String routeName() {
    return FinvuScreens.discoveredAccountsPage;
  }
}

class _DiscoveredAccountsPageState
    extends BasePageState<DiscoveredAccountsPage> {
  final List<DiscoveredAccountInfo> _selectedAccounts = [];

  @override
  void initState() {
    super.initState();
    _selectedAccounts.addAll(widget.bloc.state.discoveredAccounts);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider.value(
      value: widget.bloc,
      child: BlocConsumer<AccountLinkingBloc, AccountLinkingState>(
        listener: (context, state) {
          if (state.status == AccountLinkingStatus.didSendOtp) {
            _showOtpCollectionDialog(context, state.selectedAccounts);
          } else if (state.status == AccountLinkingStatus.linkingSuccess) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(
                    AppLocalizations.of(context)!.linkingSuccessful,
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              );
            Navigator.pop(context, Constants.linkingSuccessful);
          }
        },
        builder: (builderContext, state) {
          final discoveredAccounts = state.discoveredAccounts;
          final fipInfo = state.selectedFipInfo!;

          final unlinkedAccountsList =
              discoveredAccounts.where((acc) => !acc.isLinked).toList();

          return FinvuScaffold(
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 30),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                FinvuFipIcon(
                                  iconUri: fipInfo.productIconUri,
                                  size: 30,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  fipInfo.productName ?? "",
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Text.rich(
                              TextSpan(
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                                children: [
                                  TextSpan(
                                      text: AppLocalizations.of(context)!
                                          .accountsDiscoveredWithMobileNumber),
                                  const TextSpan(text: ": "),
                                  TextSpan(
                                    text: state.mobileNumber,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: theme.colorScheme.onSurface,
                                    ),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.left,
                            ),
                            const SizedBox(height: 20),
                            ListView.separated(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: discoveredAccounts.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 10),
                              itemBuilder: (context, index) {
                                final account = discoveredAccounts[index];
                                return Row(
                                  children: [
                                    SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: Checkbox.adaptive(
                                        value:
                                            _selectedAccounts.contains(account),
                                        onChanged: account.isLinked
                                            ? null
                                            : (value) {
                                                setState(() {
                                                  if (value!) {
                                                    _selectedAccounts
                                                        .add(account);
                                                  } else {
                                                    _selectedAccounts
                                                        .remove(account);
                                                  }
                                                });
                                              },
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Expanded(
                                      child: ListTile(
                                        tileColor: theme.colorScheme.surface,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(14),
                                        ),
                                        leading: FinvuFipIcon(
                                          iconUri: fipInfo.productIconUri,
                                          size: 22,
                                        ),
                                        title: Text.rich(
                                          TextSpan(
                                            style: theme.textTheme.bodySmall,
                                            children: [
                                              TextSpan(
                                                  text: account.accountType),
                                              account.isLinked
                                                  ? TextSpan(
                                                      text:
                                                          " (${AppLocalizations.of(context)!.linked})",
                                                      style: theme
                                                          .textTheme.bodySmall
                                                          ?.copyWith(
                                                        color: Colors.green,
                                                      ),
                                                    )
                                                  : const TextSpan(),
                                            ],
                                          ),
                                        ),
                                        subtitle: Text(
                                          account.maskedAccountNumber,
                                          style: theme.textTheme.bodyMedium
                                              ?.copyWith(
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                            const SizedBox(
                                height:
                                    150), // 60 for bottom sheet, 30 + 30 for vertical padding = 150.
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: ElevatedButton(
                    style: theme.elevatedButtonTheme.style,
                    onPressed:
                        state.status == AccountLinkingStatus.isLinkingAccounts
                            ? null
                            : () {
                                if (unlinkedAccountsList.isEmpty) {
                                  Navigator.pop(context);
                                  return;
                                }

                                if (_selectedAccounts.isEmpty) {
                                  return;
                                }

                                widget.bloc.add(
                                  AccountLinkingInitiated(
                                    _selectedAccounts
                                        .where((account) => !account.isLinked)
                                        .toList(),
                                  ),
                                );
                              },
                    child: state.status ==
                            AccountLinkingStatus.isLinkingAccounts
                        ? const CircularProgressIndicator()
                        : Text(
                            unlinkedAccountsList.isEmpty
                                ? AppLocalizations.of(context)!.okay
                                : AppLocalizations.of(context)!.linkAccounts,
                          ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showOtpCollectionDialog(
    BuildContext context,
    List<FinvuDiscoveredAccountInfo> selectedAccounts,
  ) {
    final accountLinkingBloc = context.read<AccountLinkingBloc>();
    final applocalizations = AppLocalizations.of(context);

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) {
        return BlocProvider.value(
          value: accountLinkingBloc,
          child: OtpInputDialog(
            selectedAccounts: selectedAccounts,
            localizations: applocalizations!,
          ),
        );
      },
    );
  }
}
