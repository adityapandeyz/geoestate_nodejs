import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geoestate/constants/error_handling.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../Models/dataset.dart';
import '../Models/my_marker.dart';
import '../provider/auth_provider.dart';

class DatasetServices {
  static Future<List<Dataset>> getAllDatasets() async {
    try {
      final response = await Dio().get(
        'http://localhost:3000/api/datasets',
      );

      if (response.statusCode == 201) {
        final responseData = response.data as List<dynamic>;

        List<Dataset> datasets = responseData.map((e) {
          final refNo = e['refNo'] as String;
          final bankName = e['bankName'] as String;
          final branchName = e['branchName'] as String;
          final partyName = e['partyName'] as String;
          final colonyName = e['colonyName'] as String;
          final cityVillageName = e['cityVillageName'] as String;
          final latitude = e['latitude'] as double;
          final longitude = e['longitude'] as double;
          final marketRate = e['marketRate'] as int;
          final unit = e['unit'] as String;

          final createdAtString = e['createdAt'] as String;
          final remarks = e['remarks'] as String;
          final colorMark = e['colorMark'] as String;
          final dateOfVisitString = e['dateOfVisit'] as String;
          final id = e['id'] as int;

          final createdAt = DateTime.parse(createdAtString);
          final dateOfVisit = DateTime.parse(dateOfVisitString);

          return Dataset(
            refNo: refNo,
            bankName: bankName,
            branchName: branchName,
            partyName: partyName,
            colonyName: colonyName,
            cityVillageName: cityVillageName,
            latitude: latitude,
            longitude: longitude,
            marketRate: marketRate,
            unit: unit,
            createdAt: createdAt,
            remarks: remarks,
            colorMark: colorMark,
            dateOfVisit: dateOfVisit,
            id: id,
          );
        }).toList();

        return datasets;
      } else {
        throw Exception('Error fetching data from the database.');
      }
    } catch (e) {
      throw Exception('Error connecting to server - $e');
    }
  }

  static Future<dynamic> createDataset(Dataset dataset) async {
    try {
      final response = await Dio().post(
        'http://localhost:3000/api/create-dataset',
        data: dataset.toJson(),
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
      throw Exception('Error connecting to server - $e');
    }
  }
}
