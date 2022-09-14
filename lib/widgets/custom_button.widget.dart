import 'package:flutter/material.dart';

import '../config/styles.config.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    required this.onPressed,
    this.forLongPress = false,
    this.padding = const EdgeInsets.all(8),
    this.margin = const EdgeInsets.all(15),
    this.text = '',
    this.icon,
    this.color = Styles.mainColor,
    this.iconAfter = false,
  }) : super(key: key);

  final void Function() onPressed;
  final bool forLongPress;
  final String text;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final IconData? icon;
  final bool iconAfter;
  final Color color;

  @override
  Widget build(BuildContext context) {
    var textColor =
        color.computeLuminance() > 0.5 ? Colors.black : Colors.white;

    var iconWidget = Icon(icon, color: textColor);

    return Padding(
      padding: margin,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: color,
          padding: padding,
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
                style: Styles.mainText.copyWith(color: textColor),
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
