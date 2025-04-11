import 'package:finvu_flutter_sdk/common/utils/finvu_colors.dart';
import 'package:flutter/material.dart';

class FinvuPageHeader extends StatelessWidget {
  const FinvuPageHeader({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 108,
      child: DecoratedBox(
        decoration: const BoxDecoration(color: FinvuColors.darkBlue),
        child: Padding(
          padding: const EdgeInsets.only(left: 25),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Text(
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                  color: Colors.white,
                ),
                title,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
