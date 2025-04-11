import 'package:finvu_flutter_sdk/common/models/insurance/insurance_summary.dart';
import 'package:finvu_flutter_sdk/common/utils/analytics_events.dart';
import 'package:finvu_flutter_sdk/common/utils/finvu_colors.dart';
import 'package:finvu_flutter_sdk/common/utils/finvu_date_utils.dart';
import 'package:finvu_flutter_sdk/common/utils/ui_utils.dart';
import 'package:finvu_flutter_sdk/common/widgets/base_page.dart';
import 'package:finvu_flutter_sdk/common/widgets/finvu_page_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InsuranceDetail extends BasePage {
  const InsuranceDetail({super.key, required this.summary});
  final InsuranceSummary summary;

  @override
  State<InsuranceDetail> createState() => _InsuranceDetailState();

  @override
  String routeName() {
    return FinvuScreens.insuranceDetailPage;
  }
}

class _InsuranceDetailState extends BasePageState<InsuranceDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UIUtils.getFinvuAppBar(),
      body: Column(
        children: [
          FinvuPageHeader(
            title: widget.summary.policyType.toString().toUpperCase(),
          ),
          Expanded(
            child: Column(
              children: [
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            elevation: 0,
                            color: FinvuColors.greyF5F5F5,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        widget.summary.policyName.toString(),
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: FinvuColors.black111111,
                                        ),
                                      ),
                                      const Spacer(),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          "#${widget.summary.policyNumber}",
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: FinvuColors.black111111,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "${AppLocalizations.of(context)!.sumAssured}: ${widget.summary.sumAssured}",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: FinvuColors.grey81858F,
                                    ),
                                  ),
                                  Text(
                                    "${AppLocalizations.of(context)!.startDate}: ${FinvuDateUtils.format(widget.summary.policyStartDate!)}",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: FinvuColors.grey81858F,
                                    ),
                                  ),
                                  Text(
                                    "${AppLocalizations.of(context)!.expiryDate}: ${FinvuDateUtils.format(widget.summary.policyExpiryDate!)}",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: FinvuColors.grey81858F,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  const Divider(
                                    color: FinvuColors.greyD8E1EE,
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  Text(
                                    "${AppLocalizations.of(context)!.policyType}: ${widget.summary.policyType}",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: FinvuColors.grey81858F,
                                    ),
                                  ),
                                  Text(
                                    "${AppLocalizations.of(context)!.premiumAmount}: ${widget.summary.premiumAmount}",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: FinvuColors.grey81858F,
                                    ),
                                  ),
                                  Text(
                                    "${AppLocalizations.of(context)!.premiumFrequency}: ${widget.summary.premiumFrequency}",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: FinvuColors.grey81858F,
                                    ),
                                  ),
                                  Text(
                                    "${AppLocalizations.of(context)!.premiumPaymentYears}: ${widget.summary.premiumPaymentYears}",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: FinvuColors.grey81858F,
                                    ),
                                  ),
                                  Text(
                                    "${AppLocalizations.of(context)!.nextPremium}: ${FinvuDateUtils.format(widget.summary.nextPremiumDueDate!)}",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: FinvuColors.grey81858F,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
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
          ),
        ],
      ),
      backgroundColor: FinvuColors.lightBlue,
    );
  }
}
