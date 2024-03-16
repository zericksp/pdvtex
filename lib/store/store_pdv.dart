import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/models.dart';
import 'package:http/http.dart' as http;

class StorePdv extends ChangeNotifier {
  StorePdv() {
    loadListProducts();
    filterProducts(activeFilter);
    loadCategory();

  }  

  // Variáveis Gerais de controle
  String activeFilter = 'TODOS';

  // Variáveis referentes ao carrinho
  double valorCarrinho = 0;
  int totItensCarrinho = 0;

  // Variáveis referentes ao Produto
  List<Produto> produtos = [];
  List<String> categorias = ['TODOS'];
  List<ShopCart> carrinho = [];
  List<Produto> produtosFilter = [];

  // Variáveis referente ao TICKET
  String tipoVenda = 'B';
  void changeTipoVenda(int index) {
    tipoVenda = (index == 0) ? 'B' : 'E';
  }
  //------------------------------------
  DateTime dataPedido = DateTime.now();
  //----------------------------------------
  String tipoPagto = 'PIX';
  double multTaxaCartao = 1;
  void changeTipoPagto(String value) {
    tipoPagto = value;
    switch (tipoPagto) {
      case 'PIX':
        multTaxaCartao = 1;
        break;
      case 'DIN':
        multTaxaCartao = 1;
        break;
      case 'DEB1':
        multTaxaCartao = 0.0138;
        break;
      case 'CRED1':
        multTaxaCartao = 0.0316;
        break;
      case 'CRED1L':
        multTaxaCartao = 0.0316;
        break;
      case 'DEB2':
        multTaxaCartao = 0.0190;
        break;
      case 'CRED2':
        multTaxaCartao = 0.049;
        break;
      case 'CRED2L':
        multTaxaCartao = 0.049;
        break;

      default:
    }
  }


void addCarrinho(String codigo, int qtd, double valorUnit,
  double valorDesconto, double valorTotal) {
  // Vemos se já tem desse produto no carrinho

  // Verifica se o item já está no carrinho

  if (carrinho.any((element) => element.codigo == codigo)) {
    for (ShopCart item in carrinho) {
      if (item.codigo == codigo) {
        item.qtd += qtd;
        item.valorTotal += valorTotal;
      }
    }
  } else {
    carrinho.add(ShopCart(codigo, qtd, valorUnit, valorDesconto, valorTotal));
  }

  // Totalizadores
  totItensCarrinho = carrinho.map((item) => item.qtd).reduce((v, e) => v + e);
  valorCarrinho =
      carrinho.map((item) => item.valorTotal).reduce((v, e) => v + e);

  for (Produto item in produtos) {
    if (item.codigo == codigo) {
      item.itemsCarr++;
    }
  }

  notifyListeners();
}

void addProduto(String codigo, String categories, String categoryId,
  String description, String image, double cust, double price) {
  // if (produtos.any((element) => element.codigo != codigo)) {
       produtos.add(Produto(codigo, categories, categoryId, description, image, cust, price));
  // }
  // for (Produto item in produtos) {
  //   if (item.codigo != codigo) {
  //       produtos.add(Produto(codigo, categories, categoryId, description, image, cust, price));
  //   }
  // }
  notifyListeners();
}

  void removeCarrinho(String cod) {
    for (int i = 0; i < carrinho.length; i++) {
      ShopCart item = carrinho[i];
      if (item.codigo == cod) {
        if (item.qtd == 1) {
          carrinho.removeAt(i); // Removendo o item da lista
        } else {
          item.qtd--;
          item.valorTotal = (item.qtd * item.valorUnit) - item.valorDesconto;
        }
        break; // Interrompe o loop após encontrar e lidar com o item
      }
    }

    // Totalizadores
    totItensCarrinho = carrinho.map(
      (item) => item.qtd
    ).reduce((v, e) => v + e);
    
    valorCarrinho = carrinho.map(
      (item) => item.valorTotal
    ).reduce((v, e) => v + e);

    notifyListeners();
  }

  void filterProducts(String activeFilter) {
    if (activeFilter == 'TODOS') {
      produtosFilter = produtos;
    } else {
      produtosFilter = produtos
          .where((element) => element.categoria == activeFilter)
          .toList();
    }
    notifyListeners();
  }

  void loadCategory() {
    categorias +=
        (produtos.map((produto) => produto.categoria).toSet()).toList();
    notifyListeners();
  }

void loadListProducts(){
// var headers = {'Cookie': 'janus_sid=d178e6f3-a7ec-43e8-9011-d87ce86e76ee'};
// var request = http.Request('GET', Uri.parse('https://eladecora.vtexcommercestable.com.br/api/catalog_system/pub/products/search?page=1&perPage=50'));
// request.headers.addAll(headers);
// http.StreamedResponse response = await request.send();

// if (response.statusCode == 200) {
//       final List<dynamic> jsonData = json.decode(response.toString());
//       return jsonData.map((json) => Produto.fromJson(json)).toList();
//     } else {
//       throw Exception('Failed to load products');
//     }
  
  // produtos.add(Produto("PAOT-001", "PÃO FRANCES", "PF",
  //       "PACOTE PÃO FRANCES 03 UNID.", 'log.gif', 3.88, 13.90));
  //   produtos.add(Produto("PAOT-002", "PÃO FRANCES", "PF",
  //       "PACOTE DE BAGUETE 02 UNID.", 'log.gif', 4.01, 17.90));
  //   produtos.add(Produto("PAOT-003", "PÃO FRANCES", "PF",
  //       "PACOTE DE PÃO DE HAMBURGUER 02 UNID.", 'log.gif', 2.68, 14.90));
  //   produtos.add(Produto(
  //       "BROW-001", "BROWNIES", "BW", "BROWNIE CHOCOLATE", 'log.gif', 3.32, 12.90));
  //   produtos.add(
  //       Produto("BROW-002", "BROWNIES", "BW", "TORTA BROWNIE FATIA", 'log.gif', 0, 15.90));
  //   produtos.add(Produto("BROW-003", "BROWNIES", "BW",
  //       "BROWNIE CHOCOLATE SENSAÇÃO", 'log.gif', 5.00, 17.90));
  //   produtos.add(Produto(
  //       "BOLO-001", "BOLOS", "BL", "BOLO DE CENOURA CASEIRINHO", 'log.gif', 6.81, 25.90));
  //   produtos.add(Produto("BOLO-101", "BOLOS", "BL",
  //       "FATIA DE BOLO DE CENOURA COM CHOCOLATE", 'log.gif', 5.59, 17.90));
  //   produtos.add(Produto(
  //       "BOLO-002", "BOLOS", "BL", "BOLO DE PAÇOCA CASEIRINHO", 'log.gif', 5.20, 23.90));
  //   produtos.add(Produto(
  //       "BOLO-003", "BOLOS", "BL", "BOLO DE MILHO CASEIRINHO", 'log.gif', 6.63, 23.90));
  //   produtos.add(Produto("BOLO-004", "BOLOS", "BL",
  //       "BOLO DE CHOCOLATE CASEIRINHO", 'log.gif', 6.52, 25.90));
  //   produtos.add(Produto("BOLO-005", "BOLOS", "BL",
  //       "BOLO DE CHOCOLATE COM COBERTURA REDONDO", 'log.gif', 15.47, 45.90));
  //   produtos.add(Produto(
  //       "BOLO-006", "BOLOS", "BL", "BOLO DE CENOURA REDONDO", 'log.gif', 13.79, 45.90));
  //   produtos.add(Produto(
  //       "BOLO-007", "BOLOS", "BL", "BOLO DE PAÇOCA REDONDO", 'log.gif', 8.66, 36.90));
  //   produtos.add(Produto(
  //       "BOLO-008", "BOLOS", "BL", "BOLO DE LARANJA CASEIRINHO", 'log.gif', 7.19, 23.90));
  //   produtos.add(Produto("BOLO-009", "BOLOS", "BL",
  //       "BOLO DE LARANJA COM COBERTURA REDONDO", 'log.gif', 12.74, 36.90));
  //   produtos.add(Produto("BOLO-010", "BOLOS", "BL",
  //       "BOLO PISCINA COM MORANGOS E GANACHE", 'log.gif', 29.17, 119.90));
  //   produtos.add(Produto(
  //       "BOLO-011", "BOLOS", "BL", "BOLO NEGA MALUCA CASEIRINHO", 'log.gif', 6.52, 25.90));
  //   produtos.add(
  //       Produto("BOLO-012", "BOLOS", "BL", "GUIRLANDA BROWNIE", 'log.gif', 41.86, 139.90));
  //   produtos.add(Produto(
  //       "BOLO-013", "BOLOS", "BL", "GUIRLANDA BROWNIE PEDAÇO", 'log.gif', 5.23, 10.00));
  //   produtos
  //       .add(Produto("BOLO-014", "BOLOS", "BL", "BOLO DE FUBA", 'log.gif', 11.52, 36.90));
  //   produtos.add(
  //       Produto("BOLO-015", "BOLOS", "BL", "BOLO FORMIGUEIRO", 'log.gif', 13.04, 36.90));
  //   produtos.add(Produto("TORT-001", "TORTAS", "TT",
  //       "TORTA DE CENOURA COM BRIGADEIRO (PEDAÇO)", 'log.gif', 5.59, 21.90));
  //   produtos.add(Produto("TORT-002", "TORTAS", "TT",
  //       "TORTA MOUSSE DE CHOCOLATE (PEDAÇO)", 'log.gif', 6.17, 23.90));
  //   produtos.add(Produto("TORT-003", "TORTAS", "TT",
  //       "TORTA DE ABACAXI COM COCO (PEDAÇO)", 'log.gif', 6.63, 21.90));
  //   produtos.add(Produto("TORT-004", "TORTAS", "TT",
  //       "TORTA MOUSSE DE MARACUJÁ (PEDAÇO)", 'log.gif', 7.50, 24.90));
  //   produtos.add(Produto("TORT-006", "TORTAS", "TT",
  //       "TORTA MOUSSE DE CHOCOLATE (INTEIRA)", 'log.gif', 47.42, 189.90));
  //   produtos.add(Produto("TORF-001", "TORTAS", "TT",
  //       "TORTA FRIA DE FRANGO COM MILHO", 'log.gif', 23.46, 94.90));
  //   produtos.add(Produto(
  //       "PAOF-001", "PÃO DE FORMA", "PF", "PÃO DE ERVAS FINAS", 'log.gif', 7.83, 26.90));
  //   produtos.add(Produto(
  //       "PAOF-002", "PÃO DE FORMA", "PF", "PÃO DE ABÓBORA", 'log.gif', 7.78, 26.90));
  //   produtos.add(Produto("PAOF-003", "PÃO DE FORMA", "PF",
  //       "PÃO DE BATATA DOCE E CHIA", 'log.gif', 7.87, 26.90));
  //   produtos.add(Produto("PAOF-004", "PÃO DE FORMA", "PF",
  //       "PÃO DE TOMATE SECO E ERVAS", 'log.gif', 11.90, 32.90));
  //   produtos.add(Produto(
  //       "PAOF-005", "PÃO DE FORMA", "PF", "PÃO MULTIGRÃOS", 'log.gif', 8.52, 32.90));
  //   produtos.add(Produto(
  //       "PAOF-006", "PÃO DE FORMA", "PF", "PÃO AUSTRALIANO", 'log.gif', 9.84, 32.90));
  //   produtos.add(
  //       Produto("PAOF-007", "PÃO DE FORMA", "PF", "PÃO DE MILHO", 'log.gif', 7.68, 26.90));
  //   produtos.add(Produto("TORP-001", "TORTA NO POTE", "TT",
  //       "TORTA DE CENOURA COM CHOCOLATE", 'log.gif', 0, 24.90));
  //   produtos
  //       .add(Produto("CUCA-001", "CUCA", "CC", "CUCA DE BANANA", 'log.gif', 7.04, 24.90));
  //   produtos
  //       .add(Produto("CUCA-002", "CUCA", "CC", "CUCA DE CHOCOLATE", 'log.gif', 0, 25.90));
  //   produtos.add(
  //       Produto("CUCA-003", "CUCA", "CC", "CUCA DE GOIABADA", 'log.gif', 7.61, 23.90));
  //   produtos.add(Produto("CUCA-004", "CUCA", "CC", "CUCATONE", 'log.gif', 6.11, 23.90));
    notifyListeners();
  }

  void incItem(double valor) {
    valorCarrinho += valor;
    totItensCarrinho++;
    notifyListeners();
  }
}
