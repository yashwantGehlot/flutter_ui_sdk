import 'package:collection/collection.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:finvu_flutter_sdk/common/models/fi_type_category.dart';
import 'package:finvu_flutter_sdk/common/utils/finvu_colors.dart';
import 'package:finvu_flutter_sdk/common/widgets/finvu_fip_icon.dart';
import 'package:finvu_flutter_sdk/features/accounts/bloc/accounts_bloc.dart';
import 'package:finvu_flutter_sdk/common/models/linked_account_with_fip.dart';
import 'package:finvu_flutter_sdk/features/accounts/linked_account_details_page.dart';
import 'package:finvu_flutter_sdk/features/accounts/widgets/account_activity_dialog.dart';
import 'package:finvu_flutter_sdk/features/accounts/widgets/account_delink_dialog.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AccountsList extends StatelessWidget {
  const AccountsList(
      {super.key,
      required this.onPressedAddAccount,
      this.category = FiTypeCategory.all});

  final FiTypeCategory category;
  final Function(FiTypeCategory category) onPressedAddAccount;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountsBloc, AccountsState>(
      builder: (context, state) {
        if (state.status == AccountsStatus.isFetchingAccounts ||
            state.status == AccountsStatus.unknown) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return Column(
          children: [
            ...FiTypeCategory.values.where((element) {
              if (category == FiTypeCategory.all) {
                return element != FiTypeCategory.all;
              } else {
                return element == category;
              }
            }).expand(
              (fiTypeCategory) => _buildLinkedAccountsWidgetForType(
                context,
                fiTypeCategory,
                state.linkedAccounts,
              ),
            ),
          ],
        );
      },
    );
  }

  List<Widget> _buildLinkedAccountsWidgetForType(
    BuildContext context,
    FiTypeCategory fiTypeCategory,
    List<LinkedAccountInfo> linkedAccounts,
  ) {
    final List<String> fiTypes =
        fiTypeCategory.fiTypes.map((e) => e.value).toList();
    final accountsForType = linkedAccounts
        .where((account) => fiTypes.contains(account.fiType))
        .toList();
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                fiTypeCategory.getLocalizedTitle(context),
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              const Padding(padding: EdgeInsets.only(left: 5)),
              accountsForType.isEmpty
                  ? const SizedBox.shrink()
                  : CircleAvatar(
                      backgroundColor: FinvuColors.greyE1E4EF,
                      radius: 12,
                      child: Text(
                        accountsForType.length.toString(),
                        style: const TextStyle(
                          color: FinvuColors.grey81858F,
                          fontSize: 12,
                        ),
                      ),
                    ),
            ],
          ),
          accountsForType.isEmpty
              ? const SizedBox.shrink()
              : Flexible(
                  child: TextButton.icon(
                    style:
                        TextButton.styleFrom(padding: const EdgeInsets.all(0)),
                    onPressed: () => onPressedAddAccount(fiTypeCategory),
                    icon: const Icon(
                      Icons.add_circle,
                      color: FinvuColors.blue,
                    ),
                    label: Text(
                      AppLocalizations.of(context)!.addNew,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 12,
                        color: FinvuColors.blue,
                      ),
                    ),
                  ),
                )
        ],
      ),
      const Padding(padding: EdgeInsets.only(top: 20)),
      accountsForType.isEmpty
          ? _buildAddNewAccountWidget(context, fiTypeCategory)
          : Column(
              children: accountsForType
                  .mapIndexed(
                    (index, account) => _buildLinkedAccountWidget(
                      context,
                      account,
                      (accountsForType.length - 1 != index),
                    ),
                  )
                  .toList(),
            ),
      const Padding(padding: EdgeInsets.only(top: 30)),
    ];
  }

  Widget _buildLinkedAccountWidget(
    BuildContext context,
    LinkedAccountInfo account,
    bool shouldAddBottomPadding,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: shouldAddBottomPadding ? 10 : 0),
      child: ListTile(
        tileColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        leading: FinvuFipIcon(
          iconUri: account.fipInfo.productIconUri,
          size: 35,
        ),
        title: Text(
          account.fipName,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 12,
            color: FinvuColors.black111111,
          ),
        ),
        subtitle: Text(
          "${account.accountType} ${account.maskedAccountNumber}",
          style: const TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 12,
            color: FinvuColors.grey81858F,
          ),
        ),
        trailing: OutlinedButton(
          child: Text(AppLocalizations.of(context)!.delink),
          onPressed: () => _showDelinkAccountDialog(context, account),
        ),
        onTap: () => _goToAccountDetailsPage(context, account),
      ),
    );
  }

  Widget _buildAddNewAccountWidget(
    BuildContext context,
    FiTypeCategory fiTypeCategory,
  ) {
    return DottedBorder(
      borderType: BorderType.RRect,
      radius: const Radius.circular(20),
      color: FinvuColors.blue,
      dashPattern: const [6, 2],
      child: ListTile(
        tileColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        leading: const Icon(
          Icons.add_circle,
          color: FinvuColors.blue,
        ),
        title: Text(
          AppLocalizations.of(context)!.addNew,
          style: const TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 14,
            color: FinvuColors.blue,
          ),
        ),
        onTap: () => onPressedAddAccount(fiTypeCategory),
      ),
    );
  }

  void _showAccountActivityDialog(
    BuildContext context,
    LinkedAccountInfo account,
  ) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => AccountActivityDialog(account: account),
    );
  }

  void _showDelinkAccountDialog(
    BuildContext context,
    LinkedAccountInfo account,
  ) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => BlocProvider.value(
        value: context.read<AccountsBloc>(),
        child: AccountDelinkDialog(account: account),
      ),
    );
  }

  void _goToAccountDetailsPage(
      BuildContext context, final LinkedAccountInfo account) async {
    final route = MaterialPageRoute(
      builder: (_) => LinkedAccountsDetailsPage(account: account),
    );
    Navigator.push(context, route);
  }
}
