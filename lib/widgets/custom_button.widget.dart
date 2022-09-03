import 'package:flutter/material.dart';

import '../config/styles.config.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.padding = 15,
    this.margin = 20,
    this.icon,
    this.iconAfter = false,
  }) : super(key: key);

  final void Function() onPressed;
  final String text;
  final double padding;
  final double margin;
  final IconData? icon;
  final bool iconAfter;

  @override
  Widget build(BuildContext context) {
    var iconWidget = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Icon(icon),
    );

    return Padding(
      padding: EdgeInsets.all(margin),
      child: Row(
        children: [
          if ((icon == null) && !iconAfter) iconWidget,
          ElevatedButton(
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
          if ((icon == null) && iconAfter) iconWidget,
        ],
      ),
    );
  }
}
