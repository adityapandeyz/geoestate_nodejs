import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geoestate/constants/error_handling.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../Models/my_marker.dart';
import '../constants/utils.dart';
import '../provider/auth_provider.dart';

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
            createdAt: createdAt.toIso8601String(),
          );
        }).toList();

        return markers;
      } else {
        throw Exception('Error fetching data from the database.');
      }
    } catch (e) {
      throw Exception('Error connecting to server - $e');
    }
  }

  // static Future<dynamic> createMarker({
  //   required BuildContext context,
  //   required Marker marker,
  // }) async {
  //   try {
  //     final userProvider = Provider.of<AuthProvider>(context, listen: false);

  //     final http.Response response = await http.post(
  //         Uri.parse('http://localhost:3000/api/create-marker'),
  //         body: marker.toJson(),
  //         headers: {
  //           'Content-Type': 'application/json; charset=UTF-8',
  //           'x-auth-token': userProvider.user.token,
  //         });

  //     httpErrorHandle(
  //       response: response,
  //       context: context,
  //       onSuccess: () {
  //         showAlert(context, 'Marker created successfully!');
  //       },
  //     );
  //   } catch (e) {
  //     print(e);
  //     throw Exception('Error connecting to server - $e');
  //   }
  // }

  static Future<dynamic> createMarker(Marker marker) async {
    try {
      final Response response = await Dio().post(
        'http://localhost:3000/api/create-marker',
        data: marker.toJson(),
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 201) {
        return response.data;
      } else {
        throw Exception('Error writing data to database.');
      }
    } catch (e) {
      print(e);
      throw Exception('Error connecting to server - $e');
    }
  }

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
      throw Exception('Error connecting to server - $e');
    }
  }
}
