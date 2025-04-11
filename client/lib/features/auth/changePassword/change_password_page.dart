import 'package:finvu_flutter_sdk/common/utils/analytics_events.dart';
import 'package:finvu_flutter_sdk/common/utils/ui_utils.dart';
import 'package:finvu_flutter_sdk/common/widgets/base_page.dart';
import 'package:finvu_flutter_sdk/common/widgets/finvu_auth_header.dart';
import 'package:finvu_flutter_sdk/features/auth/changePassword/bloc/change_password_bloc.dart';
import 'package:finvu_flutter_sdk/features/auth/changePassword/views/change_password_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangePasswordPage extends BasePage {
  const ChangePasswordPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const ChangePasswordPage(),
    );
  }

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();

  @override
  String routeName() {
    return FinvuScreens.changePasswordPage;
  }
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UIUtils.getFinvuAppBackBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 25, right: 25),
          child: BlocProvider(
            create: (_) => ChangePasswordBloc(),
            child: const SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FinvuAuthHeader(),
                  ChangePasswordForm(),
                  Padding(padding: EdgeInsets.only(top: 30)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
