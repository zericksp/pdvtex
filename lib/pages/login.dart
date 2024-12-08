// ignore_for_file: library_private_types_in_public_api, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:pdvtex/pages/menu.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'package:pdvtex/utils/next_screen_dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _pseudoController = TextEditingController();
  final _passwordController = TextEditingController();
  late int idUser;
  late String title, username, firstname, lastname, provider, picture, email;

  // ignore: prefer_typing_uninitialized_variables
  var data;
  bool _enabledPwd = false;
  bool _enabledSend = false;

  var _isSecured = true;

  //**************** Get Login Connection && Data ************************/
  // ignore: missing_return

  //*********************Alert Dialog Empty Required Fields******************************/
  void onSignedInEmptyFields(String text) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // retorna um objeto do tipo Dialog
        return AlertDialog(
          titleTextStyle: const TextStyle(fontSize: 15, color: Colors.white),
          backgroundColor: Colors.grey.shade900,
          elevation: 8,
          title: Stack(
            children: [
              Image.asset(
                'assets/images/bckgrnd.jpg',
                fit: BoxFit.contain,
              ),
              Container(
                color: Colors.black,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      text,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: ElevatedButton.icon(
                            onPressed: () async {
                              setState(() {
                                Navigator.of(context).pop();
                              });
                            },
                            label: const Text("Voltar"),
                            icon: const Icon(Icons.exit_to_app),
                            style: ButtonStyle(
                                backgroundColor:
                                    WidgetStateProperty.all<Color>(Colors.grey),
                                foregroundColor: WidgetStateProperty.all<Color>(
                                    Colors.white))),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  //*********************Alert Dialog Pseudo******************************/
  void onSignedInErrorPassword() {
    const AlertDialog(
      title: Text("Erro ao acessar"),
      content: Text(
          "Ocorreu um erro com a senha ao acessar. Favor tentar novamente."),
    );
    showDialog(
        context: context,
        builder: (_) => const Text(
            "Ocorreu um erro com acesso do usuário. Favor tentar novamente."));
  }

  //********************Alert Dialog Pseudo******************************/
  void onSignedInErrorPseudo() {
    var alert = const AlertDialog(
      title: Text("Erro ao acessar"),
      content: Text(
          "Ocorreu um erro com acesso do usuário. Favor tentar novamente."),
    );
    showDialog(
        context: context,
        builder: (_) => const Text(
            "Ocorreu um erro com acesso do usuário. Favor tentar novamente."));
  }

  //******************* Check Data ****************************/
  VerifData(String pseudo, String password, var datadb) async {
    var content = const Utf8Encoder().convert(password);
    var md5 = crypto.md5;

    if (pseudo.isEmpty && password.isEmpty) {
      onSignedInEmptyFields("Os campos usuário e senha são necessários");
      return;
    }

    if (pseudo.isEmpty) {
      onSignedInEmptyFields("O campo usuário é necessário");
      return;
    }

    if (password.isEmpty) {
      onSignedInEmptyFields("O campo senha é necessário");
      return;
    }

    var digest = md5.convert(content);
    password = hex.encode(digest.bytes);

    if (data['username'] == pseudo) {
      if (data['password'] == password) {
        List<String> logg = [
          data['user_id']!,
          data['first_name'] ?? '',
          data['last_name'] ?? '',
          data['email'] ?? '',
          'database',
          data['picture'] ?? '',
        ];
        var route = MaterialPageRoute(
          builder: (BuildContext context) => MenuPage(
            title: '',
            data: logg,
          ),
          // firstname: data['first_name']!,
          // lastname: data['last_name']!,
          // username: data['username']!,
          // email: data['email']!,
          // provider: 'database',
          // picture: data['picture']!,
          // ),
        );

        saveSharedData();

        setState(() {
          // _pseudoController.text = '';
          // _passwordController.text = '';
        });

        Navigator.of(context).push(route);
      } else {
        onSignedInErrorPassword();
      }
    } else {
      onSignedInErrorPseudo();
    }
  }

  saveSharedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('logged', true);
    prefs.setString('userName', data['username']);
    prefs.setInt('idUser', int.parse(data['user_id']));
    prefs.setString('firstname', data['first_name']);
    prefs.setString('lastname', data['last_name']);
    prefs.setString('username', data['username']);
    prefs.setString('email', data['userEmail']);
    prefs.setString('provider', 'database');
    prefs.setString('picture', data['picture'] ?? '');

    setState(
      () {
        prefs.setBool('logged', true);
      },
    );
  }

  handleAfterSignIn() {
    Future.delayed(const Duration(milliseconds: 500)).then((value) {
      nextScreenReplace(
        // ignore: use_build_context_synchronously
        context,
        MenuScreen(
          title: '',
          data: data,
          // idUser: int.parse(data['user_id']),
          // username: data['username'] ?? '',
          // firstname: data['first_name'] ?? '',
          // lastname: data['last_name'] ?? '',
          // provider: 'database',
          // picture: data['picture'] ?? '',
          // email: data['userEmail'] ?? ''
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Material(
          color: Colors.black,
          elevation: 2,
          shadowColor: Colors.grey,
          child: Container(
            color: Colors.black,
            height: MediaQuery.of(context).size.height * 0.6,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: advert(),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: logo(),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: pseudo(),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: password(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    cancelButton(),
                    const SizedBox(width: 10),
                    loginButton(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
    /******************* advertisiment *************************/
    /******************* LOGO **********************************/
  }

  /// ******************** Advert *********************************
  Row advert() {
    return Row(
      children: [
        Container(
          alignment: Alignment.bottomLeft,
          width: 40.0,
          height: 40.0,
          decoration: const BoxDecoration(
            shape: BoxShape.rectangle,
            image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage(
                'assets/images/logo.png',
              ),
              alignment: Alignment.topLeft,
            ),
          ),
        ),
        const Text(
          "pdvtex",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontStyle: FontStyle.italic,
            color: Colors.white38,
          ),
        ),
      ],
    );
  }
/***************************************************************/

  /// **************** TextField logo******************************
  Center logo() {
    return Center(
      child: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width >
                    MediaQuery.of(context).size.height
                ? MediaQuery.of(context).size.height / 5
                : MediaQuery.of(context).size.width / 5,
            height: MediaQuery.of(context).size.width >
                    MediaQuery.of(context).size.height
                ? MediaQuery.of(context).size.height / 5
                : MediaQuery.of(context).size.width / 5,
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border.all(
                style: BorderStyle.solid,
                strokeAlign: BorderSide.strokeAlignInside,
                color:
                    const Color.fromARGB(255, 107, 128, 141).withOpacity(0.9),
                width: 1,
              ),
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(6.0),
              image: const DecorationImage(
                  fit: BoxFit.fill, image: AssetImage('assets/images/log.gif')),
            ),
          ),
        ],
      ),
    );
  }
/***************************************************************/

  /// **************** TextField Pseudo****************************
  Container pseudo() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      decoration: BoxDecoration(
        color: Colors.black,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(6.0),
        gradient: const LinearGradient(colors: [
          Color.fromARGB(255, 36, 37, 41),
          Color.fromARGB(255, 15, 3, 3),
        ]),
      ),
      child: TextFormField(
        style: const TextStyle(color: Colors.white70),
        decoration: InputDecoration(
          alignLabelWithHint: true,
          floatingLabelStyle: const TextStyle(
            color: Colors.white70,
            fontSize: 18,
            fontStyle: FontStyle.italic,
          ),
          labelText: "usuário",
          labelStyle: TextStyle(
            color: Colors.grey.withOpacity(0.5),
            fontSize: 18,
          ),
          filled: true,
          fillColor: Colors.black,
          hintText: "Nome de usuário",
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
                color: Color.fromARGB(255, 124, 120, 120), width: 1.0),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueGrey, width: 1.0),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Colors.grey.withOpacity(0.5), width: 1.0),
          ),
          hintStyle: TextStyle(
            fontStyle: FontStyle.italic,
            decorationStyle: TextDecorationStyle.wavy,
            color: const Color.fromARGB(255, 158, 158, 158).withOpacity(0.5),
            fontSize: 14,
          ),
          suffixIcon: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.account_box_outlined,
              color: Colors.white38,
            ),
          ),
        ),
        controller: _pseudoController,
        onChanged: (value) {
          setState(() {
            _enabledPwd = (value.toString().length > 4);
          });
        },
      ),
    );
  }

/***************************************************************/

  /// ****************** TextField Password ***********************
  Container password() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      color: Colors.black.withOpacity(0.3),
      child: TextFormField(
        enabled: _enabledPwd,
        style: const TextStyle(color: Colors.white70),
        decoration: InputDecoration(
          alignLabelWithHint: true,
          floatingLabelStyle: const TextStyle(
            color: Colors.white70,
            fontSize: 18,
            fontStyle: FontStyle.italic,
          ),
          labelText: "Senha",
          labelStyle: TextStyle(
            color: Colors.grey.withOpacity(0.6),
            fontSize: 14,
          ),
          filled: true,
          fillColor: Colors.black,
          hintText: "Senha de acesso",
          hintStyle: TextStyle(
            decorationStyle: TextDecorationStyle.wavy,
            color: Colors.grey.withOpacity(0.3),
            fontSize: 14,
          ),
          // helperText: 'Senha de acesso',
          // helperStyle:
          //     TextStyle(color: Colors.grey.withOpacity(0.6), fontSize: 11),
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
                color: Color.fromARGB(255, 124, 120, 120), width: 1.0),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueGrey, width: 1.0),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Colors.grey.withOpacity(0.5), width: 1.0),
          ),
          suffixIcon: GestureDetector(
            child: IconButton(
              onPressed: () {
                setState(() {
                  _isSecured = !_isSecured;
                });
              },
              icon: Icon(
                Icons.lock_outline,
                color: Colors.grey.shade700,
              ),
            ),
            onLongPressStart: (_) async {
              setState(() {
                _isSecured = false;
              });
            },
            onLongPressCancel: () {
              //cancelPress();
            },
            onLongPressEnd: (_) {
              setState(() {
                _isSecured = true;
              });
            },
          ),
        ),
        obscureText: _isSecured,
        controller: _passwordController,
        onChanged: (value) => _enabledSend = value.toString().length > 4,
      ),
    );
  }
/***************************************************************/

  /// ******************Button Cancel *****************************
  ElevatedButton cancelButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white.withOpacity(0.5),
          alignment:
              AlignmentGeometry.lerp(Alignment.center, Alignment.center, 2),
          backgroundColor: Colors.black,
          minimumSize: const Size(120, 40),
          maximumSize: const Size(120, 40),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
          ),
          shadowColor: Colors.grey,
          elevation: 8),
      child: const AutoSizeText(
        'Cancelar',
        style: TextStyle(fontSize: 20),
        maxLines: 1,
      ),
      //Text('Cancelar'),
      onPressed: () async {
        _passwordController.clear();
        _pseudoController.clear();
        // Perform some action
        const SnackBar(
          content: Text("Login Cancelado"),
          backgroundColor: Colors.deepOrange,
        );
      },
    );
  }
/***************************************************************/

  /// ******************* Button Login*****************************
  ElevatedButton loginButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white.withOpacity(0.5),
          alignment:
              AlignmentGeometry.lerp(Alignment.center, Alignment.center, 5),
          backgroundColor: Colors.black,
          minimumSize: const Size(120, 40),
          maximumSize: const Size(120, 40),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
          ),
          shadowColor: Colors.grey,
          elevation: 8),
      child: const AutoSizeText(
        'Entrar',
        style: TextStyle(fontSize: 20),
        maxLines: 1,
      ),
      onPressed: () async {
        if (_enabledSend == false) {
          null;
        } else {
          await (String pseudo) async {
            var response = await http.get(
                Uri.parse(
                    "http://www.tiven.com.br/crud/Login.php?PSEUDO=$pseudo"),
                headers: {"Accept": "application/json"});

            if (response.contentLength! > 100) {
              print(response.body);
            }

            setState(() {
              var convertDataToJson = json.decode(response.body);
              data = convertDataToJson['result'];
              data = data[0];
            });
          }(_pseudoController.text);

          await VerifData(
              _pseudoController.text, _passwordController.text, data);
          // Perform some action
          const SnackBar(
            content: Text("Login de usuário"),
            backgroundColor: Colors.deepOrange,
          );
        }
      },
    );
  }

/**************************************************************/
}
