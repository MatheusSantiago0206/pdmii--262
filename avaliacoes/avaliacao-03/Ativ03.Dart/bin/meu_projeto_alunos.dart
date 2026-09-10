import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future<void> main() async {
  // Inicializa o suporte ao FFI do SQLite para terminal/desktop
  sqfliteFfiInit();
  var databaseFactory = databaseFactoryFfi;

  // Define o caminho do banco de dados na raiz do projeto
  String path = join(Directory.current.path, 'alunos.db');

  Database? db;

  try {
    print('Conectando e verificando o banco de dados em: $path\n');

    // 1, 2 e 3) Abre/Cria o banco de dados.
    // O callback 'onCreate' SÓ É EXECUTADO se o arquivo do banco não existir!
    db = await databaseFactory.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (Database db, int version) async {
          print('-> [1 e 2] Banco alunos.db não existia. Criando a tabela tb_alunos...');
          await db.execute('''
            CREATE TABLE tb_alunos (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              nome TEXT NOT NULL,
              idade INTEGER NOT NULL
            )
          ''');

          print('-> [3] Incluindo os 3 alunos iniciais...');
          List<Map<String, dynamic>> alunosParaInserir = [
            {'nome': 'João Silva', 'idade': 20},
            {'nome': 'Maria Oliveira', 'idade': 22},
            {'nome': 'Carlos Souza', 'idade': 21},
          ];

          for (var aluno in alunosParaInserir) {
            int id = await db.insert('tb_alunos', aluno);
            print('   Aluno "${aluno['nome']}" inserido com ID: $id');
          }
        },
      ),
    );

    // 4) Listar o conteúdo da tabela tb_alunos (executa SEMPRE)
    print('-> [4] Listando o conteúdo da tabela tb_alunos:');
    List<Map<String, dynamic>> registros = await db.query('tb_alunos');

    if (registros.isEmpty) {
      print('   Nenhum aluno encontrado.');
    } else {
      for (var linha in registros) {
        print('   [ID: ${linha['id']}] Nome: ${linha['nome']} | Idade: ${linha['idade']}');
      }
    }

  } catch (e) {
    // Tratamento de exceção de qualquer operação do banco
    print('Erro no banco de dados: $e');
  } finally {
    // Garante o fechamento da conexão ao terminar
    if (db != null && db.isOpen) {
      await db.close();
      print('\nConexão com o banco de dados encerrada.');
    }
  }
}