import 'package:flutter/material.dart';

class ApiEndpoints {
  static const String baseUrl = 'http://localhost:3000';
  // static const String baseUrl =
  //     'https://app-6e2b6ea7-cf26-4f3b-bd80-8e75433bbaa0.cleverapps.io';
  static const String loginEndpoint = '/api/signin';
  static const String createUserEndpoint = '/api/signup';
  static const String markerEndpoint = '/marker';
  static const String bankEndpoint = '/bank';
  static const String datasetEndpoint = '/dataset';
}

const double screenWidth = 800.00;

class AppColors {
  static const backgroundColor = Color.fromARGB(255, 0, 0, 0);
  static const primaryColor = Color.fromARGB(94, 68, 137, 255);
  static const secondaryColor = Color.fromARGB(34, 158, 158, 158);
  static const greyBackColor = Color.fromARGB(255, 32, 32, 32);
  static const lightGreyText = Color.fromARGB(255, 39, 39, 39);
}
