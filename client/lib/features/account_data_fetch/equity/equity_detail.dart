import 'package:finvu_flutter_sdk/common/models/fi_models/account.dart';
import 'package:finvu_flutter_sdk/common/utils/analytics_events.dart';
import 'package:finvu_flutter_sdk/common/utils/finvu_colors.dart';
import 'package:finvu_flutter_sdk/common/utils/ui_utils.dart';
import 'package:finvu_flutter_sdk/common/widgets/base_page.dart';
import 'package:finvu_flutter_sdk/common/widgets/finvu_page_header.dart';
import 'package:finvu_flutter_sdk/features/account_data_fetch/equity/equity_holding_tab.dart';
import 'package:finvu_flutter_sdk/features/account_data_fetch/equity/equity_transaction_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EquityDetail extends BasePage {
  const EquityDetail({super.key, required this.account});
  final FIAccount account;

  @override
  State<EquityDetail> createState() => _EquityDetailState();

  @override
  String routeName() {
    return FinvuScreens.equityDetailPage;
  }
}

class _EquityDetailState extends BasePageState<EquityDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UIUtils.getFinvuAppBar(),
      body: Column(
        children: [
          FinvuPageHeader(
            title: widget.account.type.toString().toUpperCase(),
          ),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: DefaultTabController(
                    length: 2,
                    child: Column(
                      children: [
                        ColoredBox(
                          color: FinvuColors.darkBlue,
                          child: TabBar(
                            tabs: [
                              Tab(text: AppLocalizations.of(context)!.holdings),
                              Tab(
                                  text: AppLocalizations.of(context)!
                                      .transactions),
                            ],
                            labelColor: Colors.white,
                            indicatorColor: Colors.white,
                            unselectedLabelColor: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Expanded(
                          child: TabBarView(
                            children: [
                              EquityHoldingTab(
                                account: widget.account,
                              ),
                              EquityTransactionTab(
                                account: widget.account,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: FinvuColors.lightBlue,
    );
  }
}
