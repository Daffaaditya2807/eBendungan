import 'dart:convert';

import 'package:e_surat_bendungan/config/api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'controller_shared_prefs.dart';

class ControllerUbahSandi extends GetxController {
  TextEditingController controllerSandiOld = TextEditingController();
  TextEditingController controllerSandiNew = TextEditingController();
  TextEditingController controllerConfirmSandi = TextEditingController();
  final sharedPrefsController = Get.find<ControllerSharedPrefs>();

  var isLoading = false.obs;
  var errorMessage = ''.obs;

  Future<void> updatePassword(
      {String? oldPassword,
      String? newPassword,
      String? confirmPassword}) async {
    if (newPassword == confirmPassword) {
    } else {
      errorMessage.value = 'password baru dan konfirmasi password tidak sama';
    }
    try {
      isLoading(true);
      final response = await http.post(Uri.parse('${apiService}changepassword'),
          headers: {'Content-type': 'application/json'},
          body: jsonEncode({
            'id_users': sharedPrefsController.user.value?.idUser.toString(),
            'old_password': oldPassword,
            'new_password': newPassword
          }));
      final responseBody = json.decode(response.body);
      int code = responseBody['meta']['code'];
      if (code == 200) {
        errorMessage.value = '';
        Get.snackbar("Berhasil", "Password anda telah diubah");
      } else if (code == 401) {
        errorMessage.value = 'password lama tidak sesuai';
        Get.snackbar("Gagal", errorMessage.value);
      } else {
        errorMessage.value = 'password gagal diubah';
        Get.snackbar("Gagal", errorMessage.value);
      }
    } catch (e) {
      errorMessage.value = 'error : $e';
    } finally {
      isLoading(false);
    }
  }
}
