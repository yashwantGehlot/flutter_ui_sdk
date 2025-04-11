import 'package:finvu_flutter_sdk/common/models/consent.dart';
import 'package:finvu_flutter_sdk/common/utils/analytics_events.dart';
import 'package:finvu_flutter_sdk/common/utils/finvu_colors.dart';
import 'package:finvu_flutter_sdk/common/utils/ui_utils.dart';
import 'package:finvu_flutter_sdk/common/widgets/base_page.dart';
import 'package:finvu_flutter_sdk/common/widgets/consents_card.dart';
import 'package:finvu_flutter_sdk/common/widgets/finvu_page_header.dart';
import 'package:finvu_flutter_sdk/features/consents/bloc/consent_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConsentsListPage extends BasePage {
  const ConsentsListPage({
    super.key,
    required this.title,
    required this.primaryButtonTitle,
    required this.secondaryButtonTitle,
    required this.consents,
    required this.onPrimaryButtonClicked,
    required this.onSecondaryButtonClicked,
  });

  final String title;
  final String primaryButtonTitle;
  final String? secondaryButtonTitle;
  final List<ConsentDetails> consents;
  final Function(ConsentDetails) onPrimaryButtonClicked;
  final Function(ConsentDetails)? onSecondaryButtonClicked;

  @override
  State<ConsentsListPage> createState() => _ConsentsListPageState();

  @override
  String routeName() {
    return FinvuScreens.consentsListPage;
  }
}

class _ConsentsListPageState extends State<ConsentsListPage> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ConsentBloc, ConsentState>(
      builder: (context, state) {
        return Scaffold(
          appBar: UIUtils.getFinvuAppBar(),
          backgroundColor: FinvuColors.lightBlue,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FinvuPageHeader(title: widget.title),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: ConsentsCard(
                    title: widget.title,
                    consents: widget.consents,
                    showAll: true,
                    primaryButtonTitle: widget.primaryButtonTitle,
                    secondaryButtonTitle: widget.secondaryButtonTitle,
                    onPrimaryButtonClicked: (consent) {
                      widget.onPrimaryButtonClicked(consent);
                    },
                    onSecondaryButtonClicked: (consent) {
                      widget.onSecondaryButtonClicked!(consent);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
      listener: (BuildContext context, ConsentState state) {
        if (state.status == ConsentStatus.consentApproved ||
            state.status == ConsentStatus.consentRejected ||
            state.status == ConsentStatus.consentRevoked) {
          Navigator.pop(context);
        }
      },
    );
  }
}
