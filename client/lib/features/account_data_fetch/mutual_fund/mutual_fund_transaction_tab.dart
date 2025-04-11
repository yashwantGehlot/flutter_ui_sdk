import 'package:finvu_flutter_sdk/common/models/fi_models/account.dart';
import 'package:finvu_flutter_sdk/common/models/fi_models/mutual_funds/mutual_fund_transaction.dart';
import 'package:finvu_flutter_sdk/common/models/fi_models/mutual_funds/mutual_fund_transactions.dart';
import 'package:finvu_flutter_sdk/common/utils/finvu_colors.dart';
import 'package:finvu_flutter_sdk/common/utils/finvu_date_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MutualFundTransactionTab extends StatelessWidget {
  const MutualFundTransactionTab({
    super.key,
    required this.account,
  });

  final FIAccount account;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.only(top: 20, bottom: 20),
        child: Column(
          children: [
            displayTransactions(context, account.mutualFund!.transactions!)
          ],
        ),
      ),
    );
  }

  Widget displayTransactions(
      BuildContext context, MutualFundTransactions transaction) {
    return Column(
      children: [
        for (var transaction in transaction.transactions!)
          _transactionItem(context, transaction),
      ],
    );
  }

  Widget _transactionItem(
    BuildContext context,
    MutualFundTransaction item,
  ) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                item.narration.toString(),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: FinvuColors.black111111,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: Text(
                                item.amount.toString(),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: FinvuColors.black111111,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "${AppLocalizations.of(context)!.type}: ${item.type}",
                              style: TextStyle(
                                fontSize: 12,
                                color: item.type == 'BUY'
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                            const Spacer(),
                            Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: Text(
                                "${AppLocalizations.of(context)!.units}: ${item.units}",
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: FinvuColors.grey81858F,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "${AppLocalizations.of(context)!.isin}: ${item.isin}",
                          style: const TextStyle(
                            fontSize: 12,
                            color: FinvuColors.grey81858F,
                          ),
                        ),
                        Text(
                          "${AppLocalizations.of(context)!.transactionTime}: ${FinvuDateUtils.format(item.transactionDateTime!)}",
                          style: const TextStyle(
                            fontSize: 12,
                            color: FinvuColors.grey81858F,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 20, bottom: 20),
            child: Divider(
              height: 1,
              color: FinvuColors.greyE1E4EF,
            ),
          )
        ],
      ),
    );
  }
}
