class Produto {
  final String codigo;
  final String categoria;
  final String catM;
  final String descricao;
  final String image;
  final double custo;
  final double valorVenda; 
  
  late int itemsCarr;

  Produto(this.codigo, this.categoria, this.catM, this.descricao, this.image, this.custo, this.valorVenda) {
    itemsCarr = 0;
  }

}

class Categoria {
  final String categoria;
  const Categoria(this.categoria);
}

class ShopCart {
  final String codigo;
  late int qtd;
  late double valorUnit;
  late double valorDesconto;
  late double valorTotal;

  ShopCart(this.codigo, this.qtd, this.valorUnit, this.valorDesconto, this.valorTotal);

}

class PaymentType {
  final String parametro;
  final String descricao;
  final double valor;

  const PaymentType(this.parametro, this.descricao, this.valor);
  
}
