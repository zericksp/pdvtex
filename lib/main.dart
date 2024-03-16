import 'package:pdvtex/provider/internet_provider.dart';
import 'package:pdvtex/provider/sign_in_provider.dart';
import 'package:pdvtex/pages/splash.dart';
import 'package:flutter/material.dart';
import 'package:pdvtex/routers/cart_shop/cart_shop.dart';
import 'package:pdvtex/routers/main_screen/main_screen.dart';
import 'package:pdvtex/routers/sales_point/sales_point.dart';
import 'package:pdvtex/store/store_pdv.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => StorePdv(),
      child: const ControlRouters(),
    ),
  );
}

class ControlRouters extends StatelessWidget {
  const ControlRouters({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/pdv': (context) => const SalesPoint(),
        '/cart_shop': (context) => const CartShop(idUser: '',),
        //'/rota4': (context) => Rota4(title: 'Título Personalizado'),c
      },
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: ((context) => SignInProvider()),
        ),
        ChangeNotifierProvider(
          create: ((context) => InternetProvider()),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.black
        ),
        title: "pdVTex",
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
      ),
    );
  }
}
