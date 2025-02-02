import 'package:flutter/material.dart';
import 'package:lucky_depot/model/coustom_text_form_field.dart';

class CustomTextFormFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final TextFormFieldConfig config;
  final FocusNode? focusNode;
  final ValueChanged<String>? onFieldSubmitted;

  const CustomTextFormFieldWidget({
    super.key,
    required this.controller,
    required this.config,
    this.focusNode,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      decoration: InputDecoration(
        labelText: config.labelText,
        border: const OutlineInputBorder(),
        hintText: config.hintText,
      ),
      obscureText: config.isPassword,
      keyboardType: config.isNumber ? TextInputType.number : TextInputType.text,
      textInputAction: config.textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter ${config.labelText}';
        }
        if (config.isNumber && !RegExp(r'^[0-9]+$').hasMatch(value)) {
          return 'Please enter numbers only';
        }
        return null;
      },
    );
  }
}
