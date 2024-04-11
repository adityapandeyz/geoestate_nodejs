import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onClick;
  final bool isLoading;
  const CustomButton({
    super.key,
    required this.text,
    required this.onClick,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return ElevatedButton(
          onPressed: onClick,
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            minimumSize: Size(constraints.maxWidth, 50),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            textStyle: const TextStyle(fontSize: 14),
          ),
          child: isLoading == false
              ? Text(text)
              : const CircularProgressIndicator(),
        );
      },
    );
  }
}
