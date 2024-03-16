// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';
import 'package:animated_background/animated_background.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pdvtex/pages/splash.dart';
import 'package:pdvtex/pages/vtex.dart';
import 'package:pdvtex/routers/main_screen/main_screen.dart';
import 'package:pdvtex/routers/sales_point/sales_point.dart';
// import 'package:pdvtex/routers/cart_shop/cart_shop.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pdvtex/utils/next_screen_dart';
import 'package:url_launcher/url_launcher.dart';

class MenuScreen extends StatelessWidget {
  MenuScreen({
    Key? key,
    required this.title,
    required this.data,
    // required this.idUser, required this.username,required this.firstname,
    // required this.lastname, required this.provider, required this.picture, required this.email,
  }) : super(key: key);

  // int idUser;
  String title;
  List<String> data; //, firstname, lastname, provider, picture, email;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Menu",
      theme: ThemeData(
          primarySwatch: Colors.grey, primaryColor: Colors.deepOrange),
      home: MenuPage(title: title, data: data),
    ); //idUser: idUser, username: username, firstname: firstname, lastname: lastname, provider: provider, picture: picture, email: email),
    //);
  }
}

// ignore: must_be_immutable
class MenuPage extends StatefulWidget {
  // int idUser;
  List<String> data =
      []; //, username, firstname, lastname, provider, picture, email
  String title;

  MenuPage({
    super.key,
    required this.title,
    required this.data,
    // required this.idUser,
    // required this.username,
    // required this.firstname,
    // required this.lastname,
    // required this.provider,
    // required this.picture,
    // required this.email,
  });

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> with TickerProviderStateMixin {
  _launchURL() async {
    const url = 'tel:32451300';
    if (await canLaunchUrl(url as Uri)) {
      await launchUrl(url as Uri);
    } else {
      throw 'Não foi possível efetuar a chamada';
    }
  }

  var data;
  final int _qrcode = 0;
  late int _scanQRcode;
  late String qrcodeScanRes;
  String _barcode = "";
  double width = 0;
  double height = 0;

  Future setScan() async {
    var response = await http.get(
        Uri.parse(
            "http://www.tiven.com.br/crud/prc_setScanByMachine.php?MACHINE=${_qrcode.toString()}&VALUE=${_barcode.toString()}"),
        headers: {"Accept": "application/json"});
    if (kDebugMode) {
      print(_scanQRcode);
    }
    if (response.contentLength! >= 100) {
      setState(() {
        var convertDataToJson = json.decode(response.body);
        data = convertDataToJson['result'];
        _barcode = data[0]['scn_value'];
      });
    } else {
      setState(() {
        _barcode = _barcode;
      });
    }
  }

  //Incrementing qrcode after click
  incrementQrcode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(
      () {
        prefs.setInt('qrcode', int.parse(qrcodeScanRes));
      },
    );
  }

  Future<Future<String?>> _showDialog() async {
    return showDialog<String>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.0))),
          contentPadding: const EdgeInsets.only(top: 10.0),
          shadowColor: Colors.white,
          backgroundColor: Colors.black,
          title: const Text(
            'pdvtex ',
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
          content: Container(
            color: Colors.black,
            height: 70,
            width: MediaQuery.of(context).size.width,
            child: const SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                    textAlign: TextAlign.center,
                    'Deseja realmente sair?',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            Expanded(
              child: ElevatedButton.icon(
                icon: const Icon(
                  Icons.cancel_presentation,
                  color: Colors.grey,
                  size: 30.0,
                ),
                style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    alignment: AlignmentGeometry.lerp(
                        Alignment.center, Alignment.center, 5),
                    backgroundColor: Colors.black,
                    minimumSize: const Size(100, 50),
                    maximumSize: const Size(140, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                      side: BorderSide(
                        style: BorderStyle.solid,
                        color: Colors.grey.withOpacity(0.5),
                        width: 0.2,
                      ),
                    ),
                    shadowColor: Colors.grey,
                    elevation: 8),
                label: Text(
                  "Cancelar",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            Expanded(
              child: ElevatedButton.icon(
                icon: const Icon(
                  Icons.exit_to_app_rounded,
                  color: Colors.grey,
                  size: 30.0,
                ),
                style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    alignment: AlignmentGeometry.lerp(
                        Alignment.center, Alignment.center, 5),
                    backgroundColor: Colors.black,
                    minimumSize: const Size(100, 50),
                    maximumSize: const Size(140, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                      side: BorderSide(
                        style: BorderStyle.solid,
                        color: Colors.grey.withOpacity(0.5),
                        width: 0.2,
                      ),
                    ),
                    shadowColor: Colors.grey,
                    elevation: 8),
                label: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Sair',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
                onPressed: () {
                  nextScreenReplace(context, const SplashScreen());
                  logout();
                },
              ),
            ),
          ],
        );
      },
    );
  }

  logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('logged', false);
    setState(
      () {
        prefs.setBool('logged', false);
      },
    );
  }

  @override
  Widget build(BuildContext   context) {
    width = MediaQuery.of(context).size.width * 0.9;
    height = MediaQuery.of(context).size.height * 0.9;
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 2, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'pdvtex',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.w100),
                  ),
                  const SizedBox(
                    width: 25,
                  ),
                  Image.asset(
                    'assets/images/logo.png',
                    width: 18,
                    height: 18,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: Colors.black,
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: Row(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        width: 65.0,
                        height: 65.0,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: NetworkImage(
                                "https://www.pedimus.com.br/home/img/rick.png"),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Usuário : ${widget.data[0]}"),
                            Text("Nome : ${widget.data[1]}"),
                            Text("Sobrenome : ${widget.data[2]}"),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            ListTile(
              title: const Text('Seu perfil'),
              onTap: () {},
            ),
            ListTile(
              title: const Text('Seu contrato'),
              onTap: () {},
            ),
            ListTile(
              title: const Text('Chamar Serviço ao Cliente'),
              onTap: () {
                _launchURL();
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('Sobre nós'),
              onTap: () {},
            ),
            const Divider(),
            ListTile(
              title: const Text('Sair'),
              onTap: () {
                _showDialog();
              },
            ),
          ],
        ),
      ),
      body: AnimatedBackground(
        behaviour: RandomParticleBehaviour(
          options: const ParticleOptions(
              spawnMaxRadius: 11,
              spawnMinSpeed: 11.00,
              particleCount: 70,
              spawnMaxSpeed: 22,
              minOpacity: 0.2,
              opacityChangeRate: 0.25,
              spawnOpacity: 0.2,
              maxOpacity: 0.2,
              baseColor: Colors.grey,
              image: Image(
                image: AssetImage(
                  'assets/images/logo50p.png',
                ),
              )),
        ),
        vsync: this,
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(seconds: 1),
            curve: Curves.ease,
            height: MediaQuery.of(context).size.height * 0.95,
            width: MediaQuery.of(context).size.width * 0.95,
            decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.1), // added
                border: Border.all(
                    color: Colors.grey.withOpacity(0.5), width: 0.5), // added
                borderRadius: BorderRadius.circular(6.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade500.withOpacity(0.1),
                    offset: const Offset(4.0, 4.0),
                    blurRadius: 12.0,
                    spreadRadius: 1.0,
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    offset: const Offset(-4.0, -4.0),
                    blurRadius: 12.0,
                    spreadRadius: 1.0,
                  ),
                ]),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            icon: const Icon(
                              Icons.exit_to_app_outlined,
                              color: Colors.grey,
                              size: 30.0,
                            ),
                            style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                alignment: AlignmentGeometry.lerp(
                                    Alignment.center, Alignment.center, 5),
                                backgroundColor: Colors.black,
                                minimumSize: Size(width * 0.45, height * 0.1),
                                maximumSize: Size(width * 0.45, height * 0.1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  side: BorderSide(
                                    style: BorderStyle.solid,
                                    color: Colors.grey.withOpacity(0.5),
                                    width: 0.2,
                                  ),
                                ),
                                shadowColor: Colors.grey,
                                elevation: 10),
                            label: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const AutoSizeText(
                                  'Carrinho' + "\r",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white),
                                  maxLines: 1,
                                ),
                                Text(
                                  "Compras",
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ],
                            ),
                            onPressed: () {
                              var route = MaterialPageRoute(
                                builder: (BuildContext context) => const SalesPoint(
                                ),
                              );
                              Navigator.of(context).push(route);
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: ElevatedButton.icon(
                            icon: const Icon(
                              Icons.exit_to_app_outlined,
                              color: Color.fromARGB(255, 255, 1, 1),
                              size: 30.0,
                            ),
                            style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                alignment: AlignmentGeometry.lerp(
                                    Alignment.center, Alignment.center, 5),
                                backgroundColor: Colors.black,
                                minimumSize: Size(width * 0.45, height * 0.1),
                                maximumSize: Size(width * 0.45, height * 0.1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  side: BorderSide(
                                    style: BorderStyle.solid,
                                    color: Colors.grey.withOpacity(0.5),
                                    width: 0.2,
                                  ),
                                ),
                                shadowColor: Colors.grey,
                                elevation: 10),
                            label: const AutoSizeText(
                              'Sair',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Color.fromARGB(255, 255, 1, 1)),
                              maxLines: 2,
                            ),
                            onPressed: () {
                              _showDialog();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
