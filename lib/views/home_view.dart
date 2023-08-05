import 'package:flutter/material.dart';
import 'package:tt9_betweener_challenge/controllers/link_controller.dart';
import 'package:tt9_betweener_challenge/controllers/user_controller.dart';
import 'package:tt9_betweener_challenge/views/add_link_view.dart';
import 'package:tt9_betweener_challenge/views/search_view.dart';

import '../constants.dart';
import '../models/link.dart';
import '../models/user.dart';
import 'friend_profile_view.dart';

class HomeView extends StatefulWidget {
  static String id = '/homeView';
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late Future<User> user;
  late Future<List<Link>> links;

  @override
  void initState() {
    user = getLocalUser();
    links = getLinks(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, SearchView.id);
              },
              icon: const Icon(
                Icons.search,
                size: 30,
              ),
            ),
            IconButton(
              onPressed: () {
                
              },
              icon: const Icon(
                Icons.qr_code_scanner_outlined,
                size: 30,
              ),
            )
          ]),
          const SizedBox(
            height: 50,
          ),
          FutureBuilder(
            future: user,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(
                  '    Hello, ${snapshot.data?.user?.name}!',
                  style: const TextStyle(
                      color: kPrimaryColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                );
              }
              return const Text('@user');
            },
          ),
          SizedBox(
              width: 400,
              height: 400,
              child: Image.asset('assets/imgs/qr_code2.png')),
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: const Divider(
                color: kPrimaryColor,
                thickness: 2,
              ),
            ),
          ),
          FutureBuilder(
            future: links,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return SizedBox(
                  height: 100,
                  child: ListView.separated(
                    itemCount: snapshot.data!.length,
                    padding: const EdgeInsets.all(12),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final title = snapshot.data?[index].title?.toUpperCase();
                      final userName = snapshot.data?[index].username;
                      if (index == snapshot.data!.length - 1) {
                        return Row(children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                                color: kSecondaryColor,
                                borderRadius: BorderRadius.circular(15)),
                            child: Column(
                              children: [
                                Text(
                                  '$title',
                                  style: const TextStyle(
                                    color: kOnSecondaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  '@$userName',
                                  style:
                                      const TextStyle(color: kOnSecondaryColor),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, AddLinkView.id)
                                  .then((value) {
                                if (value == true) {
                                  setState(() {
                                    links = getLinks(context);
                                  });
                                }
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 182, 178, 246),
                                  borderRadius: BorderRadius.circular(15)),
                              child: const Column(
                                children: [
                                  Icon(
                                    Icons.add,
                                    color: kPrimaryColor,
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text('Add Link',
                                      style: TextStyle(
                                        color: kPrimaryColor,
                                      ))
                                ],
                              ),
                            ),
                          ),
                        ]);
                      }
                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            color: kSecondaryColor,
                            borderRadius: BorderRadius.circular(15)),
                        child: Column(
                          children: [
                            Text(
                              '$title',
                              style: const TextStyle(
                                color: kOnSecondaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              '@$userName',
                              style: const TextStyle(color: kOnSecondaryColor),
                            )
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        width: 8,
                      );
                    },
                  ),
                );
              }
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }
              return const Center(
                child: CircularProgressIndicator(
                  color: kPrimaryColor,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
