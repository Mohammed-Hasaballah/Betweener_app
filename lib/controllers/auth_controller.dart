import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tt9_betweener_challenge/constants.dart';
import 'package:tt9_betweener_challenge/models/user.dart';

import '../views/login_view.dart';

Future<User> login(Map<String, String> body) async {
  final response = await http.post(
    Uri.parse(loginUrl),
    body: body,
  );

  if (response.statusCode == 200) {
    return userFromJson(response.body);
  } else {
    throw Exception('Failed to login');
  }
}

Future<void> register(
  BuildContext context, {
  required String email,
  required String name,
  required String password,
  required String passwordConfirmation,
}) async {
  http.Response response = await http.post(Uri.parse(registerUrl), body: {
    "name": name,
    "email": email,
    "password": password,
    "password_confirmation": passwordConfirmation
  });
  if (response.statusCode == 201) {
    Navigator.pushReplacementNamed(context, LoginView.id);
  } else if (response.statusCode == 200) {
    showAlert(context, message: 'This email is used before');
  } else {
    return Future.error('failed to register');
  }
}
