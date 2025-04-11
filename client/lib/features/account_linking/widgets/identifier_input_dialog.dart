import 'package:finvu_flutter_sdk/common/widgets/finvu_dialog.dart';
import 'package:finvu_flutter_sdk/features/account_linking/bloc/account_linking_bloc.dart';
import 'package:finvu_flutter_sdk/features/account_linking/models/identifier.dart';
import 'package:finvu_flutter_sdk/features/account_linking/widgets/dob_input.dart';
import 'package:finvu_flutter_sdk/features/account_linking/widgets/identifier_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class IdentifierInputDialog extends StatelessWidget {
  IdentifierInputDialog({
    super.key,
    required this.identifier,
  });

  final Identifier identifier;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountLinkingBloc, AccountLinkingState>(
        builder: (context, state) {
      return FinvuDialog(
        title: AppLocalizations.of(context)!.verifyYourDetails,
        subtitle: [
          TextSpan(
            text: AppLocalizations.of(context)!
                .pleaseEnterIdentifierToGetDetails(identifier.type),
          ),
        ],
        content: Form(
          key: _formKey,
          child: _getIdentifierInput(context),
        ),
        buttonText: AppLocalizations.of(context)!.submit,
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            Navigator.of(context).pop();
            context.read<AccountLinkingBloc>().add(
                  AccountLinkingAdditionalIdentifierSubmitted(
                    identifier.type,
                  ),
                );
          }
        },
      );
    });
  }

  Widget _getIdentifierInput(BuildContext context) {
    onChanged(value) {
      context.read<AccountLinkingBloc>().add(
            AccountLinkingAdditionalIdentifierChanged(
              identifier.withValue(value),
            ),
          );
    }

    switch (identifier.type.toUpperCase()) {
      case "DOB":
        return DoBInput(onChanged: onChanged);

      default:
        return IdentifierInput(
          identifierType: identifier.type,
          onChanged: onChanged,
        );
    }
  }
}
