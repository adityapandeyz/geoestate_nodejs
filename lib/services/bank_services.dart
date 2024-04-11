import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Models/bank.dart';

class BankServices {
  static Future<List<Bank>> getAllBanks() async {
    try {
      final response = await Dio().get(
        'http://localhost:3000/api/banks',
      );

      if (response.statusCode == 201) {
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

  static Future<dynamic> createBank({
    required BuildContext context,
    required Bank bank,
  }) async {
    try {
      // final userProvider = Provider.of<AuthProvider>(context, listen: false);

      final http.Response response =
          await http.post(Uri.parse('http://localhost:3000/api/create-bank'),
              body: jsonEncode({
                'bankName': bank.bankName,
                'branchName': bank.branchName,
                'ifscCode': bank.ifscCode,
              }),
              headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            // 'x-auth-token': userProvider.user.token,
          });

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
        throw Exception('Error fetching data from the database.');
      }
    } catch (e) {
      throw Exception('Error connecting to server - $e');
    }
  }

  static Future<dynamic> deleteBank(int id) async {
    try {
      final response = await Dio().delete(
        'http://localhost:3000/api/delete-bank/$id',
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
}
