import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geoestate/constants/error_handling.dart';
import 'package:geoestate/constants/utils.dart';
import 'package:geoestate/pages/home_page.dart';
import 'package:geoestate/provider/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AuthService {
  // void loginUser({
  //   required String email,
  //   required String password,
  //   required String name,
  // }) async {
  //   try {
  //     User user = User(
  //       id: 1,
  //       username: name,
  //       email: email,
  //       password: password,
  //       token: '',
  //       type: '',
  //     );
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  // static Future<dynamic> login({
  //   required BuildContext context,
  //   required String email,
  //   required String password,
  // }) async {
  //   try {
  //     final Response response = await Dio().post(
  //       '${ApiEndpoints.baseUrl}${ApiEndpoints.loginEndpoint}',
  //       data: jsonEncode(
  //         {
  //           'email': email,
  //           'password': password,
  //         },
  //       ),
  //       options: Options(
  //         headers: <String, String>{
  //           'Content-Type': 'application/json; charset=UTF-8',
  //         },
  //       ),
  //     );

  //     httpErrorHandle(
  //       response: response,
  //       context: context,
  //       onSuccess: () {
  //         showSnackBar(context, 'Login successful!');
  //       },
  //     );

  //     return response.data;
  //   } catch (e) {
  //     throw Exception('Error connecting to server - $e');
  //   }
  // }

  // static Future<dynamic> createUser({
  //   required BuildContext context,
  //   required String email,
  //   required String password,
  // }) async {
  //   try {
  //     final response = await Dio().post(
  //       '${ApiEndpoints.baseUrl}${ApiEndpoints.createUserEndpoint}',
  //       data: jsonEncode(
  //         {
  //           'email': email,
  //           'password': password,
  //         },
  //       ),
  //       options: Options(
  //         headers: {'Content-Type': 'application/json; charset=utf-8'},
  //       ),
  //     );

  //     httpErrorHandle(
  //       response: response,
  //       context: context,
  //       onSuccess: () {
  //         showSnackBar(context, 'Account created successfully!');
  //       },
  //     );
  //   } catch (e) {
  //     print(e);
  //     throw Exception('Error connecting to server - $e');
  //   }
  // }

  static Future<dynamic> login({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      http.Response res = await http.post(
        Uri.parse('http://localhost:3000/api/signin'),
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          Provider.of<AuthProvider>(context, listen: false).setUser(res.body);

          print(res.body);
          await prefs.setString('x-auth-token', jsonDecode(res.body)['token']);

          Navigator.of(context).pushNamedAndRemoveUntil(
            HomePage.routeName,
            (route) => false,
          );
        },
      );
    } catch (e) {
      showAlert(context, e.toString());
    }
  }

  Future<dynamic> getUserData(
    BuildContext context,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');

      if (token == null) {
        prefs.setString('x-auth-token', '');
      }

      var tokenRes = await http.post(
        Uri.parse('http://localhost:3000/tokenIsValid'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token!
        },
      );

      var response = jsonDecode(tokenRes.body);

      if (response == true) {
        http.Response userRes = await http
            .get(Uri.parse('http://localhost:3000/'), headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token
        });

        var userProvider = Provider.of<AuthProvider>(context, listen: false);
        userProvider.setUser(userRes.body);
      }

      // httpErrorHandle(
      //   response: response,
      //   context: context,
      //   onSuccess: () async {
      //     SharedPreferences prefs = await SharedPreferences.getInstance();

      //     await prefs.setString(
      //         'x-auth-token', jsonDecode(response.body)['token']);
      //   },
      // );

      if (response.hashCode == 201) {
        SharedPreferences prefs = await SharedPreferences.getInstance();

        await prefs.setString(
            'x-auth-token', jsonDecode(response.body)['token']);
      }
    } catch (e) {
      showAlert(context, e.toString());
    }
  }
}
