import 'dart:convert';
import 'dart:io';

import 'package:e_surat_bendungan/config/api.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../config/fcm_service.dart';
import '../../config/models/users.dart';
import 'controller_shared_prefs.dart';

class ControllerLogin extends GetxController {
  final sharedPrefsController =
      Get.put(ControllerSharedPrefs(), permanent: true);
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();
  FcmService fcmService = FcmService();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  var isShow = true.obs;
  var isLoading = false.obs;
  var user = Rxn<Users>();
  var error = ''.obs;

  void showHidePassword() {
    isShow.value = !isShow.value;
  }

  Future<bool> login({String? noTelp, String? password}) async {
    isLoading(true);
    try {
      final response = await http.post(Uri.parse('${apiService}login'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'no_telepon': noTelp, 'password': password}));

      final responseBody = json.decode(response.body);
      // log(responseBody);
      int code = responseBody['meta']['code'];
      if (code == 200) {
        if (responseBody['meta']['status'] == 'success') {
          user.value = Users.fromJson(responseBody['data']['user']);
          await sharedPrefsController.saveUser(user.value!);
          String? token = await _firebaseMessaging.getToken();
          error.value = '';
          if (token != null) {
            await fcmService.sendTokenToServer(
                token); // Kirim token ke server dengan id_akun
            await sharedPrefsController.saveToken(token); // Simpan token lokal
          }
          return true;
        }
      } else if (code == 500) {
        error.value = 'password salah';
        return false;
      } else if (code == 400) {
        error.value = 'No telepon tidak terdaftar pada aplikasi';
        return false;
      } else if (code == 505) {
        error.value = 'user belum terverifikasi';
        user.value = Users.fromJson(responseBody['data']['user']);
        return false;
      }
    } on SocketException {
      error.value = 'Gagal Login Periksa koneksi internet';
      return false;
    } catch (e) {
      error.value = 'error : $e';
      return false;
    } finally {
      isLoading(false);
    }
    return false;
  }
}
