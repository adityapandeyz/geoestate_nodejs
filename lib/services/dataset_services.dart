import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geoestate/constants/error_handling.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../Models/dataset.dart';
import '../constants/utils.dart';
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
          final remarks = e['remarks'].toString();
          final colorMark = e['colorMark'] as String;
          final dateOfVisitString = e['dateOfVisit'] as String;
          final id = e['id'] as int;
          final entryBy = e['entryBy'].toString();

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
            entryBy: entryBy,
          );
        }).toList();

        return datasets;
      } else {
        throw Exception('Error fetching data from the database.');
      }
    } catch (e) {
      print('Error connecting to server - $e');
    }
    return [];
  }

  static Future<dynamic> createDataset({
    required BuildContext context,
    required Dataset dataset,
  }) async {
    try {
      final userProvider = Provider.of<AuthProvider>(context, listen: false);

      final http.Response response =
          await http.post(Uri.parse('http://localhost:3000/api/create-dataset'),
              body: jsonEncode({
                'refNo': dataset.refNo,
                'bankName': dataset.bankName,
                'branchName': dataset.branchName,
                'partyName': dataset.partyName,
                'colonyName': dataset.colonyName,
                'cityVillageName': dataset.cityVillageName,
                'latitude': dataset.latitude,
                'longitude': dataset.longitude,
                'marketRate': dataset.marketRate,
                'unit': dataset.unit,
                'createdAt': dataset.createdAt.toIso8601String(),
                'remarks': dataset.remarks,
                'colorMark': dataset.colorMark ?? '',
                'dateOfVisit': dataset.dateOfVisit.toIso8601String(),
                'entryBy': userProvider.user.email,
              }),
              headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': userProvider.user.token,
          });

      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () {
          showAlert(context, 'Dataset created successfully!');
        },
      );
    } catch (e) {
      throw Exception('Error connecting to server - $e');
    }
  }

  static Future<dynamic> deleteDataset(int id) async {
    try {
      final response = await Dio().delete(
        'http://localhost:3000/api/delete-dataset/$id',
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

  static Future<dynamic> updateDataset({
    required BuildContext context,
    required int id,
    required Dataset dataset,
  }) async {
    try {
      //  final userProvider = Provider.of<AuthProvider>(context, listen: false);

      final http.Response response = await http
          .put(Uri.parse('http://localhost:3000/api/update-dataset/$id'),
              body: jsonEncode({
                'id': dataset.id,
                'refNo': dataset.refNo,
                'bankName': dataset.bankName,
                'branchName': dataset.branchName,
                'partyName': dataset.partyName,
                'colonyName': dataset.colonyName,
                'cityVillageName': dataset.cityVillageName,
                'latitude': dataset.latitude,
                'longitude': dataset.longitude,
                'marketRate': dataset.marketRate,
                'unit': dataset.unit,
                'remarks': dataset.remarks,
                'colorMark': dataset.colorMark,
              }),
              headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            //  'x-auth-token': userProvider.user.token,
          });

      if (response.statusCode == 201) {
        return response;
      } else {
        throw Exception('Error fetching data from the database.');
      }
    } catch (e) {
      throw Exception('Error connecting to server - $e');
    }
  }

  static Future<dynamic> updateDateOfVisit({
    required int id,
    required DateTime dateOfVisit,
  }) async {
    try {
      final http.Response response = await http.put(
          Uri.parse('http://localhost:3000/api/update-dataset-dateOfVisit/$id'),
          body: jsonEncode(
            {
              'dateOfVisit': dateOfVisit.toIso8601String(),
            },
          ),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            //  'x-auth-token': userProvider.user.token,
          });

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
