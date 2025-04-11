import 'package:finvu_flutter_sdk/common/utils/analytics_events.dart';
import 'package:finvu_flutter_sdk/common/utils/finvu_colors.dart';
import 'package:finvu_flutter_sdk/common/utils/finvu_date_utils.dart';
import 'package:finvu_flutter_sdk/common/utils/ui_utils.dart';
import 'package:finvu_flutter_sdk/common/widgets/base_page.dart';
import 'package:finvu_flutter_sdk/common/widgets/finvu_page_header.dart';
import 'package:finvu_flutter_sdk_core/finvu_consent_history.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ConsentHistoryPage extends BasePage {
  const ConsentHistoryPage({
    super.key,
    required this.consentHistory,
  });

  final List<FinvuConsentHistory> consentHistory;

  @override
  State<ConsentHistoryPage> createState() => _ConsentHistoryPageState();

  @override
  String routeName() {
    return FinvuScreens.consentHistoryPage;
  }
}

class _ConsentHistoryPageState extends BasePageState<ConsentHistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UIUtils.getFinvuAppBar(),
      backgroundColor: FinvuColors.lightBlue,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FinvuPageHeader(
            title: AppLocalizations.of(context)!.dataRetrievalTimestamps,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Scrollbar(
                thumbVisibility: true,
                child: ListView.builder(
                  itemCount: widget.consentHistory.length,
                  itemBuilder: (context, index) {
                    final consentTimestamp =
                        widget.consentHistory[index].consentTimestamp;
                    return ListTile(
                      title: Text(
                        consentTimestamp != null
                            ? FinvuDateUtils.format(consentTimestamp)
                            : AppLocalizations.of(context)!.somethingWentWrong,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
