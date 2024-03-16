// ignore_for_file: no_logic_in_create_state

import 'package:pdvtex/routers/cart_shop/components/List_prod_cart_shop.dart';
import 'package:pdvtex/routers/cart_shop/components/form_ticket.dart';
import 'package:pdvtex/routers/cart_shop/components/top_total.dart';
import 'package:flutter/material.dart';

class CartShop extends StatefulWidget {
final String idUser;

  const CartShop({super.key, required this.idUser});

  @override
  // ignore: library_private_types_in_public_api
  _CartShopState createState() =>
      _CartShopState(idUser: idUser);
}

class _CartShopState extends State<CartShop> {
  final String idUser;

  _CartShopState({required this.idUser});
    
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Carrinho de Compras', style: TextStyle(color: Colors.white,),),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white,),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.black,
            height: MediaQuery.of(context).size.width * 0.2,
            child: const Card(child: TopTotalCart()),
          ),
          Container(
            color: Colors.black,
            height: MediaQuery.of(context).size.width * 0.5,
            child: const Card(child: ListProdCartShop()),
          ),
          Container(
            color: Colors.black,
            height: MediaQuery.of(context).size.width * 0.57,
            child: const Card(
              child: FormTicket(),
            ),
          ),
          Container(
            color: Colors.black,
            height: MediaQuery.of(context).size.width * 0.1,
            child: ElevatedButton(
                onPressed: () {}, child: const Text('Finalizar Venda')),
          )
        ],
      ),
    );
  }
}
