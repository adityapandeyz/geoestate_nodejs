import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:geoestate/Models/bank.dart';
import 'package:geoestate/constants/global_variables.dart';

import '../Models/dataset.dart';
import '../Models/my_marker.dart';

class MarkerApi {
  static Future<dynamic> createMarker(Marker marker) async {
    try {
      final Response response = await Dio().post(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.bankEndpoint}',
        data: marker.toJson(),
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Error writing data to database.');
      }
    } catch (e) {
      print(e);
      throw Exception('Error connecting to server - $e');
    }
  }

  static Future<dynamic> updateRateInMarker(
      int id, int rate, String unit) async {
    try {
      final response = await Dio().put(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.markerEndpoint}',
        data: jsonEncode(
          {
            'id': id,
            'marketRate': rate,
            'unit': unit,
          },
        ),
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Error writing data to database.');
      }
    } catch (e) {
      print(e);
      throw Exception('Error connecting to server - $e');
    }
  }

  static Future<List<Marker>> getAllMarkers() async {
    try {
      final Response response = await Dio().get(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.markerEndpoint}',
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

  static Future<dynamic> deleteMarkers(int id) async {
    try {
      final response = await Dio().delete(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.markerEndpoint}',
        data: jsonEncode(
          {
            'id': id,
          },
        ),
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        return response;
      } else {
        throw Exception('Error fetching data from the database.');
      }
    } catch (e) {
      throw Exception('Error connecting to server - $e');
    }
  }
}

class BankApi {
  static Future<List<Bank>> getAllBanks() async {
    try {
      final response = await Dio().get(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.bankEndpoint}',
      );

      if (response.statusCode == 200) {
        final responseData = response.data as List<dynamic>;

        List<Bank> markers = responseData.map((e) {
          final id = e['id'] as int;
          final bankName = e['bankName'] as String;
          final branchName = e['branchName'] as String;
          final ifscCode = e['ifscCode'] as String;

          return Bank(
            id: id,
            bankName: bankName,
            branchName: branchName,
            ifscCode: ifscCode,
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

  static Future<dynamic> createBank(Bank bank) async {
    try {
      final response = await Dio().post(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.bankEndpoint}',
        data: bank.toJson(),
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Error writing data to database.');
      }
    } catch (e) {
      throw Exception('Error connecting to server - $e');
    }
  }

  // static Future<dynamic> updateRateInMarker(
  //     int id, int rate, String unit) async {
  //   try {
  //     final response = await Dio().put(
  //       '${ApiEndpoints.baseUrl}${ApiEndpoints.markerEndpoint}',
  //       data: jsonEncode(
  //         {
  //           'id': id,
  //           'marketRate': rate,
  //           'unit': unit,
  //         },
  //       ),
  //       options: Options(
  //         headers: {'Content-Type': 'application/json'},
  //       ),
  //     );

  //     if (response.statusCode == 200) {
  //       return response.data;
  //     } else {
  //       throw Exception('Error writing data to database.');
  //     }
  //   } catch (e) {
  //     print(e);
  //     throw Exception('Error connecting to server - $e');
  //   }
  // }

  // static Future<dynamic> deleteMarkers(int id) async {
  //   try {
  //     final response = await Dio().delete(
  //       '${ApiEndpoints.baseUrl}${ApiEndpoints.markerEndpoint}',
  //       data: jsonEncode(
  //         {
  //           'id': id,
  //         },
  //       ),
  //       options: Options(
  //         headers: {'Content-Type': 'application/json'},
  //       ),
  //     );

  //     if (response.statusCode == 200) {
  //       return response;
  //     } else {
  //       throw Exception('Error fetching data from the database.');
  //     }
  //   } catch (e) {
  //     throw Exception('Error connecting to server - $e');
  //   }
  // }

  static deleteBank(int id) {}
}

class DatasetApi {
  static Future<List<Dataset>> getAllDatasets() async {
    try {
      final response = await Dio().get(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.datasetEndpoint}',
      );

      if (response.statusCode == 200) {
        final responseData = response.data as List<dynamic>;

        List<Dataset> datasets = responseData.map((e) {
          final refNo = e['refNo'] as String;
          final datasetName = e['datasetName'] as String;
          final bankName = e['bankName'] as String;
          final branchName = e['branchName'] as String;
          final partyName = e['partyName'] as String;
          final colonyName = e['colonyName'] as String;
          final cityVillageName = e['cityVillageName'] as String;
          final latitude = e['latitude'] as double;
          final longitude = e['longitude'] as double;
          final marketRate = e['marketRate'] as int;
          final unit = e['unit'] as String;
          final dateOfValuationString = e['dateOfValuation'] as String;
          final entryBy = e['entryBy'] as String;
          final createdAtString = e['createdAt'] as String;
          final remarks = e['remarks'] as String;
          final colorMark = e['colorMark'] as String;
          final dateOfVisitString = e['dateOfVisit'] as String;
          final billId = e['billId'] as String;
          final id = e['id'] as int;

          final dateOfValuation = DateTime.parse(dateOfValuationString);
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
        '${ApiEndpoints.baseUrl}${ApiEndpoints.datasetEndpoint}',
        data: dataset.toJson(),
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Error writing data to database.');
      }
    } catch (e) {
      throw Exception('Error connecting to server - $e');
    }
  }

  // static Future<dynamic> updateRateInMarker(
  //     int id, int rate, String unit) async {
  //   try {
  //     final response = await Dio().put(
  //       '${ApiEndpoints.baseUrl}${ApiEndpoints.markerEndpoint}',
  //       data: jsonEncode(
  //         {
  //           'id': id,
  //           'marketRate': rate,
  //           'unit': unit,
  //         },
  //       ),
  //       options: Options(
  //         headers: {'Content-Type': 'application/json'},
  //       ),
  //     );

  //     if (response.statusCode == 200) {
  //       return response.data;
  //     } else {
  //       throw Exception('Error writing data to database.');
  //     }
  //   } catch (e) {
  //     print(e);
  //     throw Exception('Error connecting to server - $e');
  //   }
  // }

  // static Future<dynamic> deleteMarkers(int id) async {
  //   try {
  //     final response = await Dio().delete(
  //       '${ApiEndpoints.baseUrl}${ApiEndpoints.markerEndpoint}',
  //       data: jsonEncode(
  //         {
  //           'id': id,
  //         },
  //       ),
  //       options: Options(
  //         headers: {'Content-Type': 'application/json'},
  //       ),
  //     );

  //     if (response.statusCode == 200) {
  //       return response;
  //     } else {
  //       throw Exception('Error fetching data from the database.');
  //     }
  //   } catch (e) {
  //     throw Exception('Error connecting to server - $e');
  //   }
  // }
}
