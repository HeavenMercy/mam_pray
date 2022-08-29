import 'package:flutter/material.dart';

import '../config/styles.config.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.padding = 15,
    this.margin = 20,
  }) : super(key: key);

  final void Function() onPressed;
  final String text;
  final double padding;
  final double margin;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(margin),
      child: ElevatedButton(
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
        ),
      ),
    );
  }
}
