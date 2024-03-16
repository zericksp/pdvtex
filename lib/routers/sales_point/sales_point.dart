import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:pdvtex/models/models.dart';
import 'package:pdvtex/routers/sales_point/components/filter_cat.dart';
import 'package:pdvtex/routers/sales_point/components/product_list.dart';
import 'package:pdvtex/routers/sales_point/components/sales_card_pdv.dart';
import 'package:flutter/material.dart';
import 'dart:core';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

var controller = TextEditingController();
late String barcodeScanRes;
late String barcode;
var mykeyfocusNode = FocusNode();
List<ShopCart> carrinho = [];
List<ProductList> product_list = [];

class SalesPoint extends StatefulWidget {
  const SalesPoint({super.key});

  @override
  State<SalesPoint> createState() => _SalesPointState();
}

class _SalesPointState extends State<SalesPoint> {
  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('pdVTex - Ponto de Venda',
            style: TextStyle(color: Colors.white, fontSize: 20)),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 4),
            height: 85,
            width: double.infinity,
            child: const SalesCardPDV(),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 2, 0, 4),
            height: 40,
            width: double.infinity,
            child: const FilterCat(),
          ),
          const Expanded(
            child: SizedBox(
              width: double.infinity,
              child: 
//               TextField(
//                 style: const TextStyle(
//                   fontSize: 30,
//                   color: Colors.white,
//                 ),
//                 textAlign: TextAlign.center,
//                 maxLines: 1,
//                 onChanged: (context) async {
//                   //print(myController.text);
//                   // await getProd (myController.text);
//                 },
//                 onTap: () async {
//                   await scanBarcodeNormal();
//                   barcodeScanRes = barcode.toString();
//                   if (barcodeScanRes.length == 13) {
//                     controller.text = barcodeScanRes.toString();
//                     barcode = controller.text;
//                     // dialog();
//                     //controller.clear();
//                     setState(
//                       () {
//                         barcodeScanRes = '';
//                       },
//                     );
//                     FocusScope.of(context).requestFocus(mykeyfocusNode);
//                     // Navigator.of(context).pop();
//                     // return;
//                   }
//                   barcode = '';
//                 },

//                 focusNode: mykeyfocusNode,
//                 autofocus: true,
//                 decoration: InputDecoration(
//                   hintText: 'Informe SKU, descrição ou EAN',
//                   border: const OutlineInputBorder(
//                     borderSide: BorderSide(
//                         color: Color.fromARGB(255, 236, 234, 234), width: 1.0),
//                   ),
//                   enabledBorder: const OutlineInputBorder(
//                     borderSide: BorderSide(color: Colors.red, width: 1.0),
//                   ),
//                   disabledBorder: const OutlineInputBorder(
//                     borderSide: BorderSide(color: Colors.red, width: 1.0),
//                   ),
//                   helperText: 'Pesquisar (SKU / EAN / Descrição)',
//                   hintStyle: const TextStyle(fontSize: 20),
//                   labelText: 'Produto',
//                   prefixIcon: const Icon(
//                     Icons.chrome_reader_mode,
//                     color: Colors.white,
//                   ),
//                   suffixIcon: IconButton(
//                     onPressed: () => controller.clear(),
//                     icon: Icon(
//                       Icons.delete,
//                       color: Colors.white.withOpacity(0.9),
//                     ),
//                   ),
//                   suffixStyle: const TextStyle(
//                       color: Color.fromARGB(255, 100, 152, 201)),
//                 ),
//                 controller: controller,
//                 onSubmitted: (value) {
//                   setState(
//                     () {
//                       barcode = controller.text;
//                     },
//                   );
//                   controller.clear();
//                   FocusScope.of(context).requestFocus(mykeyfocusNode);
//                   // return;
// //            setState(() {
//                 },
//                 textInputAction: TextInputAction.done,
//                 keyboardType: TextInputType.text,
//                 inputFormatters: <TextInputFormatter>[
//                   FilteringTextInputFormatter.digitsOnly
//                 ], // Only numbers can be entered
//               ),
              ProductList(),
            ),
          ),
          
        ],
      ),
    );
  }

  Future<void> scanBarcodeNormal() async {
    // ignore: unused_local_variable
    try {
      barcodeScanRes = (await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancelar", true, ScanMode.BARCODE));
      barcode = barcodeScanRes;
      if(barcodeScanRes.length == 13){
        // var product = await getVTexProduct(barcode);
       /* store.addCarrinho(
                store.produtosFilter[index].codigo,
                1,
                store.produtosFilter[index].valorVenda,
                0,
                store.produtosFilter[index].valorVenda);

                */
       // store.addCarrinho.add(211, 1, 2.50, 0, 2.50);
      }
    } on PlatformException {
      barcodeScanRes = 'Falha ao verificar versão da plataforma.';
    }
  }

Future getVTexProduct(barcode) async{

  var url = Uri.https('eladecora.vtexcommercestable.com.br', '/api/catalog_system/pvt/sku/stockkeepingunitbyean/7896497809973');
 var headers = {
   'x-vtex-api-appkey': 'vtexappkey-eladecora-GPJUBS',
   'x-vtex-api-apptoken': 'AMGRCAJBWNYVFTGOZFJDKXLUQEQRPMXVRSFEVXMEGNNIHEONGMGWAATCAMBYKSLJQDENOCSCTEWWJCNMQDKDFAUQZCDJWOUOCDRDZBZETEDWDWSYZOHGHIEQJNNLYJGE',
   'Cookie': 'janus_sid=d178e6f3-a7ec-43e8-9011-d87ce86e76ee'
 };

  var response = await http.get(url, headers: headers);
  var data = utf8.decode(response.bodyBytes);
  if (kDebugMode) {
    print(data);
  }
  return data;
}
}