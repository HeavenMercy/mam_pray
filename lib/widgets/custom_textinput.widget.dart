import 'package:flutter/material.dart';
import 'package:mam_pray/config/styles.config.dart';

class CustomTextInput extends StatelessWidget {
  const CustomTextInput({
    Key? key,
    required this.hintText,
    required this.onChanged,
    this.prefixIcon,
    this.initialText = '',
    this.padding = const EdgeInsets.all(10),
  }) : super(key: key);

  final String initialText;
  final String hintText;
  final Widget? prefixIcon;
  final EdgeInsets padding;
  final void Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    var textCtrl = TextEditingController();
    if (initialText.isNotEmpty) textCtrl.text = initialText;

    return TextField(
      controller: (initialText.isNotEmpty ? textCtrl : null),
      onChanged: onChanged,
      decoration: InputDecoration(
        contentPadding: padding,
        hintText: hintText,
        filled: true,
        prefixIcon: prefixIcon,
        fillColor: Styles.secColor,
        focusColor: Styles.mainColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }
}
