import 'package:finvu_flutter_sdk/common/models/linked_account_with_fip.dart';
import 'package:finvu_flutter_sdk/common/utils/finvu_colors.dart';
import 'package:finvu_flutter_sdk/features/home/accounts_list_page.dart';
import 'package:finvu_flutter_sdk/features/home/bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HeaderWithInfoCards extends StatelessWidget {
  const HeaderWithInfoCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildBackdropWidget(),
        _buildWelcomMessageWidget(context),
        const InfoCardsWidget(),
      ],
    );
  }

  Widget _buildBackdropWidget() {
    return const SizedBox(
      width: double.infinity,
      height: 178,
      child: DecoratedBox(
        decoration: BoxDecoration(color: FinvuColors.darkBlue),
      ),
    );
  }

  Widget _buildWelcomMessageWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25, top: 54),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 30),
          child: Text(
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 20,
              color: Colors.white,
            ),
            AppLocalizations.of(context)!.welcomeMessage,
          ),
        ),
      ),
    );
  }
}

class InfoCardsWidget extends StatelessWidget {
  static const int _cardIndexBankAccounts = 1;
  static const int _cardIndexInsurancePolicies = 2;
  static const int _cardIndexEquityHoldings = 3;

  const InfoCardsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(top: 108),
          child: SizedBox(
            height: 110,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              itemBuilder: (itemContext, index) {
                if (index == 0) {
                  return const SizedBox(width: 25);
                }

                return InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () => _handleCardTap(context, index, state),
                  child: Card(
                    color: FinvuColors.lightPurple,
                    surfaceTintColor: Colors.transparent,
                    child: SizedBox(
                      width: 140,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 15,
                          right: 15,
                          top: 15,
                        ),
                        child: Column(
                          children: [
                            _getWidgetForCardIndex(context, index, state),
                            const SizedBox(height: 8),
                            Align(
                              alignment: AlignmentDirectional.centerStart,
                              child: Text(
                                _getTitleForCardIndex(context, index),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  String _getTitleForCardIndex(BuildContext context, int index) {
    switch (index) {
      case _cardIndexBankAccounts:
        return AppLocalizations.of(context)!.bankAccounts;
      case _cardIndexInsurancePolicies:
        return AppLocalizations.of(context)!.insurancePolicies;
      case _cardIndexEquityHoldings:
        return AppLocalizations.of(context)!.equityHoldings;
      default:
        return '';
    }
  }

  Widget _getWidgetForCardIndex(
    BuildContext context,
    int index,
    HomeState state,
  ) {
    switch (index) {
      case _cardIndexBankAccounts:
        return _cardContentWidget(
          "lib/assets/bank_icon.png",
          state.bankAccounts.length,
        );
      case _cardIndexInsurancePolicies:
        return _cardContentWidget(
          "lib/assets/insurance_policies_icon.png",
          state.insurancePolicies.length,
        );
      case _cardIndexEquityHoldings:
        return _cardContentWidget(
          "lib/assets/equity_holdings_icon.png",
          state.equityHoldings.length,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Row _cardContentWidget(String assetPath, int value) {
    return Row(
      children: [
        Image.asset(
          assetPath,
          width: 40,
          height: 40,
        ),
        const SizedBox(width: 8),
        Text(
          "$value",
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  void _handleCardTap(
    BuildContext context,
    int index,
    HomeState state,
  ) async {
    List<LinkedAccountInfo> accounts = [];
    String title = '';
    switch (index) {
      case _cardIndexBankAccounts:
        accounts = state.bankAccounts;
        title = AppLocalizations.of(context)!.bankAccounts;
        break;
      case _cardIndexInsurancePolicies:
        accounts = state.insurancePolicies;
        title = AppLocalizations.of(context)!.insurancePolicies;
        break;
      case _cardIndexEquityHoldings:
        accounts = state.equityHoldings;
        title = AppLocalizations.of(context)!.equityHoldings;
        break;
    }

    if (accounts.isEmpty) {
      return;
    }

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AccountsListPage(
          title: title,
          accounts: accounts,
        ),
      ),
    );
  }
}
