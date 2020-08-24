import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> clearSecureStorageOnReinstall() async {
  const key = 'hasRunBefore';
  var prefs = await SharedPreferences.getInstance();

  if (!prefs.containsKey(key)) {
    var storage = FlutterSecureStorage();
    await storage.deleteAll();
    await prefs.setBool(key, true);
  }
}
