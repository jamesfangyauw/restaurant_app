import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'navigation.dart';

customDialog(BuildContext context) {
  if (Platform.isIOS) {
    showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text('To Be Announced'),
          content: Text('This feature now is not avaible, the releasse version will soon announce '),
          actions: [
            CupertinoDialogAction(
              child: Text('Okay'),
              onPressed: () {
                Navigation.back();
              },
            ),
          ],
        );
      },
    );
  } else {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('To Be Announce'),
          content: Text('This feature no is not avaible, the rellease version will soon announce'),
          actions: [
            TextButton(
              onPressed: () {
                Navigation.back();
              },
              child: Text('Okay'),
            ),
          ],
        );
      },
    );
  }
}