import 'package:finvu_flutter_sdk/common/models/consent.dart';
import 'package:finvu_flutter_sdk/common/utils/analytics_events.dart';
import 'package:finvu_flutter_sdk/common/utils/constants.dart';
import 'package:finvu_flutter_sdk/common/utils/finvu_colors.dart';
import 'package:finvu_flutter_sdk/common/utils/ui_utils.dart';
import 'package:finvu_flutter_sdk/common/widgets/base_page.dart';
import 'package:finvu_flutter_sdk/common/widgets/finvu_page_header.dart';
import 'package:finvu_flutter_sdk/features/consents/bloc/consent_bloc.dart';
import 'package:finvu_flutter_sdk/features/consents/views/consent_accounts_selection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finvu_flutter_sdk/l10n/app_localizations.dart';

class ConsentApprovalPage extends BasePage {
  const ConsentApprovalPage({
    super.key,
  });

  @override
  State<ConsentApprovalPage> createState() => _ConsentApprovalPageState();

  @override
  String routeName() {
    return FinvuScreens.consentApprovalPage;
  }
}

class _ConsentApprovalPageState extends State<ConsentApprovalPage> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ConsentBloc, ConsentState>(listener: (context, state) {
      if (state.status == ConsentStatus.consentApproved ||
          state.status == ConsentStatus.consentRejected) {
        Navigator.pop(
          context,
          state.status == ConsentStatus.consentApproved
              ? Constants.consentApproved
              : Constants.consentRejected,
        );
      }
    }, buildWhen: (context, state) {
      return state.status == ConsentStatus.unknown;
    }, builder: (context, state) {
      context.read<ConsentBloc>().add(const LinkedAccountsRefresh());

      if (state.status == ConsentStatus.isFetchingConsentDetails) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else if (state.status == ConsentStatus.error) {
        return Center(
          child: Text(
            AppLocalizations.of(context)!.somethingWentWrong,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        );
      }
      return Scaffold(
        appBar: UIUtils.getFinvuAppBar(),
        backgroundColor: FinvuColors.lightBlue,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FinvuPageHeader(
                title: AppLocalizations.of(context)!.confirmYourApproval,
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // ConsentAccountsSelection(consent: state.consent!.con),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
