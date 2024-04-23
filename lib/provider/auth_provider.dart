import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../Models/user.dart';

class AuthProvider extends ChangeNotifier {
  final storage = const FlutterSecureStorage();

  // Future<void> createUser(
  //   BuildContext context,
  //   String email,
  //   String password,
  // ) async {
  //   try {
  //     final responseList = await AuthService.createUser(
  //       context: context,
  //       email: email,
  //       password: password,
  //     );
  //     final response = responseList
  //         .first; // Assuming there's only one response object in the list
  //     print(response);

  //     final token = response['token'];

  //     print(token);

  //     await storage.write(key: 'token', value: token);

  //     notifyListeners();
  //   } catch (e) {
  //     print(e);
  //     throw Exception('Failed to create user. - $e');
  //   }
  // }

  // Future<void> login({
  //   required BuildContext context,
  //   required String email,
  //   required String password,
  // }) async {
  //   try {
  //     final response = await AuthService.login(
  //       context: context,
  //       email: email,
  //       password: password,
  //     );

  //     print(response);

  //     final token = response['token'];

  //     print(token);

  //     await storage.write(key: 'token', value: token);

  //     notifyListeners();
  //   } catch (e) {
  //     print(e);
  //     throw Exception('Failed to login - $e');
  //   }
  // }

  // Future<String?> getJwtToken() async {
  //   var value = await storage.read(
  //     key: '1231',
  //   );
  //   return value;
  // }

  // Future<void> logout() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.remove('jwtToken');

  //   notifyListeners();
  // }

  // Future<bool> get isLoggedIn async {
  //   final token = await getJwtToken();
  //   return token != null;
  // }

  User _user = User(
    id: 0,
    email: '',
    password: '',
    type: '',
    token: '',
  );

  User get user => _user;

  void setUser(String user) {
    _user = User.fromJson(user);
    print(user);
    notifyListeners();
  }

  void setUserFromModel(User user) {
    _user = user;
    print(user);
    notifyListeners();
  }
}
