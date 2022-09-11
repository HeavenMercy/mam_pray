import 'package:flutter/material.dart';
import 'package:mam_pray/config/styles.config.dart';

typedef OnBadgeDeleteFunction = void Function();

class Badge extends StatelessWidget {
  const Badge({
    Key? key,
    this.icon,
    this.iconAfter = true,
    this.color = Styles.secColor,
    this.onDelete,
    required this.text,
  }) : super(key: key);

  final IconData? icon;
  final bool iconAfter;
  final String text;
  final Color color;
  final OnBadgeDeleteFunction? onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Styles.bgColor,
        borderRadius: BorderRadius.circular(3),
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if ((icon != null) && !iconAfter) Icon(icon, color: color),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Text(
                text,
                style: Styles.subText.copyWith(color: color),
              ),
            ),
            if ((icon != null) && iconAfter) Icon(icon, color: color),
            if (onDelete != null)
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: GestureDetector(
                  onTap: onDelete,
                  child: Icon(Icons.close, color: color),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
