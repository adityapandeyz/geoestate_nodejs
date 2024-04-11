import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import '../Models/my_marker.dart';

class MarkerServices {
  static Future<List<Marker>> getAllMarkers() async {
    try {
      final Response response = await Dio().get(
        'http://localhost:3000/api/markers',
      );

      if (response.statusCode == 201) {
        final responseData = response.data as List<dynamic>;

        List<Marker> markers = responseData.map((e) {
          final id = e['id'] as int;
          final latitude = e['latitude'] as double;
          final longitude = e['longitude'] as double;
          final marketRate = e['marketRate'] as int;
          final unit = e['unit'] as String;
          final color = e['color'] as String;
          final createdAt = DateTime.parse(e['createdAt'] as String);

          return Marker(
            id: id,
            latitude: latitude,
            longitude: longitude,
            marketRate: marketRate,
            unit: unit,
            color: color,
            createdAt: createdAt,
          );
        }).toList();

        return markers;
      } else {
        throw Exception('Error fetching data from the database.');
      }
    } catch (e) {
      print('Error connecting to server - $e');
    }
    return [];
  }

  static Future<dynamic> createMarker({
    required BuildContext context,
    required Marker marker,
  }) async {
    try {
      // final userProvider = Provider.of<AuthProvider>(context, listen: false);

      final http.Response response =
          await http.post(Uri.parse('http://localhost:3000/api/create-marker'),
              body: jsonEncode({
                'latitude': marker.latitude,
                'longitude': marker.longitude,
                'marketRate': 0,
                'unit': 'SQFT',
                'color': marker.color.toString(),
                'createdAt': marker.createdAt.toIso8601String(),
              }),
              headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            // 'x-auth-token': userProvider.user.token,
          });

      // print('step 7');

      // httpErrorHandle(
      //   response: response,
      //   context: context,
      //   onSuccess: () {
      //     showAlert(context, 'Marker created successfully!');
      //   },
      // );

      if (response.statusCode == 201) {
        return response;
      } else {
        throw Exception('Error writing data to database.');
      }
    } catch (e) {
      throw Exception('Error connecting to server - $e');
    }
  }

  // static Future<dynamic> createMarker(Marker marker) async {
  //   try {
  //     final Response response = await Dio().post(
  //       'http://localhost:3000/api/create-marker',
  //       data: marker.toJson(),
  //       options: Options(
  //         headers: {'Content-Type': 'application/json; charset=UTF-8'},
  //       ),
  //     );

  //     if (response.statusCode == 201) {
  //       return response.data;
  //     } else {
  //       throw Exception('Error writing data to database.');
  //     }
  //   } catch (e) {
  //     print(e);
  //     throw Exception('Error connecting to server - $e');
  //   }
  // }

  static Future<dynamic> deleteMarkers(int id) async {
    try {
      final response = await Dio().delete(
        'http://localhost:3000/api/delete-marker/$id',
        data: jsonEncode(
          {
            'id': id,
          },
        ),
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 201) {
        return response;
      } else {
        throw Exception('Error fetching data from the database.');
      }
    } catch (e) {
      print('Error connecting to server - $e');
    }
  }

  static Future<dynamic> updateRateInMarker({
    required int id,
    required int marketRate,
    required String unit,
  }) async {
    try {
      // final userProvider = Provider.of<AuthProvider>(context, listen: false);

      final http.Response response = await http
          .put(Uri.parse('http://localhost:3000/api/update-rate-marker'),
              body: jsonEncode({
                'id': id,
                'marketRate': marketRate,
                'unit': unit,
              }),
              headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            // 'x-auth-token': userProvider.user.token,
          });

      // httpErrorHandle(
      //   response: response,
      //   context: context,
      //   onSuccess: () {
      //     showAlert(context, 'Rate updated successfully!');
      //   },
      // );

      if (response.statusCode == 201) {
        return response;
      } else {
        throw Exception('Error fetching data from the database.');
      }
    } catch (e) {
      print(e);
    }
  }

  static Future<dynamic> updateColorInMarker({
    // required BuildContext context,
    required int id,
    required String color,
  }) async {
    try {
      // final userProvider = Provider.of<AuthProvider>(context, listen: false);

      final http.Response response = await http
          .put(Uri.parse('http://localhost:3000/api/update-color-marker'),
              body: jsonEncode({
                'id': id,
                'color': color,
              }),
              headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            // 'x-auth-token': userProvider.user.token,
          });

      // httpErrorHandle(
      //   response: response,
      //   context: context,
      //   onSuccess: () {
      //     showAlert(context, 'Color updated successfully!');
      //   },
      // );
      if (response.statusCode == 201) {
        return response;
      } else {
        throw Exception('Error fetching data from the database.');
      }
    } catch (e) {
      print(e);
    }
  }
}
