// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class CustomTextfield extends StatelessWidget {
  final String title;
  final bool autoFocus;
  final TextEditingController controller;
  final bool isPass;
  final int maxLines;
  final void Function(String)? onChanged;
  final bool showIcon;
  final IconData icon;
  final Widget suffix;

  const CustomTextfield({
    super.key,
    required this.title,
    this.autoFocus = true,
    required this.controller,
    this.isPass = false,
    this.maxLines = 1,
    this.onChanged,
    this.suffix = const SizedBox(),
    this.showIcon = false,
    this.icon = Icons.person,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isPass,
      maxLines: maxLines,
      onChanged: onChanged,
      autofocus: autoFocus,
      decoration: InputDecoration(
        icon: showIcon ? Icon(icon) : null,
        suffix: suffix,
        hintText: title,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(25),
          ),
        ),
      ),
      validator: (val) {
        if (val!.isEmpty) {
          return 'Please enter $title';
        }
        return null;
      },
    );
  }
}
