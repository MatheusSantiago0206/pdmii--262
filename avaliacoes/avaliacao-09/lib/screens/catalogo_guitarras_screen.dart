import 'package:flutter/material.dart';
import '../models/guitarra.dart';
import '../services/guitarra_service.dart';

class CatalogoGuitarrasScreen extends StatefulWidget {
  const CatalogoGuitarrasScreen({super.key});

  @override
  State<CatalogoGuitarrasScreen> createState() => _CatalogoGuitarrasScreenState();
}

class _CatalogoGuitarrasScreenState extends State<CatalogoGuitarrasScreen> {
  final GuitarraService _service = GuitarraService();
  late Future<List<Guitarra>> _futureGuitarras;

  @override
  void initState() {
    super.initState();
    _futureGuitarras = _service.buscarGuitarras();
  }

  Future<void> _recarregarCatalogo() async {
    setState(() {
      _futureGuitarras = _service.buscarGuitarras();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.music_note),
            SizedBox(width: 8),
            Text('Guitar Store API'),
          ],
        ),
        backgroundColor: Colors.deepOrange.shade800,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Guitarra>>(
        future: _futureGuitarras,
        builder: (context, snapshot) {
          // 1. Estado de Carregamento
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.deepOrange.shade800),
                  const SizedBox(height: 16),
                  const Text('Afinando e carregando guitarras...'),
                ],
              ),
            );
          }

          // 2. Estado de Erro
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      snapshot.error.toString().replaceAll('Exception: ', ''),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange.shade800,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: _recarregarCatalogo,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Tentar Novamente'),
                    ),
                  ],
                ),
              ),
            );
          }

          // 3. Lista Vazia
          final guitarras = snapshot.data ?? [];
          if (guitarras.isEmpty) {
            return const Center(child: Text('Nenhuma guitarra encontrada.'));
          }

          // 4. Lista Carregada com Pull-to-Refresh
          return RefreshIndicator(
            color: Colors.deepOrange.shade800,
            onRefresh: _recarregarCatalogo,
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: guitarras.length,
              itemBuilder: (context, index) {
                final guitarra = guitarras[index];
                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.only(bottom: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        // Imagem da Guitarra vinda da API
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            guitarra.imagemUrl,
                            width: 90,
                            height: 90,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                              width: 90,
                              height: 90,
                              color: Colors.grey.shade300,
                              child: const Icon(Icons.music_off, size: 40),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        // Informações do Instrumento
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                guitarra.marca.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepOrange.shade700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                guitarra.modelo,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                guitarra.descricao,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'US\$ ${guitarra.preco.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      const Icon(Icons.star,
                                          size: 16, color: Colors.amber),
                                      const SizedBox(width: 4),
                                      Text(
                                        guitarra.avaliacao.toString(),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}