import 'package:flutter/material.dart';

import '../config/styles.config.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.padding = 15,
  }) : super(key: key);

  final void Function() onPressed;
  final String text;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Styles.mainColor,
          padding: EdgeInsets.all(padding),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: Styles.mainText.copyWith(
            color: Styles.bgColor,
          ),
        ));
  }
}
