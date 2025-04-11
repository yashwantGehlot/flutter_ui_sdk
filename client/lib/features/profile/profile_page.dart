import 'package:finvu_flutter_sdk/common/utils/analytics_events.dart';
import 'package:finvu_flutter_sdk/common/utils/error_utils.dart';
import 'package:finvu_flutter_sdk/common/utils/finvu_colors.dart';
import 'package:finvu_flutter_sdk/common/widgets/base_page.dart';
import 'package:finvu_flutter_sdk/features/profile/bloc/profile_bloc.dart';
import 'package:finvu_flutter_sdk/features/profile/widgets/profile_header.dart';
import 'package:finvu_flutter_sdk/features/profile/widgets/profile_setting_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfilePage extends BasePage {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();

  @override
  String routeName() {
    return FinvuScreens.profilePage;
  }
}

class _ProfilePageState extends BasePageState<ProfilePage> {
  String _mobileNumber = "";
  String _userId = "";

  void _updateProfileDetails(ProfileState state) {
    setState(() {
      _mobileNumber = state.mobileNumber;
      _userId = state.userId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileBloc()..add(ProfileLoading()),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: FinvuColors.darkBlue,
          automaticallyImplyLeading: false,
          actions: [
            RawMaterialButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              elevation: 2.0,
              constraints: const BoxConstraints.tightFor(
                width: 28.0,
                height: 28.0,
              ),
              fillColor: Colors.white,
              shape: const CircleBorder(),
              child: const Icon(
                Icons.close_rounded,
                size: 12.0,
              ),
            ),
          ],
          title: Padding(
            padding: const EdgeInsets.only(left: 25),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                  color: Colors.white,
                ),
                AppLocalizations.of(context)!.profile,
              ),
            ),
          ),
          titleSpacing: 0,
          iconTheme: const IconThemeData(color: FinvuColors.blue),
        ),
        backgroundColor: FinvuColors.lightBlue,
        body: BlocConsumer<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state.status == ProfileStatus.profileFetched) {
              _updateProfileDetails(state);
            } else if (state.status == ProfileStatus.logoutComplete ||
                state.status == ProfileStatus.logoutError) {
              goToSplashScreen();
            } else if (state.status ==
                ProfileStatus.closeFinvuAccountCompleted) {
              goToSplashScreen();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    AppLocalizations.of(context)!.closeFinvuAccount,
                  ),
                ),
              );
            } else if (state.status == ProfileStatus.error) {
              if (ErrorUtils.hasSessionExpired(state.error)) {
                handleSessionExpired(context);
                return;
              }
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    ErrorUtils.getErrorMessage(
                      context,
                      state.error,
                    ),
                  ),
                ),
              );
            }
          },
          builder: (context, state) {
            return Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProfileHeader(mobileNumber: _mobileNumber, userId: _userId),
                  const ProfileSettingButtons(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
