import 'package:finvu_flutter_sdk/common/models/finvu_error.dart';
import 'package:finvu_flutter_sdk/common/utils/analytics_events.dart';
import 'package:finvu_flutter_sdk/common/utils/error_utils.dart';
import 'package:finvu_flutter_sdk/common/utils/ui_utils.dart';
import 'package:finvu_flutter_sdk/common/widgets/base_page.dart';
import 'package:finvu_flutter_sdk/common/widgets/finvu_auth_header.dart';
import 'package:finvu_flutter_sdk/features/auth/recovery/bloc/recovery_bloc.dart';
import 'package:finvu_flutter_sdk/features/auth/recovery/views/forgot_aa_handle_or_passcode_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecoveryPage extends BasePage {
  const RecoveryPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const RecoveryPage(),
    );
  }

  @override
  State<RecoveryPage> createState() => _RecoveryPageState();

  @override
  String routeName() {
    return FinvuScreens.recoveryPage;
  }
}

class _RecoveryPageState extends State<RecoveryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UIUtils.getFinvuAppBackBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 25, right: 25),
          child: BlocProvider(
            create: (_) => RecoveryBloc(),
            child: BlocListener<RecoveryBloc, RecoveryState>(
                listener: (context, state) {
                  if (state.status == RecoveryStatus.error) {
                    if (state.error?.code ==
                        FinvuErrorCode.sslPinningFailureError) {
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
                  }
                },
                child: const SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FinvuAuthHeader(),
                      ForgotAaHandleOrPasscodeForm(),
                      Padding(padding: EdgeInsets.only(top: 30)),
                    ],
                  ),
                )),
          ),
        ),
      ),
    );
  }
}
