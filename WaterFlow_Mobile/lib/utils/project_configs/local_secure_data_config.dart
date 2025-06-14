import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waterflow_mobile/modules/login/controllers/login_screen_controller.dart';

class LocalSecureData {
  // Initializing secure storage
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  // Importing the Login controller
  static final LoginScreenController _loginScreenController =
      Get.find<LoginScreenController>();

  // Function to save data securely
  static Future saveSecureData(String key, String value) async {
    var saveData = await _storage.write(key: key, value: value);
    return saveData;
  }

  // Function to read data securely
  static Future readSecuredata(String key) async {
    var collectingData = await _storage.read(key: key);
    return collectingData;
  }

  // Function to delete the data
  static Future deleteSecureData() async {
    var deleteData = await _storage.deleteAll();
    return deleteData;
  }

  // Function to save data on the device
  static Future<bool?> saveData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    bool result = await prefs.setString(
      'LocalSave',
      jsonEncode(
        {_loginScreenController.stayConnected.value},
      ),
    );
    return result;
  }

  // Function to remove data from the device
  static Future<bool> removeLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool data = await prefs.remove('LocalSave');
    _loginScreenController.stayConnected.value = false;
    return data;
  }
}
