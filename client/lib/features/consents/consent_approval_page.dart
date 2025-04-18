import 'package:finvu_flutter_sdk/common/models/consent.dart';
import 'package:finvu_flutter_sdk/common/utils/analytics_events.dart';
import 'package:finvu_flutter_sdk/common/utils/constants.dart';
import 'package:finvu_flutter_sdk/common/utils/error_utils.dart';
import 'package:finvu_flutter_sdk/common/utils/finvu_colors.dart';
import 'package:finvu_flutter_sdk/common/utils/ui_utils.dart';
import 'package:finvu_flutter_sdk/common/widgets/base_page.dart';
import 'package:finvu_flutter_sdk/common/widgets/finvu_page_header.dart';
import 'package:finvu_flutter_sdk/common/widgets/finvu_scaffold.dart';
import 'package:finvu_flutter_sdk/features/auth/login/login_page.dart';
import 'package:finvu_flutter_sdk/features/consents/bloc/consent_bloc.dart';
import 'package:finvu_flutter_sdk/features/consents/views/consent_accounts_selection.dart';
import 'package:finvu_flutter_sdk/finvu_ui_manager.dart';
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
    final uiConfig = FinvuUIManager().uiConfig;
    final theme = Theme.of(context);

    return BlocConsumer<ConsentBloc, ConsentState>(
      listener: (context, state) {
        if (state.status == ConsentStatus.linkedAccountsFetched) {
          context.read<ConsentBloc>().add(
                FetchConsentDetails(
                  consentHandleId: FinvuUIManager().loginConfig.consentHandleId,
                ),
              );
        } else if (state.status == ConsentStatus.consentApproved ||
            state.status == ConsentStatus.consentRejected) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.status == ConsentStatus.consentApproved
                    ? AppLocalizations.of(context)!.consentSuccessMessage
                    : AppLocalizations.of(context)!.consentRejected,
                style: theme.textTheme.bodyMedium,
              ),
            ),
          );
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/', // Replace 'home' with the actual route name of the parent app's home page
            (route) => false,
          );
        } else if (state.status == ConsentStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                ErrorUtils.getErrorMessage(context, state.error),
                style: theme.textTheme.bodyMedium,
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state.consent == null) {
          return Center(
            child: uiConfig?.loderWidget ?? const CircularProgressIndicator(),
          );
        } else if (state.status == ConsentStatus.error) {
          return Center(
            child: Text(
              AppLocalizations.of(context)!.somethingWentWrong,
              style: theme.textTheme.bodyMedium ??
                  uiConfig?.textTheme.bodyMedium ??
                  const TextStyle(fontSize: 14, color: Colors.red),
            ),
          );
        }

        var consentRequestDetailInfo = state.consent!;
        final consentDetails = ConsentDetails.fromConsentRequestDetailInfo(
          consentRequestDetailInfo,
          null,
        );

        return FinvuScaffold(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      ConsentAccountsSelection(consent: consentDetails),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
