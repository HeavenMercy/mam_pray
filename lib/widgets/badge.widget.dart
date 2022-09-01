import 'package:flutter/material.dart';
import 'package:mam_pray/config/styles.config.dart';

class Badge extends StatelessWidget {
  const Badge({
    Key? key,
    this.icon,
    this.color = Styles.secColor,
    required this.text,
  }) : super(key: key);

  final IconData? icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Styles.bgColor,
        borderRadius: BorderRadius.circular(3),
      ),
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Row(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Text(
              text,
              style: Styles.subText.copyWith(color: color),
            ),
          ),
          Icon(icon, color: color),
        ]),
      ),
    );
  }
}
