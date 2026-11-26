class Guitarra {
  final String id;
  final String modelo;
  final String marca;
  final String descricao;
  final double preco;
  final double avaliacao;
  final String imagemUrl;

  Guitarra({
    required this.id,
    required this.modelo,
    required this.marca,
    required this.descricao,
    required this.preco,
    required this.avaliacao,
    required this.imagemUrl,
  });

  factory Guitarra.fromJson(Map<String, dynamic> json) {
    // Pega a imagem em alta resolução (100x100 -> 300x300)
    String foto = (json['artworkUrl100'] ?? '')
        .toString()
        .replaceAll('100x100bb', '300x300bb');

    return Guitarra(
      id: (json['collectionId'] ?? json['trackId'] ?? 0).toString(),
      modelo: json['collectionName'] ?? json['trackName'] ?? 'Guitar Collection',
      marca: json['artistName'] ?? 'Guitar Artist',
      descricao: 'Gênero: ${json['primaryGenreName'] ?? 'Rock / Guitar'} • Faixas: ${json['trackCount'] ?? 10}',
      preco: (json['collectionPrice'] as num?)?.toDouble() ?? 19.99,
      avaliacao: 4.9,
      imagemUrl: foto,
    );
  }
}