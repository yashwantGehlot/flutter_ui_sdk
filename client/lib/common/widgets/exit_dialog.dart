import 'package:finvu_flutter_sdk/finvu_ui_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

Future<dynamic> exitDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Exit AA Journey"),
        content: Text(
          "Do you want to exit the journey?",
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: Colors.black),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("No"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text("Yes"),
          ),
        ],
      );
    },
  );
}
