import 'package:finvu_flutter_sdk/common/models/fi_models/account.dart';
import 'package:finvu_flutter_sdk/common/models/fi_models/mutual_funds/mutual_fund_holding.dart';
import 'package:finvu_flutter_sdk/common/models/fi_models/mutual_funds/mutual_fund_investment.dart';
import 'package:finvu_flutter_sdk/common/utils/finvu_colors.dart';
import 'package:finvu_flutter_sdk/common/utils/finvu_date_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MutualFundHoldingTab extends StatelessWidget {
  const MutualFundHoldingTab({
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
                context, account.mutualFund!.summary.investment!)
          ],
        ),
      ),
    );
  }

  Widget displayTransactions(
      BuildContext context, MutualFundInvestment investment) {
    return Column(
      children: [
        for (var holding in investment.holding!)
          _notificationItem(context, holding),
      ],
    );
  }

  Widget _notificationItem(
    BuildContext context,
    MutualFundHolding item,
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
                                item.isinDescription.toString(),
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
                                item.closingUnits.toString(),
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
                          "${AppLocalizations.of(context)!.folioNo}: ${item.folioNo}",
                          style: const TextStyle(
                            fontSize: 12,
                            color: FinvuColors.grey81858F,
                          ),
                        ),
                        Text(
                          FinvuDateUtils.format(item.navDate!),
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
