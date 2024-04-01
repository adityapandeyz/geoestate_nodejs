import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geoestate/constants/error_handling.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../Models/bank.dart';
import '../provider/auth_provider.dart';

class BankServices {
  static Future<List<Bank>> fetchBanks(BuildContext context) async {
    final userProvider = Provider.of<AuthProvider>(context, listen: false);
    List<Bank> bankList = [];

    try {
      http.Response res = await http.get(
          Uri.parse(
            'http://localhost:3000/api/banks/',
          ),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': userProvider.user.token,
          });

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          for (int i = 0; i < jsonDecode(res.body).length; i++) {
            bankList.add(
              Bank.fromJson(
                jsonDecode(res.body)[i],
              ),
            );
          }
        },
      );
    } catch (e) {}

    return bankList;
  }
}
