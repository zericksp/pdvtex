import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pdvtex/pages/login.dart';
import 'package:pdvtex/pages/menu.dart';
import 'package:pdvtex/utils/next_screen_dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
    late String idUser, username;

  @override
  void initState() {
    super.initState();
    isLogin();
  }

  void isLogin() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    bool? isLogin = sp.getBool('logged') ?? false;

    List<String> data = [sp.getInt('idUser').toString(),
     sp.getString('username') ??'',
     sp.getString('firstname') ??'',
     sp.getString('lastname') ??'',
     sp.getString('provider') ??'',
     sp.getString('picture') ??'',
     sp.getString('email') ??''];


    if (isLogin) {
      Timer(const Duration(seconds: 1), () {
        nextScreenReplace(context, MenuScreen(title: '', data: data));//idUser: int.parse(idUser) , username: username, firstname: firstname, lastname: lastname, provider: provider, picture: picture, email: email));
      });
    } else {
      Timer(const Duration(seconds: 1), () {
        nextScreenReplace(context, MyHomePage());
      });
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image.asset('assets/images/logo.png',
                width: double.infinity, height: 120, fit: BoxFit.scaleDown),
          ),
          Positioned(
            // The Positioned widget is used to position the text inside the Stack widget
            top: 150,
            left: 40,
            child: Text(
              'pdvtex',
              style: TextStyle(
                  fontSize: 60,
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontWeight: FontWeight.w100),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
