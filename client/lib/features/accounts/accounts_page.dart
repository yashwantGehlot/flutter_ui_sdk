import 'package:finvu_flutter_sdk/common/models/fi_type_category.dart';
import 'package:finvu_flutter_sdk/common/utils/analytics_events.dart';
import 'package:finvu_flutter_sdk/common/utils/constants.dart';
import 'package:finvu_flutter_sdk/common/utils/error_utils.dart';
import 'package:finvu_flutter_sdk/common/widgets/base_page.dart';
import 'package:finvu_flutter_sdk/common/widgets/finvu_page_header.dart';
import 'package:finvu_flutter_sdk/features/account_linking/account_linking_page.dart';
import 'package:finvu_flutter_sdk/features/accounts/bloc/accounts_bloc.dart';
import 'package:finvu_flutter_sdk/features/accounts/views/accounts_list.dart';
import 'package:finvu_flutter_sdk/common/widgets/account_add_upsell_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finvu_flutter_sdk/l10n/app_localizations.dart';

class AccountsPage extends BasePage {
  const AccountsPage({super.key});

  @override
  State<AccountsPage> createState() => _AccountsPageState();

  @override
  String routeName() {
    return FinvuScreens.accountsPage;
  }
}

class _AccountsPageState extends BasePageState<AccountsPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AccountsBloc()..add(const AccountsRefresh()),
      child: BlocConsumer<AccountsBloc, AccountsState>(
        listener: (context, state) {
          if (state.status == AccountsStatus.error) {
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
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FinvuPageHeader(title: AppLocalizations.of(context)!.accounts),
                const Padding(
                  padding: EdgeInsets.only(top: 30),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    children: [
                      AccountAddUpsellBanner(
                        onPressedAddAccount: () =>
                            _goToAccountLinkingPage(context, null),
                      ),
                      AccountsList(
                        onPressedAddAccount: (category) =>
                            _goToAccountLinkingPage(context, category),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _goToAccountLinkingPage(
    final BuildContext context,
    final FiTypeCategory? fiTypeCategory,
  ) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            AccountLinkingPage(fiTypeCategory: fiTypeCategory),
      ),
    );
    if (context.mounted && result != null && result is String) {
      if (result == Constants.linkingSuccessful) {
        context.read<AccountsBloc>().add(const AccountsRefresh());
      }
    }
  }
}
