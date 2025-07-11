import 'dart:convert';

import 'package:e_surat_bendungan/config/api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../config/models/users.dart';
import 'controller_shared_prefs.dart';

class ControllerUbahProfil extends GetxController {
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerPhone = TextEditingController();
  final sharedPrefsController = Get.find<ControllerSharedPrefs>();
  var isLoading = false.obs;
  var user = Rxn<Users>();

  Future<void> updateDataUser({String? newName, String? newPhone}) async {
    isLoading(true);
    try {
      final response = await http.post(Uri.parse('${apiService}updateprofile'),
          headers: {'Content-type': 'application/json'},
          body: jsonEncode({
            'id_users': sharedPrefsController.user.value?.idUser.toString(),
            'nama': newName,
            'no_telepon': newPhone
          }));

      final responseBody = json.decode(response.body);
      int code = responseBody['meta']['code'];
      if (code == 200) {
        user.value = Users.fromJson(responseBody['data']['user']);
        await sharedPrefsController.saveUser(user.value!);
        Get.snackbar("Berhasil Mengubah Profil",
            "Data telah diubah dengan nama $newName dan nomor telepon $newPhone");
      }
    } catch (e) {
      print("error : $e");
      Get.snackbar("Error",
          'Terjadi kesalahan harap periksa kembali da pastikan koneksi internet lancar');
    } finally {
      isLoading(false);
    }
  }
}
