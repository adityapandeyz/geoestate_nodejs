import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geoestate/constants/utils.dart';
import 'package:http/http.dart';

httpErrorHandle({
  required Response response,
  required BuildContext context,
  required VoidCallback onSuccess,
}) {
  switch (response.statusCode) {
    case 200:
      onSuccess();
      break;
    case 400:
      showAlert(context, jsonDecode(response.body)["msg"]);
      break;
    case 401:
      showAlert(context, jsonDecode(response.body)["error"]);
      break;
    case 403:
      showAlert(context, jsonDecode(response.body)["error"]);
      break;
    case 404:
      showAlert(context, jsonDecode(response.body)["error"]);
      break;
    case 500:
      showAlert(context, jsonDecode(response.body)["error"]);
      break;
    default:
      showAlert(context, jsonDecode(response.body)["error"]);
      break;
  }
}
