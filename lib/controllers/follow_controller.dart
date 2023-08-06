import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tt9_betweener_challenge/constants.dart';
import 'package:tt9_betweener_challenge/models/user.dart';
import 'package:http/http.dart' as http;

Future<int> getFollowers() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  User user = userFromJson(prefs.getString('user')!);

  final response = await http.get(Uri.parse(followUrl),
      headers: {'Authorization': 'Bearer ${user.token}'});

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body)['followers_count'];

    return data;
  }

  return Future.error('Somthing wrong');
}

Future<int> getFollowingNumber() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  User user = userFromJson(prefs.getString('user')!);

  final response = await http.get(Uri.parse(followUrl),
      headers: {'Authorization': 'Bearer ${user.token}'});

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body)['following_count'];

    return data;
  }

  return Future.error('Somthing wrong');
}

Future<bool> addUser(Map<String, dynamic> body) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  User user = userFromJson(prefs.getString('user')!);
  final response = await http.post(Uri.parse(addUserUrl),
      body: body, headers: {'Authorization': 'Bearer ${user.token}'});
  if (response.statusCode == 200) {
    return true;
  } else {
    throw Exception('Failed add user');
  }
}

Future<List<int>> getFollowingIds() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  User user = userFromJson(prefs.getString('user')!);
  List<int> followingIds = [];

  final response = await http.get(Uri.parse(followUrl),
      headers: {'Authorization': 'Bearer ${user.token}'});

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    List<dynamic> followingList = data['following'];
    for (var user in followingList) {
      int userId = user['id'];
      followingIds.add(userId);
    }
    return followingIds;
  }

  return Future.error('Somthing wrong');
}

Future<List<dynamic>> getFollowingList() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  User user = userFromJson(prefs.getString('user')!);
  final response = await http.get(Uri.parse(addUserUrl),
      headers: {'Authorization': 'Bearer ${user.token}'});
  if (response.statusCode == 200) {
    List<dynamic>? followingList;
    followingList = jsonDecode(response.body)['following'];
    followingList = followingList!.map((e) {
      return e['id'];
    }).toList();
    return followingList;
  } else {
    throw Exception('Failed getting Following');
  }
}
