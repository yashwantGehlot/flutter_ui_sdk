import 'package:finvu_flutter_sdk/common/models/fi_type_category.dart';
import 'package:finvu_flutter_sdk/common/utils/analytics_events.dart';
import 'package:finvu_flutter_sdk/common/utils/constants.dart';
import 'package:finvu_flutter_sdk/common/utils/error_utils.dart';
import 'package:finvu_flutter_sdk/common/utils/finvu_colors.dart';
import 'package:finvu_flutter_sdk/common/utils/ui_utils.dart';
import 'package:finvu_flutter_sdk/common/widgets/base_page.dart';
import 'package:finvu_flutter_sdk/common/widgets/finvu_page_header.dart';
import 'package:finvu_flutter_sdk/features/account_linking/bloc/account_linking_bloc.dart';
import 'package:finvu_flutter_sdk/features/account_linking/views/mobile_number_selection.dart';
import 'package:finvu_flutter_sdk/features/account_linking/views/next_button.dart';
import 'package:finvu_flutter_sdk/features/account_linking/views/search_fip_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AccountLinkingPage extends BasePage {
  const AccountLinkingPage({super.key, this.fiTypeCategory});

  final FiTypeCategory? fiTypeCategory;

  @override
  State<AccountLinkingPage> createState() => _AccountsPageState();

  @override
  String routeName() {
    return FinvuScreens.accountLinkingPage;
  }
}

class _AccountsPageState extends BasePageState<AccountLinkingPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          AccountLinkingBloc()..add(const AccountLinkingInitialized()),
      child: Scaffold(
        appBar: UIUtils.getFinvuAppBar(),
        backgroundColor: FinvuColors.lightBlue,
        body: BlocListener<AccountLinkingBloc, AccountLinkingState>(
          listener: (context, state) {
            if (state.status == AccountLinkingStatus.linkingSuccess) {
              Navigator.pop(context, Constants.linkingSuccessful);
            } else if (state.status == AccountLinkingStatus.error) {
              if (ErrorUtils.hasSessionExpired(state.error)) {
                handleSessionExpired(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      ErrorUtils.getErrorMessage(context, state.error),
                    ),
                  ),
                );
              }
            }
          },
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FinvuPageHeader(
                    title: AppLocalizations.of(context)!.addNewAccount),
                const Padding(
                  padding: EdgeInsets.only(top: 30),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    children: [
// Temporarily removed from UI, to prevent adding mobile number of any other user.
//                      const MobileNumberSelection(),
                      SearchFipList(fiTypeCategory: widget.fiTypeCategory),
                      const SizedBox(
                        height: 90,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomSheet: const NextButton(),
      ),
    );
  }
}
