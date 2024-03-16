import 'package:pdvtex/routers/cart_shop/cart_shop.dart';
import 'package:pdvtex/store/store_pdv.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SalesCardPDV extends StatelessWidget {
  const SalesCardPDV({super.key});

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<StorePdv>(context);
    return Card(
          color: Colors.black,
          margin: const EdgeInsets.all(5),
          child: Column(
            children: [
              ListTile(
                textColor: Colors.white,
                tileColor: Colors.black,
                title: Text('R\$ ${store.valorCarrinho.toStringAsFixed(2)}',),
                subtitle: Text('${store.totItensCarrinho} itens'),
                leading: const Icon(Icons.point_of_sale_rounded, color: Colors.white,),
                trailing: IconButton(
                  onPressed: () {
                    Navigator.push(
                    context, MaterialPageRoute(builder: (context) => const CartShop(idUser: '',)));
                    // Navigator.pushNamed(context, '/cart_shop');
                  },
                  icon: const Icon(Icons.shopping_bag_outlined, color: Colors.white,),
                ),
              )
            ],
          ),
    );
  }
}
