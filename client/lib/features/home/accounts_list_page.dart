import 'package:finvu_flutter_sdk/common/models/fi_type_category.dart';
import 'package:finvu_flutter_sdk/common/utils/analytics_events.dart';
import 'package:finvu_flutter_sdk/common/utils/constants.dart';
import 'package:finvu_flutter_sdk/common/utils/error_utils.dart';
import 'package:finvu_flutter_sdk/common/utils/finvu_colors.dart';
import 'package:finvu_flutter_sdk/common/utils/ui_utils.dart';
import 'package:finvu_flutter_sdk/common/widgets/finvu_page_header.dart';
import 'package:finvu_flutter_sdk/common/models/linked_account_with_fip.dart';
import 'package:finvu_flutter_sdk/features/account_linking/account_linking_page.dart';
import 'package:finvu_flutter_sdk/features/accounts/bloc/accounts_bloc.dart';
import 'package:finvu_flutter_sdk/features/accounts/views/accounts_list.dart';
import 'package:finvu_flutter_sdk/common/widgets/base_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountsListPage extends BasePage {
  const AccountsListPage({
    super.key,
    required this.title,
    required this.accounts,
  });
  final String title;
  final List<LinkedAccountInfo> accounts;

  @override
  State<AccountsListPage> createState() => _AccountsListPageState();

  @override
  String routeName() {
    return FinvuScreens.accountsListPage;
  }
}

class _AccountsListPageState extends BasePageState<AccountsListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UIUtils.getFinvuAppBar(),
      backgroundColor: FinvuColors.lightBlue,
      body: BlocProvider(
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
            final accountFiType = widget.accounts[0].fiType;
            FiTypeCategory matchedCategory = FiTypeCategory.bankAccounts;
            for (var category in FiTypeCategory.values) {
              if (category.fiTypes
                  .any((fiType) => fiType.value == accountFiType)) {
                matchedCategory = category;
                break;
              }
            }
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FinvuPageHeader(title: widget.title),
                  const Padding(
                    padding: EdgeInsets.only(top: 30),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: AccountsList(
                      onPressedAddAccount: (category) =>
                          _goToAccountLinkingPage(context, category),
                      category: matchedCategory,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
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
