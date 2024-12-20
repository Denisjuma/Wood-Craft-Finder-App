import 'package:flutter/material.dart';
import 'package:wood_craft_finder/pages/home.dart';
import 'package:wood_craft_finder/pages/login.dart';
import 'package:wood_craft_finder/pages/register.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('auth_token');

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Wood Craft Finder',
    initialRoute: token != null ? '/home' : '/login',
    routes: {
      '/login': (context) => const LoginForm(),
      '/register': (context) => const Register(isSeller: false),
      '/home': (context) => Home(isSeller: true, token: token ?? ''),
    },
  ));
}

