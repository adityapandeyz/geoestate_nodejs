import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomIconButton extends StatelessWidget {
  final IconData icon;
  final bool isLoading;
  final String text;
  final VoidCallback ontap;
  const CustomIconButton({
    super.key,
    required this.icon,
    required this.ontap,
    required this.text,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(
          double.infinity,
          50,
        ),
      ),
      onPressed: ontap,
      icon: isLoading == false
          ? FaIcon(
              icon,
            )
          : const CircularProgressIndicator(),
      label: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 18,
        ),
      ),
    );
  }
}
