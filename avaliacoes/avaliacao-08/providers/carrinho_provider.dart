import 'package:flutter/foundation.dart';
import '../models/produto.dart';

class CarrinhoProvider extends ChangeNotifier {
  // Mapa privado onde a chave é o ID do produto
  final Map<String, ItemCarrinho> _itens = {};

  // Getter para expor os itens sem permitir modificação direta fora da classe
  Map<String, ItemCarrinho> get itens => {..._itens};

  // Retorna a quantidade total de itens somando as unidades
  int get totalItens {
    int total = 0;
    _itens.forEach((key, item) {
      total += item.quantidade;
    });
    return total;
  }

  // Calcular o valor financeiro total do carrinho
  double get valorTotal {
    double total = 0.0;
    _itens.forEach((key, item) {
      total += item.subtotal;
    });
    return total;
  }

  // Adiciona um produto ou incrementa sua quantidade
  void adicionarProduto(Produto produto) {
    if (_itens.containsKey(produto.id)) {
      _itens.update(
        produto.id,
        (itemExistente) => ItemCarrinho(
          produto: itemExistente.produto,
          quantidade: itemExistente.quantidade + 1,
        ),
      );
    } else {
      _itens.putIfAbsent(
        produto.id,
        () => ItemCarrinho(produto: produto, quantidade: 1),
      );
    }
    notifyListeners(); // Notifica a interface para redesenhar
  }

  // Diminui uma unidade; se chegar a zero, remove o item
  void removerUnidade(String produtoId) {
    if (!_itens.containsKey(produtoId)) return;

    if (_itens[produtoId]!.quantidade > 1) {
      _itens.update(
        produtoId,
        (itemExistente) => ItemCarrinho(
          produto: itemExistente.produto,
          quantidade: itemExistente.quantidade - 1,
        ),
      );
    } else {
      _itens.remove(produtoId);
    }
    notifyListeners();
  }

  // Remove o produto completamente do carrinho
  void removerProdutoCompleto(String produtoId) {
    _itens.remove(produtoId);
    notifyListeners();
  }

  // Esvazia o carrinho (ex: após finalizar compra)
  void limparCarrinho() {
    _itens.clear();
    notifyListeners();
  }
}