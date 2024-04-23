import 'package:flutter/material.dart';

noDataIcon() {
  return const Center(
    child: Padding(
      padding: EdgeInsets.all(8.0),
      child: Icon(
        Icons.cancel,
        color: Colors.white,
        size: 56,
      ),
    ),
  );
}

showAlert(BuildContext context, String text) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        // title: Text("Marker Created Successfully"),
        content: Text(
          text,
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            child: const Text(
              "OK",
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      );
    },
  );
}

// void showSnackBar(BuildContext context, String text) {
//   ScaffoldMessenger.of(context).showSnackBar(
//     SnackBar(
//       content: Text(text),
//       duration: const Duration(seconds: 2),
//     ),
//   );
// }
