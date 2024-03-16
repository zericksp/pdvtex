import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:pdvtex/models/models.dart';
import 'package:pdvtex/store/store_pdv.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  var controller = TextEditingController();
  late String barcodeScanRes;
  late String barcode;
  var mykeyfocusNode = FocusNode();
  List<Produto> produtos = [];

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<StorePdv>(context);

    return ListView.builder(
      itemCount: 1, // store.produtosFilter.length,
      itemBuilder: (context, index) {
        return TextField(
          style: const TextStyle(
            fontSize: 30,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          onChanged: (context) async {
            //print(myController.text);
            // await getProd (myController.text);
          },
          onTap: () async {
            await scanBarcodeNormal();
            barcodeScanRes = barcode.toString();
            if (barcodeScanRes.length == 13) {
              controller.text = barcodeScanRes.toString();
              barcode = controller.text;

              if(barcode.length == 13){
                var product = await getVTexProductByEan(barcode);
                var produto = jsonDecode(product);
                String sku = produto['ProductRefId'];
                product  = await getVTexProductBySku(sku);
                produto = jsonDecode(product);

                double price = produto[0]['items'][0]['sellers'][0]['commertialOffer']['ListPrice'];
                String image = produto[0]['items'][0]['images'][0]['imageUrl'];
                store.addCarrinho(produto[0]['productId'].toString(), 1, price, 0, price);
                store.addProduto(produto[0]['productId'].toString(), produto[0]['categories'][0], produto[0]['categoryId'], produto[0]['productName'], image, price, price);

                // produtos.add(produto[0]['productId'], "PÃO FRANCES", "PF", "PACOTE PÃO FRANCES 03 UNID.", 'log.gif', 3.88, 13.90);

                // store.produtosFilter[index].codigo,
                // 1,
                // store.produtosFilter[index].valorVenda,
                // 0,
                // store.produtosFilter[index].valorVenda);
              
              
              
              }
              // dialog();
              controller.clear();
              setState(
                () {
                  barcodeScanRes = '';
                },
              );
              FocusScope.of(context).requestFocus(mykeyfocusNode);
              // Navigator.of(context).pop();
              // return;
            }
            barcode = '';
          },

          focusNode: mykeyfocusNode,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Informe SKU, descrição ou EAN',
            border: const OutlineInputBorder(
              borderSide: BorderSide(
                  color: Color.fromARGB(255, 236, 234, 234), width: 1.0),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 1.0),
            ),
            disabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 1.0),
            ),
            helperText: 'Pesquisar (SKU / EAN / Descrição)',
            hintStyle: const TextStyle(fontSize: 20),
            labelText: 'Produto',
            prefixIcon: const Icon(
              Icons.chrome_reader_mode,
              color: Colors.white,
            ),
            suffixIcon: IconButton(
              onPressed: () => controller.clear(),
              icon: Icon(
                Icons.delete,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
            suffixStyle:
                const TextStyle(color: Color.fromARGB(255, 100, 152, 201)),
          ),
          controller: controller,
          onSubmitted: (value) {
            setState(
              () {
                barcode = controller.text;
              },
            );
            controller.clear();
            FocusScope.of(context).requestFocus(mykeyfocusNode);
            // return;
//            setState(() {
          },
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.text,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ], // Only numbers can be entered
        );
      },
    );
  }

Future getVTexProductByEan(barcodes) async{
var url = Uri.https('eladecora.vtexcommercestable.com.br', '/api/catalog_system/pvt/sku/stockkeepingunitbyean/$barcodes');
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


// https://eladecora.myvtex.com/api/catalog_system/pub/products/search/LF-1120

Future getVTexProductBySku(sku) async{
var url = Uri.https('eladecora.myvtex.com', '/api/catalog_system/pub/products/search/$sku');
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

  Future<void> scanBarcodeNormal() async {
    // ignore: unused_local_variable
    try {
      barcodeScanRes = (await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancelar", true, ScanMode.BARCODE));
      barcode = barcodeScanRes;
      // if (barcodeScanRes.length == 13) {
      //   var product = await getVTexProduct(barcode);
      //   /* store.addCarrinho(
      //           store.produtosFilter[index].codigo,
      //           1,
      //           store.produtosFilter[index].valorVenda,
      //           0,
      //           store.produtosFilter[index].valorVenda);

      //           */
      //   // store.addCarrinho.add(211, 1, 2.50, 0, 2.50);
      // }
    } on PlatformException {
      barcodeScanRes = 'Falha ao verificar versão da plataforma.';
    }
  }
}
