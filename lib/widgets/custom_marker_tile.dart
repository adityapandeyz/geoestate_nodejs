import 'package:flutter/material.dart';

class CustomMarkerTile extends StatelessWidget {
  final VoidCallback updateCameraPosition;
  final double latitude;
  final double longitude;
  final int marketRate;
  final String unit;
  final VoidCallback addPrice;
  final VoidCallback removeExistingMarker;

  const CustomMarkerTile({
    super.key,
    required this.updateCameraPosition,
    required this.latitude,
    required this.longitude,
    required this.marketRate,
    required this.unit,
    required this.addPrice,
    required this.removeExistingMarker,
  });

  Widget _buildLocationDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLocationRow('Lat', '$latitude °N'),
        _buildLocationRow('Lng', '$longitude °E'),
      ],
    );
  }

  Widget _buildLocationRow(String label, String value) {
    return Column(
      children: [
        Text(
          '$label: ',
          style: const TextStyle(
            color: Color.fromARGB(106, 27, 26, 25),
            fontSize: 13,
          ),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 15),
        ),
      ],
    );
  }

  Widget _buildMarketRate() {
    return marketRate.toString().isEmpty
        ? TextButton(
            onPressed: addPrice,
            child: const Text('Add Rate'),
          )
        : Row(
            children: [
              const Text(
                '₹ ',
                style: TextStyle(color: Colors.green, fontSize: 13),
              ),
              Text(
                '$marketRate',
                style: const TextStyle(color: Colors.green, fontSize: 18),
              ),
              const SizedBox(width: 5),
              Text(
                unit,
                style: const TextStyle(color: Colors.green, fontSize: 14),
              ),
            ],
          );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            ListTile(
              leading: IconButton(
                onPressed: updateCameraPosition,
                icon: const Icon(
                  Icons.location_on,
                  size: 20,
                ),
              ),
              title: Column(
                children: [
                  _buildLocationDetails(),
                  _buildMarketRate(),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  child: const Text('Creat Dataset'),
                  onPressed: () {
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (_) => SelectBankPage(
                    //       lat: latitude.toDouble(),
                    //       lng: longitude.toDouble(),
                    //       dateTime: DateTime.now(),
                    //       marketRate: marketRate.toInt(),
                    //       unit: unit.toString(),
                    //     ),
                    //   ),
                    // );
                  },
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: removeExistingMarker,
                  child: const Text(
                    'Remove',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
