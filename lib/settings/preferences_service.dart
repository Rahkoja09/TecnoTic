import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const _keyHasLaunched = 'has_launched';

  Future<bool> isFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    final hasLaunched = prefs.getBool(_keyHasLaunched) ?? true;

    if (hasLaunched) {
      await prefs.setBool(_keyHasLaunched, false);
    }

    return hasLaunched;
  }
}
