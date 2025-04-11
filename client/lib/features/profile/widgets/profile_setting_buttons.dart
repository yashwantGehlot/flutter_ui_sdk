import 'package:finvu_flutter_sdk/common/models/finvu_error.dart';
import 'package:finvu_flutter_sdk/common/utils/error_utils.dart';
import 'package:finvu_flutter_sdk/features/auth/changePassword/change_password_page.dart';
import 'package:finvu_flutter_sdk/features/profile/bloc/profile_bloc.dart';
import 'package:finvu_flutter_sdk/features/language/change_language_dialog.dart';
import 'package:finvu_flutter_sdk/features/profile/widgets/close_finvu_account_password_dialog.dart';
import 'package:finvu_flutter_sdk/features/profile/widgets/confirm_finvu_account_close_dialog.dart';
import 'package:finvu_flutter_sdk/features/profile/widgets/profile_buttons.dart';
import 'package:finvu_flutter_sdk/features/profile/widgets/profile_disclaimer_banner.dart';
import 'package:finvu_flutter_sdk/features/profile/widgets/profile_loading_button.dart';
import 'package:finvu_flutter_sdk_core/finvu_exception.dart';
import 'package:finvu_flutter_sdk_internal/finvu_manager_internal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:finvu_flutter_sdk/common/utils/url_utils.dart';

class ProfileSettingButtons extends StatelessWidget {
  const ProfileSettingButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final Uri policiesUrl = Uri.parse('https://finvu.in/terms');
    final Uri contactSupportUrl = Uri.parse('https://finvu.in/helpdesk');
    final FinvuManagerInternal finvuManagerInternal = FinvuManagerInternal();

    return Expanded(
      child: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 21),
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    ProfileButton(
                      icon: Icons.content_paste_search_rounded,
                      text: AppLocalizations.of(context)!.policies,
                      onTap: () {
                        launch(policiesUrl);
                      },
                    ),
                    ProfileButton(
                      icon: Icons.language,
                      text: AppLocalizations.of(context)!.changeLanguage,
                      onTap: () {
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (_) => const ChangeLanguageDialog(),
                        );
                      },
                    ),
                    ProfileButton(
                      icon: Icons.headset_mic,
                      text: AppLocalizations.of(context)!.contactSupport,
                      onTap: () {
                        launch(contactSupportUrl);
                      },
                    ),
                    ProfileButton(
                      icon: Icons.lock,
                      text: AppLocalizations.of(context)!.changePin,
                      onTap: () {
                        _goToChangePasswordPage(context);
                      },
                    ),
                    ProfileButton(
                      icon: Icons.close,
                      text: AppLocalizations.of(context)!.closeAccount,
                      onTap: () {
                        _showCloseAccountConfirmationDialog(context);
                      },
                    ),
                    BlocBuilder<ProfileBloc, ProfileState>(
                      buildWhen: (previous, current) =>
                          previous.mobileNumber != current.mobileNumber,
                      builder: (context, state) {
                        return ProfileButton(
                          icon: Icons.logout,
                          text: AppLocalizations.of(context)!.logout,
                          onTap: () {
                            context.read<ProfileBloc>().add(LogoutInitiated());
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
              const ProfileDisclaimerBanner()
            ],
          ),
        ),
      ),
    );
  }

  void _goToChangePasswordPage(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ChangePasswordPage(),
      ),
    );
  }

  void _showCloseAccountConfirmationDialog(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return ConfirmFinvuAccountCloseDialog(
            onSubmit: () {
              _showPasswordDialog(context);
            },
          );
        });
  }

  void _showPasswordDialog(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return CloseFinvuAccountPasswordDialog(
            onSubmit: (passcode) {
              context
                  .read<ProfileBloc>()
                  .add(CloseFinvuAccountInitiated(passcode));
            },
          );
        });
  }
}
