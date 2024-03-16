import 'package:flutter/material.dart';
import 'package:pdvtex/store/store_pdv.dart';
import 'package:provider/provider.dart';
import '../../../utils.dart';
import 'package:pdvtex/models/models.dart';

class ListProdCartShop extends StatelessWidget {
  const ListProdCartShop({super.key});

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<StorePdv>(context);

    String productNameByCod(String cod) {
      for (Produto item in store.produtos) {
        if (item.codigo == cod) {
          return item.descricao;
        }
      }
      return "Produto não encontrado";
    }

    String itemDescStr(
        int qtd, double valorUnit, double valorDesconto, double valorTotal) {
      if (valorDesconto > 0) {
        return '';
      } else {
        return '0$qtd X ${currencyValue(valorUnit)} = ${currencyValue(valorTotal)}';
      }
    }

    return ListView.builder(

      itemCount: store.carrinho.length,
      itemBuilder: (context, i) {
        return ListTile(
          tileColor: Colors.black,
          title: Text(productNameByCod(store.carrinho[i].codigo),style: const TextStyle(color: Colors.white,),),
          subtitle: Text(
            itemDescStr(
              store.carrinho[i].qtd,
              store.carrinho[i].valorUnit,
              store.carrinho[i].valorDesconto,
              store.carrinho[i].valorTotal,
            ),
            style: const TextStyle(color: Colors.white,),
          ),
          trailing: IconButton(
            onPressed: () {
              store.removeCarrinho(store.carrinho[i].codigo);
            },
            icon: const Icon(Icons.delete),
            color: const Color.fromARGB(255, 250, 20, 3),
          ),
        );
        // return Text(
        //     '${store.carrinho[i].codigo} - ${store.carrinho[i].qtd} - ${store.carrinho[i].valorTotal}');
      },
    );
  }
}
