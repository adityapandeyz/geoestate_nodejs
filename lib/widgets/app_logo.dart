import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppLogo extends StatelessWidget {
  final double size;
  final Color color;
  const AppLogo({
    super.key,
    this.size = 26,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'GeoEstate',
        style: GoogleFonts.bubblegumSans(
          textStyle: Theme.of(context).textTheme.displayLarge,
          fontSize: size,
          color: color,
          fontWeight: FontWeight.w700,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}
