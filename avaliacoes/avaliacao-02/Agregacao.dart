import 'dart:convert';

class Dependente {
  late String _nome;

  Dependente(String nome) {
    this._nome = nome;
  }

  Map<String, dynamic> toJson() {
    return {'nome': _nome};
  }
}

class Funcionario {
  late String _nome;
  late List<Dependente> _dependentes;

  Funcionario(String nome, List<Dependente> dependentes) {
    this._nome = nome;
    this._dependentes = dependentes;
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': _nome,
      'dependentes': _dependentes.map((d) => d.toJson()).toList(),
    };
  }
}

class EquipeProjeto {
  late String _nomeProjeto;
  late List<Funcionario> _funcionarios;

  EquipeProjeto(String nomeprojeto, List<Funcionario> funcionarios) {
    _nomeProjeto = nomeprojeto;
    _funcionarios = funcionarios;
  }

  Map<String, dynamic> toJson() {
    return {
      'nomeProjeto': _nomeProjeto,
      'funcionarios': _funcionarios.map((f) => f.toJson()).toList(),
    };
  }
}

void main() {
  // 1. Criar varios objetos Dependentes
  Dependente dependente1 = Dependente('João');
  Dependente dependente2 = Dependente('Maria');
  Dependente dependente3 = Dependente('Pedro');
  Dependente dependente4 = Dependente('Ana');

  // 2. Criar varios objetos Funcionario
  // 3. Associar os Dependentes criados aos respectivos funcionarios
  Funcionario funcionario1 = Funcionario('Carlos', [dependente1, dependente2]);

  Funcionario funcionario2 = Funcionario('Fernanda', [dependente3]);

  Funcionario funcionario3 = Funcionario('Roberto', [dependente4]);

  // 4. Criar uma lista de Funcionarios
  List<Funcionario> funcionarios = [funcionario1, funcionario2, funcionario3];

  // 5. Criar um objeto EquipeProjeto chamando o construtor
  //    que da nome ao projeto e insere uma coleção de funcionarios
  EquipeProjeto equipeProjeto = EquipeProjeto('Projeto Flutter', funcionarios);

  // 6. Printar no formato JSON o objeto EquipeProjeto
  String json = jsonEncode(equipeProjeto.toJson());

  print(json);
}
