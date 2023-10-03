import 'package:flutter/material.dart';
import 'package:get/get.dart';
import './views/pages/basket.dart';
import './views/pages/auth.dart';
import './views/pages/home.dart';
import './views/pages/orders.dart';
import './config//base_theme.dart';
import './views/pages/categories.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MegaMart',
      initialRoute: '/',
      theme: BaseTheme.lightTheme,
      routes: {
        "/": (context) => const Home(),
        "/login": (context) => const Auth(),
        "/basket": (context) => const MyBasket(),
        "/orders": (context) => const Orders(),
        "/categories": (context) => const AllCategories(),
      },
    );
  }
}
