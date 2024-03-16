import 'package:flutter/material.dart';
import 'package:pdvtex/main.dart';
import 'package:pdvtex/routers/cart_shop/cart_shop.dart';
import 'package:pdvtex/routers/sales_point/sales_point.dart';
import 'package:pdvtex/store/store_pdv.dart';

class Screen extends StatefulWidget {
final String title;
  final String username;

  const Screen({super.key, required this.title, required this.username});

  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ela Decora'),
      ),
      body: Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
        
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/pdv');
              },
              child: const Text('Ponto de Venda'),
            ),
            const SizedBox(
              height: 15,
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Vendas Efetuadas'),
            ),
          ],
        ),
      ),
    );
  }
}

class ControlRouters extends StatelessWidget {
  const ControlRouters({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const MyApp(),
        '/pdv': (context) => const SalesPoint(),
        '/cart_shop': (context) => const CartShop(idUser: '11'),
        //'/rota4': (context) => Rota4(title: 'Título Personalizado'),
      },
    );
  }
}