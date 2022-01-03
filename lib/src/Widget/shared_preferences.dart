import 'package:shared_preferences/shared_preferences.dart';

class SP {
  SharedPreferences? prefs;

  Future<void> setPref(String key, value) async {
    prefs = await SharedPreferences.getInstance();
    if(value is String) {
      await prefs!.setString(key, value);
    }
    else if(value is int) {
      await prefs!.setInt(key, value);
    }
  }

  Future<String?> getSPref(String key) async {
    prefs = await SharedPreferences.getInstance();
    return prefs!.getString(key);
  }

  Future<int?> getIPref(String key) async {
    prefs = await SharedPreferences.getInstance();
    return prefs!.getInt(key);
  }

}