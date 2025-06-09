import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalSecureData {
  // Iniciando o armazenamento seguro
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  // Função para salvar os dados seguramente
  static Future saveSecureData(String key, String value) async {
    var saveData = await _storage.write(key: key, value: value);
    return saveData;
  }

  // Função para ler os dados seguramente
  static Future readSecuredata(String key) async {
    var collectingData = await _storage.read(key: key);
    return collectingData;
  }

  // Função para deletar os dados 
  static Future deleteSecureData() async {
    var deleteData = await _storage.deleteAll();
    return deleteData;
  }
}
