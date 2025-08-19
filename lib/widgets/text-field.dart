import 'package:flutter/material.dart';

class TextFieldView extends StatefulWidget {
  final String text;
  final void Function(String value)? onTextChanged;
  final String? Function(String?)? validator;
  final String? title;
  final Widget? suffixIcon;

  const TextFieldView({
    super.key,
    required this.text,
    this.onTextChanged,
    this.validator,
    this.title,
    this.suffixIcon,
  });

  @override
  State<TextFieldView> createState() => _TextFieldViewState();
}

class _TextFieldViewState extends State<TextFieldView> {
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.value = TextEditingValue(text: widget.text);
  }

  @override
  void didUpdateWidget(TextFieldView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.text != controller.value.text) {
      controller.value = controller.value.copyWith(text: widget.text);
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: widget.onTextChanged,
      validator: widget.validator,
      autovalidateMode: AutovalidateMode.always,
      autocorrect: false,
      decoration: InputDecoration(
        labelText: widget.title,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: widget.suffixIcon,
      ),
    );
  }
}
