import 'package:finvu_flutter_sdk/common/models/fi_models/account.dart';
import 'package:finvu_flutter_sdk/common/models/fi_models/equity/equity_holding.dart';
import 'package:finvu_flutter_sdk/common/models/fi_models/equity/equity_holdings.dart';
import 'package:finvu_flutter_sdk/common/utils/finvu_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EquityHoldingTab extends StatelessWidget {
  const EquityHoldingTab({
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
            displayTransactions(
                context, account.equities!.summary.investment!.holdings!)
          ],
        ),
      ),
    );
  }

  Widget displayTransactions(BuildContext context, EquityHoldings holdings) {
    return Column(
      children: [
        for (var holding in holdings.holding!)
          _notificationItem(context, holding),
      ],
    );
  }

  Widget _notificationItem(
    BuildContext context,
    EquityHolding item,
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
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                item.issuerName.toString(),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: FinvuColors.black111111,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                item.lastTradedPrice.toString(),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: FinvuColors.black111111,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "${AppLocalizations.of(context)!.units}: ${item.units}",
                          style: const TextStyle(
                            fontSize: 12,
                            color: FinvuColors.grey81858F,
                          ),
                        ),
                        Text(
                          "${AppLocalizations.of(context)!.isin}: ${item.isin}",
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
