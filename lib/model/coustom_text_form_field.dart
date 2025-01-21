import 'package:flutter/material.dart';

class TextFormFieldConfig {
  final String labelText;
  final bool isPassword;
  final bool isNumber;
  final String? hintText;
  final TextInputAction? textInputAction;

  TextFormFieldConfig({
    required this.labelText,
    this.isPassword = false,
    this.isNumber = false,
    this.hintText,
    this.textInputAction = TextInputAction.next,
  });
}