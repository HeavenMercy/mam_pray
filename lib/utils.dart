import 'dart:math';

import 'package:flutter/material.dart';

abstract class Utils {
  static void showSnackBar(BuildContext context,
      {IconData? icon, required String msg, SnackBarAction? action}) {
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
      action: action,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackbar);
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
