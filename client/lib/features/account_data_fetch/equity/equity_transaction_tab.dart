import 'package:finvu_flutter_sdk/common/models/fi_models/account.dart';
import 'package:finvu_flutter_sdk/common/models/fi_models/equity/equity_transaction.dart';
import 'package:finvu_flutter_sdk/common/models/fi_models/equity/equity_transactions.dart';
import 'package:finvu_flutter_sdk/common/utils/finvu_colors.dart';
import 'package:finvu_flutter_sdk/common/utils/finvu_date_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EquityTransactionTab extends StatelessWidget {
  const EquityTransactionTab({
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
            displayTransactions(context, account.equities!.transactions!)
          ],
        ),
      ),
    );
  }

  Widget displayTransactions(
      BuildContext context, EquityTransactions transaction) {
    return Column(
      children: [
        for (var transaction in transaction.transactions!)
          _transactionItem(context, transaction),
      ],
    );
  }

  Widget _transactionItem(
    BuildContext context,
    EquityTransaction item,
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
                                item.companyName.toString(),
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
                                item.rate.toString(),
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
                              style: const TextStyle(
                                fontSize: 12,
                                color: FinvuColors.grey81858F,
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
