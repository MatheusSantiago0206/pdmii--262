import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/produto.dart';
import '../providers/carrinho_provider.dart';
import 'carrinho_screen.dart';

class CatalogoScreen extends StatelessWidget {
  const CatalogoScreen({super.key});

  // Lista estática simulando produtos vindos de uma API
  static final List<Produto> _produtosDisponiveis = [
    Produto(id: 'p1', nome: 'Notebook Pro', preco: 4500.00, icone: '💻'),
    Produto(id: 'p2', nome: 'Smartphone X', preco: 2800.00, icone: '📱'),
    Produto(id: 'p3', nome: 'Fone Bluetooth', preco: 350.00, icone: '🎧'),
    Produto(id: 'p4', nome: 'Teclado Mecânico', preco: 420.00, icone: '⌨️'),
    Produto(id: 'p5', nome: 'Mouse Gamer', preco: 210.00, icone: '🖱️'),
    Produto(id: 'p6', nome: 'Monitor 4K', preco: 1950.00, icone: '🖥️'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo de Produtos'),
        actions: [
          // Consumer reconstrói APENAS este ícone quando o carrinho muda
          Consumer<CarrinhoProvider>(
            builder: (context, carrinho, child) {
              return IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CarrinhoScreen()),
                  );
                },
                icon: Badge(
                  label: Text('${carrinho.totalItens}'),
                  isLabelVisible: carrinho.totalItens > 0,
                  child: const Icon(Icons.shopping_cart),
                ),
              );
            },
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _produtosDisponiveis.length,
        itemBuilder: (context, index) {
          final produto = _produtosDisponiveis[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: Text(produto.icone, style: const TextStyle(fontSize: 32)),
              title: Text(
                produto.nome,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('R\$ ${produto.preco.toStringAsFixed(2)}'),
              trailing: ElevatedButton.icon(
                onPressed: () {
                  // context.read apenas executa a função sem escutar alterações
                  context.read<CarrinhoProvider>().adicionarProduto(produto);

                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${produto.nome} adicionado ao carrinho!'),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
                icon: const Icon(Icons.add_shopping_cart, size: 18),
                label: const Text('Adicionar'),
              ),
            ),
          );
        },
      ),
    );
  }
}