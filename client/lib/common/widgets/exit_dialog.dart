import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

Future<dynamic> exitDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Exit AA Journey"),
        content: const Text("Do you want to exit the journey?"),
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
