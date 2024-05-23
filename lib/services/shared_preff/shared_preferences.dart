import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  Future<void> save(String key, String value) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(key, value);
      print("Data is saved in shared preferences.");
    } catch (e) {
      print("Error saving to SharedPreferences: $e");
      throw Exception('Failed to save preferences');
    }
  }

  Future<String?> load(String key) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString(key);
    } catch (e) {
      print("Error loading from SharedPreferences: $e");
      return null;
    }
  }

  Future<void> remove(String key) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(key);
    } catch (e) {
      print("Error removing from SharedPreferences: $e");
      throw Exception('Failed to remove preference');
    }
  }

  Future<void> saveCurrentAddress(String address) async {
    await save('current_address', address);
  }

  Future<String?> loadCurrentAddress() async {
    return await load('current_address');
  }

  Future<void> removeCurrentAddress() async {
    await remove('current_address');
  }
}
