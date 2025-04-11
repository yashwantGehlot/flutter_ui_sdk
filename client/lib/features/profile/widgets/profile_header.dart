import 'package:finvu_flutter_sdk/common/utils/finvu_colors.dart';
import 'package:finvu_flutter_sdk/common/utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    required String mobileNumber,
    required String userId,
  })  : _mobileNumber = mobileNumber,
        _userId = userId;

  final String _mobileNumber;
  final String _userId;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 120,
      child: Container(
        decoration: const BoxDecoration(
            color: FinvuColors.darkBlue,
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20))),
        padding: const EdgeInsets.all(25.0),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: CircleAvatar(
                  backgroundColor: Colors.grey,
                  radius: 30,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.person),
                    color: Colors.white,
                    iconSize: 35,
                    onPressed: () {},
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                          _mobileNumber,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Colors.white,
                          ),
                          _userId,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: GestureDetector(
                            onTap: () {
                              if (_userId.isNotEmpty) {
                                UIUtils.copyToClipboard(_userId);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      AppLocalizations.of(context)!
                                          .copiedToClipboard,
                                    ),
                                  ),
                                );
                              }
                            },
                            child: const Icon(
                              Icons.copy,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
