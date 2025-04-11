import 'package:finvu_flutter_sdk/common/models/fi_models/account.dart';
import 'package:finvu_flutter_sdk/common/models/fi_models/deposit/deposit_transaction.dart';
import 'package:finvu_flutter_sdk/common/models/fi_models/deposit/deposit_transactions.dart';
import 'package:finvu_flutter_sdk/common/utils/finvu_date_utils.dart';
import 'package:finvu_flutter_sdk/common/utils/ui_utils.dart';
import 'package:finvu_flutter_sdk/common/widgets/finvu_page_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BankTransactionDetail extends StatelessWidget {
  final FIAccount account;

  const BankTransactionDetail({super.key, required this.account});

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
            child: displayTransactions(account.deposit!.transactions!),
          ),
        ],
      ),
    );
  }
}

Widget displayTransactions(DepositTransactions transaction) {
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
  final DepositTransaction transaction;

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
                    FinvuDateUtils.format(transaction.transactionTimestamp!),
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
            Text(
              "₹${transaction.amount}",
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 17,
                  color:
                      transaction.type == 'CREDIT' ? Colors.green : Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
