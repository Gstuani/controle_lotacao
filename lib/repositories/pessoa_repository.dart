import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:controle_lotacao/models/pessoa.dart';

const pessoaListKey = 'lista_pessoas';

class PessoaRepository {
  Future<List<Pessoa>> getListaPessoas() async {
    final preferences = await SharedPreferences.getInstance();
    final jsonString = preferences.getString(pessoaListKey) ?? '[]';
    final List jsonDecoded = json.decode(jsonString) as List;
    return jsonDecoded.map((e) => Pessoa.fromJson(e)).toList();
  }

  Future<void> saveListaPessoas(List<Pessoa> pessoas) async {
    final jsonString = json.encode(pessoas);
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(pessoaListKey, jsonString);
  }
}
