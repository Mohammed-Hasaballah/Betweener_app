import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tt9_betweener_challenge/models/user.dart';
import 'package:tt9_betweener_challenge/views/friend_profile_view.dart';
import 'package:tt9_betweener_challenge/views/widgets/secondary_button_widget.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../controllers/search_controller.dart';
import 'widgets/custom_text_form_field.dart';

class SearchView extends StatefulWidget {
  static String id = '/searchView';
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  TextEditingController userNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late List<UserClass> searchedUser = [];

  void submitSearch() {
    if (_formKey.currentState!.validate()) {
      final body = {
        'name': userNameController.text,
      };
      performSearch(body).then((searchResult) {
        setState(() {
          searchedUser = searchResult;
        });
      }).catchError((err) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(err.toString()),
          backgroundColor: Colors.red,
        ));
      });
    }
  }

  List<dynamic>? followingList;

  Future<void> getFollowing() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    User user = userFromJson(prefs.getString('user')!);
    final response = await http.get(Uri.parse(addUserUrl),
        headers: {'Authorization': 'Bearer ${user.token}'});
    if (response.statusCode == 200) {
      followingList = jsonDecode(response.body)['following'];
      followingList = followingList!.map((e) {
        return e['id'];
      }).toList();
      debugPrint(followingList.toString());
      setState(() {});
    } else {
      throw Exception('Failed Getting Following');
    }
  }

  @override
  void initState() {
    getFollowing();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 197, 193, 193),
        title: const Text('Search'),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextFormField(
                    controller: userNameController,
                    hint: 'username',
                    label: 'username',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please enter the username';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  SecondaryButtonWidget(
                    onTap: submitSearch,
                    text: 'Search',
                    width: 100,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: ListView.separated(
                      separatorBuilder: (context, index) {
                        return const Divider();
                      },
                      itemCount: searchedUser.length,
                      itemBuilder: (context, index) {
                        final user = searchedUser[index];
                        return ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FriendProfileView(
                                          userData: user,
                                          followingIds: followingList,
                                        )));
                          },
                          title: Text(
                            user.name!,
                            style: const TextStyle(color: Colors.black),
                          ),
                          subtitle: AutoSizeText(
                            user.email!,
                            maxLines: 1,
                          ),
                          leading: const Icon(Icons.person),
                          trailing: const Icon(Icons.arrow_forward_ios),
                        );
                      },
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
