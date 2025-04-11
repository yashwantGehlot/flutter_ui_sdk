import 'package:finvu_flutter_sdk/common/utils/finvu_colors.dart';
import 'package:finvu_flutter_sdk/common/widgets/finvu_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AAHandlesListDialog extends StatelessWidget {
  const AAHandlesListDialog(
      {super.key,
      required this.list,
      required this.onOkay,
      required this.mobileNumber});

  final List<String> list;
  final Function() onOkay;
  final String mobileNumber;
  @override
  Widget build(BuildContext context) {
    return FinvuDialog(
      title: AppLocalizations.of(context)!.foundAaHandle,
      subtitle: [
        TextSpan(
          text: AppLocalizations.of(context)!.weHaveFoundFollowingAaHandles,
        ),
        TextSpan(
          text: mobileNumber,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: FinvuColors.black111111,
          ),
        ),
      ],
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: SizedBox(
              height: list.length > 3 ? 200 : list.length * 80.0,
              child: Scrollbar(
                thumbVisibility: true,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        list[index],
                      ),
                    );
                  },
                ),
              ),
            ),
          )
        ],
      ),
      buttonText: AppLocalizations.of(context)!.okay,
      onPressed: () {
        onOkay();
      },
    );
  }
}
