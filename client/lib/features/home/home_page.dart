import 'package:finvu_flutter_sdk/common/utils/analytics_events.dart';
import 'package:finvu_flutter_sdk/common/utils/constants.dart';
import 'package:finvu_flutter_sdk/common/utils/error_utils.dart';
import 'package:finvu_flutter_sdk/common/widgets/account_add_upsell_banner.dart';
import 'package:finvu_flutter_sdk/common/widgets/base_page.dart';
import 'package:finvu_flutter_sdk/features/account_linking/account_linking_page.dart';
import 'package:finvu_flutter_sdk/features/consents/bloc/consent_bloc.dart';
import 'package:finvu_flutter_sdk/features/consents/views/consent_cards.dart';
import 'package:finvu_flutter_sdk/features/home/bloc/home_bloc.dart';
import 'package:finvu_flutter_sdk/features/home/views/header_with_info_cards.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends BasePage {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();

  @override
  String routeName() {
    return FinvuScreens.homePage;
  }
}

class _HomePageState extends BasePageState<HomePage> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeBloc>(
          create: (_) => HomeBloc()..add(const HomeRefresh()),
        ),
        BlocProvider<ConsentBloc>(
          create: (_) => ConsentBloc()..add(const ConsentsRefresh()),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<HomeBloc, HomeState>(
            listener: (context, state) {
              if (state.status == HomeStatus.error) {
                if (ErrorUtils.hasSessionExpired(state.error)) {
                  handleSessionExpired(context);
                } else {
                  SchedulerBinding.instance.addPostFrameCallback((_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          ErrorUtils.getErrorMessage(context, state.error),
                        ),
                      ),
                    );
                  });
                }
              }
            },
          ),
          BlocListener<ConsentBloc, ConsentState>(
            listener: (context, state) {
              if (state.status == ConsentStatus.consentApproved ||
                  state.status == ConsentStatus.consentRejected ||
                  state.status == ConsentStatus.consentRevoked) {
                String message = state.status == ConsentStatus.consentRevoked
                    ? AppLocalizations.of(context)!.consentRevoked
                    : state.status == ConsentStatus.consentApproved
                        ? AppLocalizations.of(context)!.consentApproved
                        : AppLocalizations.of(context)!.consentRejected;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(message),
                  ),
                );

                context.read<ConsentBloc>().add(const ConsentsRefresh());
              } else if (state.status == ConsentStatus.error) {
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
          ),
        ],
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const HeaderWithInfoCards(),
                  const Padding(
                    padding: EdgeInsets.only(top: 10),
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: AccountAddUpsellBanner(
                          onPressedAddAccount: () =>
                              _goToAccountLinkingPage(context),
                        ),
                      ),
                      const SizedBox(height: 15),
                      const ConsentCards()
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _goToAccountLinkingPage(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AccountLinkingPage(),
      ),
    );
    if (context.mounted && result != null && result is String) {
      if (result == Constants.linkingSuccessful) {
        context.read<HomeBloc>().add(const HomeRefresh());
      }
    }
  }
}
