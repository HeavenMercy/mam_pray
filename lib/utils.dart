import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mam_pray/config/values.config.dart';

abstract class Utils {
  static void showSnackbar(BuildContext context,
      {IconData? icon, required String msg, required AlertAction action}) {
    var snackbar = SnackBar(
      content: Row(children: [
        if (icon != null)
          Icon(
            icon,
            color: Colors.white,
          ),
        Flexible(
          child: Text(
            msg,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ]),
      action: SnackBarAction(
          label: action.label, onPressed: action.onPressed ?? () {}),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  static void showAlert(BuildContext context,
      {IconData? icon, required String msg, required AlertAction action}) {
    var alert = AlertDialog(
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (icon != null) Icon(icon),
          Text(Values.appName),
        ],
      ),
      content: Text(msg, maxLines: null, softWrap: true),
      actions: [
        TextButton(onPressed: action.onPressed, child: Text(action.label))
      ],
    );

    showDialog(context: context, builder: (context) => alert);
  }

  static bool isSameString(String str1, String str2) {
    return (str1.toLowerCase().compareTo(str2.toLowerCase()) == 0);
  }

  static Widget addFixedSpace(double space) {
    return Padding(padding: EdgeInsets.only(top: space));
  }

  static Widget addFlexibleSpace() {
    return Expanded(child: Container());
  }

  static const inviteMessages = [
    'What do you want to read today?',
    'Read to relive your faith!',
    'Are you looking for answer?',
    'Faith is everything!'
  ];

  static String getRandomsInvite() {
    var index = Random().nextInt(inviteMessages.length);
    return inviteMessages[index];
  }
}

class AlertAction {
  AlertAction({required this.label, this.onPressed});

  final String label;
  final VoidCallback? onPressed;
}

extension StringEnhanced on String {
  String toTitleCase() {
    var up = true;
    var chars = [];

    for (var c in split('')) {
      if (c == ' ') {
        up = true;
      } else if (up) {
        c = c.toUpperCase();
        up = false;
      }

      chars.add(c);
    }

    return chars.join();
  }
}
