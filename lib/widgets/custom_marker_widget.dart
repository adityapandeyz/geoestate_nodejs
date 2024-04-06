import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../pages/dateset_page.dart';

class CustomMarkerWidget extends StatelessWidget {
  final int price;
  final double lat;
  final double lng;
  final String color;
  final String unit;

  const CustomMarkerWidget({
    super.key,
    required this.price,
    required this.lat,
    required this.lng,
    this.color = 'black',
    required this.unit,
  });

  Color getColorFromString(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'red':
        return Colors.red;
      case 'blue':
        return Colors.blue;
      case 'green':
        return Colors.green;
      case 'black':
        return Colors.black;
      case 'purple':
        return Colors.purple;
      case 'indigo':
        return Colors.indigo;
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => DatasetPage(
              latitude: lat,
              longitude: lng,
            ),
          ),
        );
      },
      child: SizedBox(
        height: 120,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Icon(
                FontAwesomeIcons.caretDown,
                color: getColorFromString(
                    '$color'), // Use the getColorFromString method
                size: 60,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: getColorFromString(color),
                borderRadius: BorderRadius.circular(10), // Added border radius
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "₹$price",
                      style: const TextStyle(
                        fontSize: 18, // Increased font size for price
                        color: Colors.white,
                      ),
                      softWrap: true,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(width: 8), // Increased width for spacing
                    unit.isNotEmpty
                        ? Text(
                            unit,
                            style: const TextStyle(
                              fontSize: 16, // Increased font size for unit
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
