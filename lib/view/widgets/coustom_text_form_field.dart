import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool isPassword;
  final bool isNumber;
  final String? hintText;
  final TextInputAction? textInputAction;
  final Function(String)? onFieldSubmitted;

  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.labelText,
    this.isPassword = false,
    this.isNumber = false,
    this.hintText,
    this.textInputAction = TextInputAction.next,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
        hintText: hintText,
      ),
      obscureText: isPassword,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted ?? (_) => FocusScope.of(context).nextFocus(),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $labelText';
        }
        if (isNumber && !RegExp(r'^[0-9]+$').hasMatch(value)) {
          return 'Please enter numbers only';
        }
        return null;
      },
    );
  }
}
