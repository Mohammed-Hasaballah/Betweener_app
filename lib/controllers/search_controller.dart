import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../models/user.dart';
import 'package:http/http.dart' as http;

Future<List<UserClass>> performSearch(Map<String, String> body) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  User user = userFromJson(prefs.getString('user')!);

  final response = await http.post(Uri.parse(searchUrl),
      body: body, headers: {'Authorization': 'Bearer ${user.token}'});
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body)['user'] as List<dynamic>;
    return data.map((e) => UserClass.fromJson(e)).toList();
  } else {
    throw Exception('Failed to found the user');
  }
}
