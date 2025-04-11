import 'package:finvu_flutter_sdk/common/utils/analytics_events.dart';
import 'package:finvu_flutter_sdk/common/widgets/base_page.dart';
import 'package:finvu_flutter_sdk/common/widgets/finvu_auth_header.dart';
import 'package:finvu_flutter_sdk/features/auth/registration/bloc/registration_bloc.dart';
import 'package:finvu_flutter_sdk/features/auth/registration/views/registration_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegistrationPage extends BasePage {
  const RegistrationPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const RegistrationPage(),
    );
  }

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();

  @override
  String routeName() {
    return FinvuScreens.registrationPage;
  }
}

class _RegistrationPageState extends State<RegistrationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 25, right: 25),
          child: BlocProvider(
            create: (_) => RegistrationBloc(),
            child: const SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FinvuAuthHeader(),
                  RegistrationForm(),
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
