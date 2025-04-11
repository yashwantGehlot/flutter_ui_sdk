import 'package:finvu_flutter_sdk/common/models/fi_models/account.dart';
import 'package:finvu_flutter_sdk/common/models/fi_models/term_deposit/term_deposit_transaction.dart';
import 'package:finvu_flutter_sdk/common/models/fi_models/term_deposit/term_deposit_transactions.dart';
import 'package:finvu_flutter_sdk/common/utils/finvu_date_utils.dart';
import 'package:finvu_flutter_sdk/common/utils/ui_utils.dart';
import 'package:finvu_flutter_sdk/common/widgets/finvu_page_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TermDepositTransactionDetail extends StatelessWidget {
  final FIAccount account;

  const TermDepositTransactionDetail({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UIUtils.getFinvuAppBar(),
      body: Column(
        children: [
          FinvuPageHeader(
            title: AppLocalizations.of(context)!.transactions,
          ),
          const SizedBox(height: 20),
          Expanded(
            child: displayTransactions(account.termDeposit!.transactions!),
          ),
        ],
      ),
    );
  }
}

Widget displayTransactions(TermDepositTransactions transaction) {
  return ListView.builder(
    itemCount: transaction.transactions?.length,
    itemBuilder: (context, index) {
      return TransactionItem(
        transaction: transaction.transactions![index],
      );
    },
  );
}

class TransactionItem extends StatelessWidget {
  final TermDepositTransaction transaction;

  const TransactionItem({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        tileColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.narration!,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14),
                    softWrap: true,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    FinvuDateUtils.format(transaction.transactionDateTime!),
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
            Text(
              "₹${transaction.amount}",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 17,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
