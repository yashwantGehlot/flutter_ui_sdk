import 'package:finvu_flutter_sdk/common/utils/finvu_colors.dart';
import 'package:finvu_flutter_sdk/common/utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:finvu_flutter_sdk/l10n/app_localizations.dart';

class FinvuAuthUpsellPage extends StatelessWidget {
  const FinvuAuthUpsellPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const FinvuAuthUpsellPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UIUtils.getFinvuAppBackBar(),
      body: SafeArea(
        child: Builder(builder: (context) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 25, right: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(padding: EdgeInsets.only(top: 25)),
                  const Image(
                    image: AssetImage('lib/assets/finvu_logo.png'),
                    width: 120,
                  ),
                  const Padding(padding: EdgeInsets.only(top: 30)),
                  Text(AppLocalizations.of(context)!.managingConsentTitle,
                      style: const TextStyle(
                          fontSize: 20,
                          color: FinvuColors.blue,
                          fontWeight: FontWeight.bold)),
                  const Padding(padding: EdgeInsets.only(top: 20)),
                  _buildManagingConsentSubpointWidget(
                      "1", AppLocalizations.of(context)!.managingConsentPoint1),
                  const Padding(padding: EdgeInsets.only(top: 20)),
                  _buildManagingConsentSubpointWidget(
                      "2", AppLocalizations.of(context)!.managingConsentPoint2),
                  const Padding(padding: EdgeInsets.only(top: 20)),
                  _buildManagingConsentSubpointWidget(
                      "3", AppLocalizations.of(context)!.managingConsentPoint3),
                  const Padding(padding: EdgeInsets.only(top: 20)),
                  _buildManagingConsentSubpointWidget(
                      "4", AppLocalizations.of(context)!.managingConsentPoint4),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildManagingConsentSubpointWidget(
      final String pointNumer, final String description) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      CircleAvatar(
        backgroundColor: FinvuColors.blue,
        maxRadius: 12,
        child: Center(
          child: Text(
            pointNumer,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
      const Padding(padding: EdgeInsets.only(right: 16)),
      Expanded(child: Text(description)),
    ]);
  }
}
