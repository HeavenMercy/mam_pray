import 'package:flutter/material.dart';
import 'package:mam_pray/config/styles.config.dart';

class Pageheader extends StatelessWidget {
  const Pageheader({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(10.0),
      decoration: const BoxDecoration(
        color: Styles.secColor,
        boxShadow: [
          BoxShadow(color: Styles.mainColor, offset: Offset(0, 5)),
          BoxShadow(color: Styles.bgColor, offset: Offset(0, 3.5)),
        ],
      ),
      child: child,
    );
  }
}
