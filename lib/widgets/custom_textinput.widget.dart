import 'package:flutter/material.dart';
import 'package:mam_pray/config/styles.config.dart';

enum CustomTextInputType { none, number, text }

class CustomTextInput extends StatefulWidget {
  const CustomTextInput({
    Key? key,
    required this.hintText,
    required this.onChanged,
    this.canClear = false,
    this.type = CustomTextInputType.none,
    this.prefixIcon,
    this.initialText = '',
    this.textAlign = TextAlign.left,
    this.padding = const EdgeInsets.all(10),
  }) : super(key: key);

  final String initialText;
  final String hintText;
  final Widget? prefixIcon;
  final EdgeInsets padding;
  final bool canClear;
  final TextAlign textAlign;
  final CustomTextInputType type;
  final void Function(String) onChanged;

  @override
  State<CustomTextInput> createState() => _CustomTextInputState();
}

class _CustomTextInputState extends State<CustomTextInput> {
  var textCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (widget.initialText.isNotEmpty) textCtrl.text = widget.initialText;

    var type = TextInputType.name;
    if (widget.type == CustomTextInputType.number) {
      type = TextInputType.number;
    } else if (widget.type == CustomTextInputType.text) {
      type = TextInputType.multiline;
    }

    return TextField(
      maxLines: (widget.type == CustomTextInputType.text ? null : 1),
      keyboardType: type,
      textAlign: widget.textAlign,
      style: Styles.mainText.copyWith(
        fontWeight: FontWeight.normal,
        color: Colors.black,
      ),
      controller: textCtrl,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        contentPadding: widget.padding,
        hintText: widget.hintText,
        filled: true,
        prefixIcon: widget.prefixIcon,
        suffixIcon: (widget.canClear && textCtrl.text.isNotEmpty
            ? IconButton(
                onPressed: () {
                  textCtrl.text = '';
                  widget.onChanged.call('');
                },
                icon: const Icon(Icons.clear),
              )
            : null),
        fillColor: Styles.secColor,
        border: (widget.type == CustomTextInputType.text
            ? const OutlineInputBorder(borderSide: BorderSide.none)
            : OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              )),
      ),
    );
  }
}
