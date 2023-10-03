import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../pages/explore.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  Map userData = {};

  @override
  void didChangeDependencies() {
    getUserData();
    super.didChangeDependencies();
  }

  void getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('userData')) {
      userData = await jsonDecode(prefs.getString('userData')!);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      child: Drawer(
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
          child: Column(
            children: [
              InkWell(
                // onTap: () => NavigatorKeys.rootNavigator.currentState
                //     ?.pushNamed("/UserProfileScreen"),
                child: Container(
                  height: 80,
                  padding: const EdgeInsets.all(10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(width: 2, color: Colors.grey)),
                  child: Center(
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        const FadeInImage(
                          height: 40,
                          width: 40,
                          placeholder:
                              AssetImage("assets/images/userProfile.png"),
                          image: AssetImage("assets/images/userProfile.png"),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Your Name",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                userData.containsKey('name')
                                    ? userData['name']
                                    : "Guest",
                                style: const TextStyle(
                                  fontSize: 12,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              DrawerTile(
                  text: "Home",
                  iconName: "home",
                  onPressed: () {
                    Get.back();
                    Get.toNamed('/');
                  }),
              DrawerTile(
                  text: "Explore",
                  iconName: "explore",
                  onPressed: () {
                    Get.back();
                    Get.to(() => const Explore(keywords: ""));
                  }),
              DrawerTile(
                  text: "Categories",
                  iconName: "categories",
                  onPressed: () {
                    Get.back();
                    Get.toNamed('/categories');
                  }),
              DrawerTile(
                  text: "My Basket",
                  iconName: "basket",
                  onPressed: () {
                    Get.back();
                    Get.toNamed('/basket');
                  }),
              DrawerTile(
                  text: "My Orders",
                  iconName: "myOrders",
                  onPressed: () {
                    Get.back();
                    Get.toNamed('/orders');
                  }),
              DrawerTile(
                  text: "My Profile",
                  iconName: "userProfile",
                  onPressed: () {
                    Get.to('/');
                  }),
              const Spacer(),
              DrawerTile(
                  text: "Sign Out",
                  iconName: "signOut",
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    prefs.remove('userData');
                    Get.back();
                  }),
              DrawerTile(
                  text: "Exit",
                  iconName: "exit",
                  onPressed: () {
                    exit(0);
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

class DrawerTile extends StatelessWidget {
  final String text, iconName;
  final VoidCallback onPressed;

  const DrawerTile(
      {Key? key,
      required this.text,
      required this.iconName,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
      child: InkWell(
        onTap: onPressed,
        child: Row(
          children: [
            Image(
              height: 25,
              width: 25,
              image: AssetImage("assets/images/$iconName.png"),
            ),
            const SizedBox(
              width: 25,
            ),
            Text(
              text,
              style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
