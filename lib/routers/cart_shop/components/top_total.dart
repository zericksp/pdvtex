import 'package:flutter/material.dart';
import 'package:pdvtex/store/store_pdv.dart';
import 'package:provider/provider.dart';
import '../../../utils.dart';

class TopTotalCart extends StatelessWidget {
  const TopTotalCart({super.key});

  @override
  Widget build(BuildContext context) {

    final store = Provider.of<StorePdv>(context);

    String formatTotItensCart(int totItens) {
      if (totItens == 1 || totItens == 0) {
        return '$totItens item';
      } else {
        return '$totItens items';
      }
    }

    return Container(
                
                decoration: BoxDecoration(border: Border.all(
                style: BorderStyle.solid,
                strokeAlign: BorderSide.strokeAlignInside,
                width: 1,
                ),
                color: Colors.black,),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              ' ${currencyValue(store.valorCarrinho)}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              formatTotItensCart(store.totItensCarrinho),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
