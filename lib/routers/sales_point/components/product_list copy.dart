import 'package:pdvtex/store/store_pdv.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductList extends StatelessWidget {
  const ProductList({super.key});

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<StorePdv>(context);

    return ListView.builder(
      itemCount: store.produtosFilter.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: const CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage("assets/images/log.gif"),
          ),
          title: Text(store.produtosFilter[index].descricao, style: const TextStyle(color: Colors.white, fontStyle: FontStyle.italic, fontSize: 12, fontWeight: FontWeight.w500)),
          subtitle: Text(
              'R\$ ${store.produtosFilter[index].valorVenda.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white, fontStyle: FontStyle.italic, fontSize: 12, fontWeight: FontWeight.w300)),
          trailing: store.produtosFilter[index].itemsCarr > 0
              ? Text(
                  '${store.produtosFilter[index].itemsCarr} itens',
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w500),
                )
              : Text('${store.produtosFilter[index].itemsCarr} itens'),
          onTap: () {
            //store.incItem(store.produtosFilter[index].valor);
            store.addCarrinho(
                store.produtosFilter[index].codigo,
                1,
                store.produtosFilter[index].valorVenda,
                0,
                store.produtosFilter[index].valorVenda);
          },
        );
      },
    );
  }
}
