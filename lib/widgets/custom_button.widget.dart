import 'package:flutter/material.dart';

import '../config/styles.config.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    required this.onPressed,
    this.forLongPress = false,
    this.padding = 15,
    this.margin = 20,
    this.text = '',
    this.icon,
    this.iconAfter = false,
  }) : super(key: key);

  final void Function() onPressed;
  final bool forLongPress;
  final String text;
  final double padding;
  final double margin;
  final IconData? icon;
  final bool iconAfter;

  @override
  Widget build(BuildContext context) {
    var iconWidget = Icon(
      icon,
      color: Styles.bgColor,
    );

    return Padding(
      padding: EdgeInsets.all(margin),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Styles.mainColor,
          padding: EdgeInsets.all(padding),
        ),
        onLongPress: (forLongPress ? onPressed : null),
        onPressed: (!forLongPress ? onPressed : null),
        child: Row(
          children: [
            if ((icon != null) && !iconAfter)
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: iconWidget,
              ),
            if (text.isNotEmpty)
              Text(
                text,
                style: Styles.mainText.copyWith(
                  color: Styles.bgColor,
                ),
              ),
            if ((icon != null) && iconAfter)
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: iconWidget,
              ),
          ],
        ),
      ),
    );
  }
}
