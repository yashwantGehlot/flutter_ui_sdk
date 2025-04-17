import 'package:finvu_flutter_sdk/features/account_linking/bloc/account_linking_bloc.dart';
import 'package:finvu_flutter_sdk/features/account_linking/widgets/add_new_mobile_number_dialog.dart';
import 'package:finvu_flutter_sdk/features/account_linking/widgets/mobile_verification_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finvu_flutter_sdk/l10n/app_localizations.dart';

class MobileNumberSelection extends StatelessWidget {
  const MobileNumberSelection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountLinkingBloc, AccountLinkingState>(
      builder: (context, state) {
        if (state.status == AccountLinkingStatus.isInitializing ||
            state.status == AccountLinkingStatus.unknown) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildSelectMobileNumberHeader(context),
            const Padding(padding: EdgeInsets.only(top: 15)),
            const _MobileNumberSelectionWidget(),
          ],
        );
      },
    );
  }

  Widget _buildSelectMobileNumberHeader(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        style: const TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 16,
          color: Colors.black,
        ),
        AppLocalizations.of(context)!.selectMobileNumber,
      ),
    );
  }
}

class _MobileNumberSelectionWidget extends StatefulWidget {
  const _MobileNumberSelectionWidget();

  @override
  State<_MobileNumberSelectionWidget> createState() =>
      _MobileNumberSelectionWidgetState();
}

class _MobileNumberSelectionWidgetState
    extends State<_MobileNumberSelectionWidget> {
  String? _selectedMobileNumber;
  List<String>? allMobileNumers;

  @override
  void initState() {
    super.initState();
    allMobileNumers = context.read<AccountLinkingBloc>().state.mobileNumbers;
    // allMobileNumbers could be empty if session disconnects, so handle that case, pick the first number if list has any, otherwise null
    _selectedMobileNumber = allMobileNumers?.firstOrNull;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AccountLinkingBloc, AccountLinkingState>(
      builder: (context, state) {
        return Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Wrap(
                children: buildRadioButtons(context),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                style: TextButton.styleFrom(
                  textStyle: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 12),
                ),
                onPressed: () {
                  _showAddMobileNumberDialog(context);
                },
                child: Text(AppLocalizations.of(context)!.addNewMobileNumber),
              ),
            ),
          ],
        );
      },
      listener: (BuildContext context, AccountLinkingState state) {
        if (state.status == AccountLinkingStatus.mobileVerificationOtpSent) {
          _showMobileVerificationDialog(context, state.newMobileNumber);
        }
        if (state.status == AccountLinkingStatus.mobileVerificatioOtpVerified) {
          Navigator.pop(context);
          setState(() {
            allMobileNumers = state.mobileNumbers;
          });

          selectMobileNumber(context, state.newMobileNumber);
        }
      },
    );
  }

  void _showMobileVerificationDialog(
      BuildContext context, String newMobileNumber) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) {
        return BlocProvider.value(
          value: context.read<AccountLinkingBloc>(),
          child: MobileVerificatioDialog(
            newMobileNumber: newMobileNumber,
          ),
        );
      },
    );
  }

  void _showAddMobileNumberDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) {
        return BlocProvider.value(
          value: context.read<AccountLinkingBloc>(),
          child: AddNewMobileNumberDialog(
            onDialogButtonPressed: (mobileNumber) {
              addMobileNumber(context, mobileNumber);
            },
            subtitle: AppLocalizations.of(context)!.pleaseEnterMobileNumber,
          ),
        );
      },
    );
  }

  List<Widget> buildRadioButtons(BuildContext context) {
    List<Widget> allRadioButtons = [];
    for (String mobileNumber
        in context.read<AccountLinkingBloc>().state.mobileNumbers) {
      allRadioButtons.add(_buildRadioButtonWidget(context, mobileNumber));
    }
    return allRadioButtons;
  }

  Widget _buildRadioButtonWidget(
    BuildContext context,
    String mobileNumber,
  ) {
    return InkWell(
      onTap: () {
        selectMobileNumber(context, mobileNumber);
      },
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Radio<String>(
            visualDensity: VisualDensity.compact,
            groupValue: _selectedMobileNumber,
            value: mobileNumber,
            onChanged: (String? newValue) {
              selectMobileNumber(context, newValue!);
            },
          ),
          Text(
            mobileNumber,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
          )
        ],
      ),
    );
  }

  void selectMobileNumber(BuildContext context, String mobileNumber) {
    context
        .read<AccountLinkingBloc>()
        .add(AccountLinkingMobileNumberSelected(mobileNumber));
    setState(() {
      _selectedMobileNumber = mobileNumber;
    });
  }

  void addMobileNumber(BuildContext context, String newMobileNumber) {
    context
        .read<AccountLinkingBloc>()
        .add(AccountLinkingMobileNumberAdded(newMobileNumber));
  }
}
