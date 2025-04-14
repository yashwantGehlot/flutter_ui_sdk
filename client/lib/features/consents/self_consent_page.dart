import 'package:finvu_flutter_sdk/common/models/consent.dart';
import 'package:finvu_flutter_sdk/common/models/linked_account_with_fip.dart';
import 'package:finvu_flutter_sdk/common/models/self_consent_details.dart';
import 'package:finvu_flutter_sdk/common/utils/analytics_events.dart';
import 'package:finvu_flutter_sdk/common/utils/error_utils.dart';
import 'package:finvu_flutter_sdk/common/utils/finvu_colors.dart';
import 'package:finvu_flutter_sdk/common/utils/finvu_date_utils.dart';
import 'package:finvu_flutter_sdk/common/utils/remote_config_service.dart';
import 'package:finvu_flutter_sdk/common/utils/ui_utils.dart';
import 'package:finvu_flutter_sdk/common/widgets/base_page.dart';
import 'package:finvu_flutter_sdk/common/widgets/finvu_fip_icon.dart';
import 'package:finvu_flutter_sdk/common/widgets/finvu_page_header.dart';
import 'package:finvu_flutter_sdk/features/accounts/account_utils.dart';
import 'package:finvu_flutter_sdk/features/consents/bloc/consent_bloc.dart';
import 'package:finvu_flutter_sdk_core/finvu_consent_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finvu_flutter_sdk/l10n/app_localizations.dart';

enum SelfConsentFlowOrigin {
  accountLinking,
  other,
}

class SelfConsentPage extends BasePage {
  const SelfConsentPage({
    super.key,
    required this.accounts,
    this.selfConsentFlowOrigin,
  });

  final List<LinkedAccountInfo> accounts;
  final SelfConsentFlowOrigin? selfConsentFlowOrigin;

  @override
  State<SelfConsentPage> createState() => _SelfConsentPageState();

  @override
  String routeName() {
    return FinvuScreens.selfConsentPage;
  }
}

enum SelfConsentType { recommended, custom }

class _SelfConsentPageState extends BasePageState<SelfConsentPage> {
  var showAllChips = false;
  var isLoading = false;
  late SelfConsentDetails selfConsentDetails;
  final remoteConfig = RemoteConfigService();

  @override
  void initState() {
    super.initState();

    final List<String> fiTypes = widget.accounts
        .expand((element) => element.fipInfo.fipFitypes)
        .toSet()
        .toList();

    final List<String> consentTypes =
        ConsentType.values.map((consentType) => consentType.value).toList();

    selfConsentDetails = SelfConsentDetails(
      createTime: DateTime.now(),
      startTime: DateTime.now(),
      expireTime: DateTime.now()
          .add(Duration(days: remoteConfig.selfConsentExpireTimeInDays)),
      linkedAccounts: widget.accounts,
      fiTypes: fiTypes,
      consentTypes: consentTypes,
      mode: remoteConfig.selfConsentMode,
      fetchType: remoteConfig.selfConsentFetchType,
      frequency: FinvuConsentDataFrequency(
        unit: remoteConfig.selfConsentFrequencyUnit,
        value: remoteConfig.selfConsentFrequencyValue.toDouble(),
      ),
      dataLife: FinvuConsentDataLifePeriod(
        unit: remoteConfig.selfConsentDataLifeUnit,
        value: remoteConfig.selfConsentDataLifeValue.toDouble(),
      ),
      purposeText: '',
      purposeType: remoteConfig.selfConsentPurposeType,
    );
  }

  @override
  Widget build(BuildContext context) {
    selfConsentDetails.purposeText = AppLocalizations.of(context)!
        .customerSpendingPatternsBudgetOrOtherReportings;
    return Scaffold(
      appBar: UIUtils.getFinvuAppBar(),
      backgroundColor: FinvuColors.lightBlue,
      body: BlocConsumer<ConsentBloc, ConsentState>(
        listener: (context, state) {
          if (state.status == ConsentStatus.isRequestingSelfConsent) {
            setState(() {
              isLoading = true;
            });
          } else if (state.status == ConsentStatus.selfConsentRequested) {
            context.read<ConsentBloc>().add(const ConsentsRefresh());
          } else if (state.status == ConsentStatus.consentsFetched) {
            setState(() {
              isLoading = false;
            });

            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(
                    AppLocalizations.of(context)!.consentSuccessMessage,
                  ),
                ),
              );

            var account = widget.accounts.first;
            var activeSelfConsent = getConsentsForAccount(
              state.activeSelfConsents,
              account.linkReferenceNumber,
            );

//            _goToAccountDataPage(context, activeSelfConsent!, account);
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
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: FinvuColors.darkBlue,
                  child: Column(
                    children: [
                      if (widget.selfConsentFlowOrigin ==
                          SelfConsentFlowOrigin.accountLinking)
                        _buildHeaderTopContent(context),
                      FinvuPageHeader(
                        title: AppLocalizations.of(context)!.provideConsent,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Card(
                        color: Colors.white,
                        surfaceTintColor: Colors.transparent,
                        elevation: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.accounts,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 15),
                              _buildAccountsListWidget(widget.accounts),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),
                      _buildConsentConfigurationWidget(
                        context,
                        selfConsentDetails,
                      ),
                      _buildActionButtons(context, selfConsentDetails),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeaderTopContent(BuildContext context) {
    return Container(
      color: FinvuColors.darkBlue,
      child: Padding(
        padding: const EdgeInsets.only(left: 20, top: 30),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Image(
              width: 50,
              height: 50,
              image: AssetImage('lib/assets/greenRingWithTick.png'),
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.bankAccountsLinkedSuccess,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    AppLocalizations.of(context)!.bankAccountsLinkedConsent,
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: FinvuColors.grey81858F,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConsentConfigurationWidget(
    final BuildContext context,
    final SelfConsentDetails selfConsentDetails,
  ) {
    return Card(
      color: Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildConfigurationCard(context, selfConsentDetails),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildConfigurationCard(
    final BuildContext context,
    final SelfConsentDetails selfConsentDetails,
  ) {
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 10, left: 0, right: 0),
      child: Column(
        children: [
          _buildConfigTitleWidget(context, selfConsentDetails),
          const Divider(),
          _buildDataLifeGrid([
            {
              "title": AppLocalizations.of(context)!.dataFetchFrequency,
              "value": AppLocalizations.of(context)!.timesPerUnit(
                selfConsentDetails.frequency.value.toInt(),
                selfConsentDetails.frequency.unit,
              )
            },
            {
              "title": AppLocalizations.of(context)!.dataUse,
              "value": AppLocalizations.of(context)!.timesPerUnit(
                selfConsentDetails.dataLife.value.toInt(),
                selfConsentDetails.dataLife.unit,
              )
            },
            {
              "title": AppLocalizations.of(context)!.dataFetchFrom,
              "value": FinvuDateUtils.formatToDate(selfConsentDetails.startTime)
            },
            {
              "title": AppLocalizations.of(context)!.dataFetchUntil,
              "value":
                  FinvuDateUtils.formatToDate(selfConsentDetails.expireTime)
            }
          ]),
          const SizedBox(
            height: 20,
          ),
          _buildTilesWidget(
            context,
            selfConsentDetails.consentTypes,
            AppLocalizations.of(context)!.accountInformation,
          ),
          const SizedBox(height: 10),
          _buildDataLifeGrid([
            {
              "title": AppLocalizations.of(context)!.consentRequestedOn,
              "value": FinvuDateUtils.formatToDate(selfConsentDetails.startTime)
            },
            {
              "title": AppLocalizations.of(context)!.consentExpiresOn,
              "value":
                  FinvuDateUtils.formatToDate(selfConsentDetails.expireTime)
            }
          ]),
          const SizedBox(
            height: 20,
          ),
          const Divider(),
          _buildTilesWidget(
            context,
            selfConsentDetails.fiTypes,
            AppLocalizations.of(context)!.accountTypesRequested,
          ),
        ],
      ),
    );
  }

  Widget _buildDataLifeGrid(List<Map<String, String>> data) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 4,
      ),
      itemCount: data.length,
      itemBuilder: (context, index) {
        dynamic value = data[index];
        return _buildTitleWidget(value["title"], value["value"]);
      },
    );
  }

  Widget _buildTitleWidget(String title, String subtitle) {
    return ListTile(
      dense: true,
      tileColor: Colors.white,
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
          color: FinvuColors.black111111,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 13,
          color: FinvuColors.black111111,
        ),
      ),
    );
  }

  Widget _buildTilesWidget(
    final BuildContext context,
    final List<String> data,
    final String title,
  ) {
    final List<String> displayItems;

    if (showAllChips == true || data.length <= 3) {
      displayItems = data;
    } else {
      displayItems = data.sublist(0, 3);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
            color: FinvuColors.black111111,
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            alignment: WrapAlignment.start,
            children: <Widget>[
              for (var item in displayItems)
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Chip(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      side: const BorderSide(color: Colors.grey),
                    ),
                    label: Text(item),
                    labelStyle: const TextStyle(fontSize: 10),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  ),
                ),
              if (!showAllChips && data.length > 3)
                GestureDetector(
                  child: Text(
                    AppLocalizations.of(context)!.plusMore(data.length - 3),
                  ),
                  onTap: () {
                    setState(() {
                      showAllChips = true;
                    });
                  },
                )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildConfigTitleWidget(
    final BuildContext context,
    final SelfConsentDetails selfConsentDetails,
  ) {
    return ListTile(
      dense: true,
      tileColor: Colors.white,
      contentPadding: EdgeInsets.zero,
      minVerticalPadding: 0,
      title: Text(
        AppLocalizations.of(context)!.consentPurpose,
        style: const TextStyle(
          fontSize: 15,
          color: FinvuColors.black111111,
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 0),
        child: Text(
          selfConsentDetails.purposeText,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: FinvuColors.black111111,
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(
    final BuildContext context,
    final SelfConsentDetails selfConsentDetails,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 1,
            child: ElevatedButton(
              style: ButtonStyle(
                padding: WidgetStateProperty.all(
                    const EdgeInsets.only(top: 12, bottom: 12)),
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: const BorderSide(color: FinvuColors.blue)),
                ),
                backgroundColor: const WidgetStatePropertyAll(Colors.white),
                foregroundColor: const WidgetStatePropertyAll(FinvuColors.blue),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(AppLocalizations.of(context)!.skip),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            flex: 1,
            child: ElevatedButton(
              style: ButtonStyle(
                padding: WidgetStateProperty.all(
                    const EdgeInsets.only(top: 12, bottom: 12)),
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                backgroundColor: WidgetStatePropertyAll(widget.accounts.isEmpty
                    ? FinvuColors.grey81858F
                    : FinvuColors.blue),
                foregroundColor: const WidgetStatePropertyAll(Colors.white),
              ),
              onPressed: widget.accounts.isEmpty
                  ? null
                  : () {
                      if (widget.accounts.isEmpty) {
                        return;
                      }

                      context.read<ConsentBloc>().add(
                            SelfConsentRequest(
                              selfConsentDetails: selfConsentDetails,
                            ),
                          );
                    },
              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(color: Colors.white),
                    )
                  : Text(AppLocalizations.of(context)!.confirm),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildAccountsListWidget(List<LinkedAccountInfo> linkedAccounts) {
    return Column(
      children: linkedAccounts
          .map((account) => _buildLinkedAccountWidget(account))
          .toList(),
    );
  }

  Widget _buildLinkedAccountWidget(
    LinkedAccountInfo account,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        tileColor: FinvuColors.greyF3F5FD,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        leading: FinvuFipIcon(
          iconUri: account.fipInfo.productIconUri,
          size: 35,
        ),
        title: Text(
          account.fipName,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 12,
            color: FinvuColors.black111111,
          ),
        ),
        subtitle: Text(
          "${account.accountType} ${account.maskedAccountNumber}",
          style: const TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 12,
            color: FinvuColors.grey81858F,
          ),
        ),
        trailing: SizedBox(
          width: 24,
          height: 24,
          child: Checkbox.adaptive(
            value: true,
            activeColor: FinvuColors.grey81858F,
            onChanged: (value) {},
          ),
        ),
      ),
    );
  }

  // void _goToAccountDataPage(final BuildContext context,
  //     final ConsentDetails activeSelfConsent, LinkedAccountInfo account) async {
  //   await Navigator.pushReplacement(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) =>
  //           AccountDataPage(consent: activeSelfConsent, account: account),
  //     ),
  //   );
  // }
}
