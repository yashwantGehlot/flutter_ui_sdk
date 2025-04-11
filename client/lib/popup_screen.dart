import 'dart:async';

import 'package:flutter/material.dart';

class PopupScreen extends StatelessWidget {
  final Completer<bool> _completer = Completer<bool>();

  Future<bool> show(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Popup Screen'),
          content: Text('This is a popup screen.'),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                _completer.complete(true);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
    return _completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
