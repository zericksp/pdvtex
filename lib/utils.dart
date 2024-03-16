

String currencyValue(double value) {
  return 'R\$ ${value.toStringAsFixed(2).replaceFirst('.', ',')}';
}