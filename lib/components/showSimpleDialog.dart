import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<void> showSimpleDialog(context, String msg) async {
  await showDialog(
      context: context,
      builder: (childContext) {
        return SimpleDialog(
          title: Text(msg),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context);
              },
              child:
                  Text("yes".tr, style: const TextStyle(), textAlign: TextAlign.end),
            ),
          ],
        );
      });
}
