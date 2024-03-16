import 'package:pdvtex/store/store_pdv.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FilterCat extends StatelessWidget {
  const FilterCat({super.key});

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<StorePdv>(context);
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 0, //store.categorias.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                // store.activeFilter = store.categorias[index];
                // store.filterProducts(store.categorias[index]);
              },
              child: const Badge(
                label: Text('',
                  // store.categorias[index],
                ),
                backgroundColor: 
                //store.activeFilter != store.categorias[index]
                    //? 
                    //Colors.grey.shade400
                    Colors.blue,
              ),
            ),
          );
        });
  }
}
