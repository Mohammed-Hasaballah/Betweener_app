import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tt9_betweener_challenge/views/edit_link_view.dart';
import 'package:tt9_betweener_challenge/views/widgets/custom_slidable_link.dart';
import '../constants.dart';
import '../controllers/follow_controller.dart';
import '../controllers/link_controller.dart';
import '../controllers/user_controller.dart';
import '../models/link.dart';
import '../models/user.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:http/http.dart' as http;
import 'add_link_view.dart';

class ProfileView extends StatefulWidget {
  static String id = '/profileView';

  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late Future<User> user;
  late Future<List<Link>> links;
  late Future<int> followers;
  late Future<int> following;

  Future<bool> deleteLink(int linkId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    User user = userFromJson(prefs.getString('user')!);
    final response = await http.delete(Uri.parse('$linksUrl/$linkId'),
        headers: {'Authorization': 'Bearer ${user.token}'});
    if (response.statusCode == 200) {
      setState(() {
        links = getLinks(context);
      });
      return true;
    } else {
      throw Exception('Failed to delete');
    }
  }

  @override
  void initState() {
    user = getLocalUser();
    links = getLinks(context);
    followers = getFollowers();
    following = getFollowingNumber();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16, left: 16, bottom: 100, top: 50),
      child: Scaffold(
          floatingActionButton: FloatingActionButton(
              shape: const CircleBorder(),
              backgroundColor: kPrimaryColor,
              onPressed: () {
                Navigator.pushNamed(context, AddLinkView.id).then((value) {
                  if (value == true) {
                    setState(() {
                      links = getLinks(context);
                    });
                  }
                });
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 45,
                ),
              )),
          body: Center(
            child: Column(children: [
              const Text(
                'Profile',
                style: TextStyle(
                  fontSize: 30,
                  color: kPrimaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Column(children: [
                    const Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(
                            Icons.edit_outlined,
                            color: Colors.white,
                          )
                        ]),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CircleAvatar(
                              radius: 50,
                              backgroundImage:
                                  AssetImage('assets/imgs/pfp.png')),
                          const SizedBox(
                            width: 20,
                          ),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FutureBuilder(
                                  future: user,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return Text(
                                        ' ${snapshot.data?.user?.name} ',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22,
                                        ),
                                      );
                                    }
                                    return const Text('@user');
                                  },
                                ),
                                FutureBuilder(
                                  future: user,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return AutoSizeText(
                                        ' ${snapshot.data?.user?.email} ',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16,
                                        ),
                                        maxLines: 1,
                                        minFontSize: 12,
                                        maxFontSize: 16,
                                      );
                                    }
                                    return const Text('@user');
                                  },
                                ),
                                const Text(
                                  '+970595952824',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Row(children: [
                                  Container(
                                    padding: const EdgeInsets.all(6.0),
                                    decoration: BoxDecoration(
                                      color: kSecondaryColor,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: FutureBuilder(
                                      future: followers,
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const CircularProgressIndicator(); // or any loading indicator
                                        } else if (snapshot.hasError) {
                                          return Text(
                                            'Error:\n${snapshot.error}',
                                            style:
                                                const TextStyle(fontSize: 12),
                                          );
                                        } else {
                                          int value = snapshot.data ?? 0;
                                          return AutoSizeText(
                                            'followers:$value',
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 16,
                                            ),
                                            maxLines: 1,
                                            minFontSize: 12,
                                            maxFontSize: 16,
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(6.0),
                                    decoration: BoxDecoration(
                                      color: kSecondaryColor,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: FutureBuilder(
                                      future: following,
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const CircularProgressIndicator(); // or any loading indicator
                                        } else if (snapshot.hasError) {
                                          return Text(
                                            'Error:\n${snapshot.error}',
                                            style:
                                                const TextStyle(fontSize: 12),
                                          );
                                        } else {
                                          int value = snapshot.data ?? 0;
                                          return AutoSizeText(
                                            'following:$value ',
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 16,
                                            ),
                                            maxLines: 1,
                                            minFontSize: 12,
                                            maxFontSize: 16,
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ])
                              ])
                        ]),
                  ]),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              SingleChildScrollView(
                child: SizedBox(
                  height: 300,
                  child: FutureBuilder(
                    future: links,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.separated(
                          itemCount: snapshot.data!.length,
                          padding: const EdgeInsets.all(12),
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            final title =
                                snapshot.data?[index].title?.toUpperCase();
                            final link = snapshot.data?[index].link;
                            final linkId = snapshot.data?[index].id;
                            if (index % 2 == 0) {
                              return CustomSlidableProfileLink(
                                onEditPressed: (context) {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return EditLinkView(
                                      linkId: linkId ?? 0,
                                      defaultLink: link ?? 'default link',
                                      defaultTitle: title ?? 'default title',
                                    );
                                  })).then((value) {
                                    if (value == true) {
                                      setState(() {
                                        links = getLinks(context);
                                      });
                                    }
                                  });
                                },
                                onDeletePressed: (context) {
                                  deleteLink(linkId!);
                                },
                                linkTitle: title,
                                link: link,
                                backgroundColor: kLightDangerColor,
                                titleColor: kOnLightDangerColor,
                                linkColor: kOnLightDangerColor,
                              );
                            }
                            return CustomSlidableProfileLink(
                              onEditPressed: (context) {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return EditLinkView(
                                    linkId: linkId!,
                                    defaultLink: link!,
                                    defaultTitle: title!,
                                  );
                                })).then((value) {
                                  if (value == true) {
                                    setState(() {
                                      links = getLinks(context);
                                    });
                                  }
                                });
                              },
                              onDeletePressed: (context) {
                                deleteLink(linkId!);
                              },
                              linkTitle: title,
                              link: link,
                              backgroundColor: kLinksColor,
                              titleColor: kPrimaryColor,
                              linkColor: kPrimaryColor,
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const SizedBox(
                              height: 16,
                            );
                          },
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
                ),
              ),
            ]),
          )),
    );
  }
}
