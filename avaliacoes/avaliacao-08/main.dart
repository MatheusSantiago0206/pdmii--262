import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/carrinho_provider.dart';
import 'screens/catalogo_screen.dart';

void main() {
  runApp(const MeuApp());
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    // O ChangeNotifierProvider disponibiliza o estado para toda a árvore de widgets abaixo dele
    return ChangeNotifierProvider(
      create: (context) => CarrinhoProvider(),
      child: MaterialApp(
        title: 'Loja Flutter',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
          useMaterial3: true,
        ),
        home: const CatalogoScreen(),
      ),
    );
  }
}