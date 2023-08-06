import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';
import '../controllers/follow_controller.dart';
import '../models/link.dart';
import '../models/user.dart';
import 'package:http/http.dart' as http;

class FriendProfileView extends StatefulWidget {
  static String id = '/friendProfileView';
  final UserClass userData;
  const FriendProfileView({super.key, required this.userData});

  @override
  State<FriendProfileView> createState() => _FriendProfileViewState();
}

class _FriendProfileViewState extends State<FriendProfileView> {
  late UserClass user;
  late List<Link> links;
  late String name;
  late String email;
  late int userId;
  late Future<List<int>> ids;
  List<int> followingIdsList = [];
  bool isFollowingChanged = false;

  void submitAddUser() async {
    final body = {
      'followee_id': userId.toString(),
    };

    addUser(body).catchError((err) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(err.toString()),
        backgroundColor: Colors.red,
      ));
      return false;
    });
  }

  List<dynamic>? followingList;
  bool isFollowed = false;
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
      isFollowed = followingList!.contains(userId);
      setState(() {});
    } else {
      throw Exception('Failed search');
    }
  }

  @override
  void initState() {
    getFollowing();
    user = widget.userData;
    name = user.name!;
    email = user.email!;
    links = user.links ?? [];
    userId = user.id!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.only(top: 50, left: 16, bottom: 0, right: 16),
      child: Center(
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_ios_rounded,
                  color: kPrimaryColor,
                  size: 40,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 40),
                width: MediaQuery.of(context).size.width * 0.5,
                child: AutoSizeText(
                  name,
                  maxLines: 1,
                  maxFontSize: 30,
                  minFontSize: 20,
                  style: const TextStyle(
                    fontSize: 30,
                    color: kPrimaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            decoration: BoxDecoration(
                color: kPrimaryColor, borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(children: [
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/imgs/friend.png')),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: AutoSizeText(
                            name,
                            maxLines: 1,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                            minFontSize: 18,
                            maxFontSize: 22,
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: AutoSizeText(
                            email,
                            maxLines: 1,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontSize: 18,
                            ),
                            minFontSize: 10,
                            maxFontSize: 18,
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        InkWell(
                          onTap: isFollowed
                              ? null
                              : () {
                                  submitAddUser();
                                  isFollowed = !isFollowed;
                                  // getFollowing();
                                  setState(() {});
                                },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 6),
                            decoration: BoxDecoration(
                              color: isFollowed ? Colors.grey : kSecondaryColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: isFollowed
                                ? const Text(
                                    'Following',
                                    style: TextStyle(
                                        color: kPrimaryColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18),
                                  )
                                : const Text(
                                    'Follow',
                                    style: TextStyle(
                                        color: kPrimaryColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18),
                                  ),
                          ),
                        ),
                      ])
                ]),
              ]),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          if (links.isNotEmpty)
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: ListView.separated(
                itemCount: links.length,
                padding: const EdgeInsets.all(12),
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  final title = links[index].title;
                  final link = links[index].link;
                  if (index % 2 == 0) {
                    return Center(
                      child: Container(
                        decoration: BoxDecoration(
                            color: kLightDangerColor,
                            borderRadius: BorderRadius.circular(12)),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          width: MediaQuery.of(context).size.width * 0.85,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title ?? '@link',
                                  style: const TextStyle(
                                      letterSpacing: 3,
                                      fontSize: 16,
                                      color: kOnLightDangerColor,
                                      fontWeight: FontWeight.w400),
                                ),
                                AutoSizeText(
                                  '$link',
                                  style: const TextStyle(
                                      color: kOnLightDangerColor,
                                      fontWeight: FontWeight.w400),
                                  maxLines: 1,
                                )
                              ]),
                        ),
                      ),
                    );
                  }
                  return Center(
                    child: Container(
                      decoration: BoxDecoration(
                          color: kLinksColor,
                          borderRadius: BorderRadius.circular(12)),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        width: MediaQuery.of(context).size.width * 0.85,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title ?? 'link',
                                style: const TextStyle(
                                    letterSpacing: 3,
                                    fontSize: 16,
                                    color: kPrimaryColor,
                                    fontWeight: FontWeight.w400),
                              ),
                              AutoSizeText(
                                '$link',
                                style: const TextStyle(
                                    color: kPrimaryColor,
                                    fontWeight: FontWeight.w400),
                                maxLines: 1,
                              )
                            ]),
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    height: 16,
                  );
                },
              ),
            )
          else
            Center(
                child: Container(
                    width: 220,
                    height: 60,
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 236, 234, 234),
                        borderRadius: BorderRadius.circular(15)),
                    child: const Center(
                        child: Text(
                      'User Has No Links!',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 2,
                          fontSize: 16),
                    ))))
        ]),
      ),
    ));
  }
}
