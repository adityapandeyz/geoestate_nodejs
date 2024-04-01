import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geoestate/Models/my_marker.dart';
import 'package:geoestate/constants/global_variables.dart';
import 'package:http/http.dart' as http;

void main() {
  testWidgets('MyWidget test', (WidgetTester tester) async {
    // Pump the widget

    // Fetch data from the API
    final response = await fetchMarkers();

    // Verify that the widget displays the data correctly
    // ...
  });
}

Future<List<Marker>> fetchMarkers() async {
  final response = await Dio().get(
    '${ApiEndpoints.baseUrl}${ApiEndpoints.markerEndpoint}',
    options: Options(
      headers: {'Content-Type': 'application/json'},
    ),
  );

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.data);
    return jsonResponse.map((marker) => Marker.fromJson(marker)).toList();
  } else {
    throw Exception('Failed to load markers');
  }
}
