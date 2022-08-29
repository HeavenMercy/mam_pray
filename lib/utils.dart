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
        Text(
          msg,
          style: const TextStyle(color: Colors.white),
        ),
      ]),
      action: action,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  static bool isSameString(String str1, String str2) {
    return (str1.toLowerCase().compareTo(str2.toLowerCase()) == 0);
  }
}
