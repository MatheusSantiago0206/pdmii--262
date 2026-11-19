class Produto {
  final String id;
  final String nome;
  final double preco;
  final String icone; // Usaremos emojis para simplificar sem precisar de assets externos

  Produto({
    required this.id,
    required this.nome,
    required this.preco,
    required this.icone,
  });
}

class ItemCarrinho {
  final Produto produto;
  int quantidade;

  ItemCarrinho({
    required this.produto,
    this.quantidade = 1,
  });

  double get subtotal => produto.preco * quantidade;
}