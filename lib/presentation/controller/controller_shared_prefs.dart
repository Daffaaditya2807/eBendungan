import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../config/models/users.dart';

class ControllerSharedPrefs extends GetxController {
  static const String KEY_USER = 'user_data';
  static const String KEY_IS_LOGGED_IN = 'is_logged_in';
  static const String KEY_FCM_TOKEN = 'fcm_token'; // Kunci untuk token FCM

  var user = Rxn<Users>();
  var isLoggedIn = false.obs;

  Future<void> saveUser(Users userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(KEY_USER, jsonEncode(userData.toJson()));
    await prefs.setBool(KEY_IS_LOGGED_IN, true);
    user.value = userData;
    isLoggedIn.value = true;
  }

  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userStr = prefs.getString(KEY_USER);
    final logged = prefs.getBool(KEY_IS_LOGGED_IN) ?? false;

    if (userStr != null) {
      user.value = Users.fromJson(jsonDecode(userStr));
    }
    isLoggedIn.value = logged;
  }

  Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(KEY_USER);
    await prefs.setBool(KEY_IS_LOGGED_IN, false);
    user.value = null;
    isLoggedIn.value = false;
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(KEY_FCM_TOKEN, token);
  }

  Future<String?> getStoredToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(KEY_FCM_TOKEN);
  }

  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(KEY_FCM_TOKEN);
  }
}
