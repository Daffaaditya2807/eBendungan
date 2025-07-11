import 'dart:convert';
import 'dart:io';

import 'package:e_surat_bendungan/config/api.dart';
import 'package:e_surat_bendungan/presentation/controller/controller_dicebear.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../config/models/users.dart';

class ControllerRegister extends GetxController {
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();
  TextEditingController controllerPhone = TextEditingController();
  TextEditingController controllerSandi = TextEditingController();
  TextEditingController controllerConfirmPassword = TextEditingController();

  final controllerAvatar = Get.put(ControllerDicebear());

  var isShowPassword = true.obs;
  var isShowConfirmPassword = true.obs;
  var isLoading = false.obs;
  var error = ''.obs;
  var user = Rxn<Users>();
  void showHidePassword() {
    isShowPassword.value = !isShowPassword.value;
  }

  void showHideConfirmPassword() {
    isShowConfirmPassword.value = !isShowConfirmPassword.value;
  }

  Future<bool> register(
      {String? name,
      String? email,
      String? phone,
      String? password,
      String? confirmPassword}) async {
    if (password == confirmPassword) {
      isLoading(true);
      try {
        final response = await http.post(Uri.parse('${apiService}register'),
            headers: {'Content-type': 'application/json'},
            body: jsonEncode({
              'email': email,
              'password': password,
              'nama': name,
              'no_telepon': phone,
              'foto_profil': controllerAvatar.avatarUrl.value
            }));

        final responseBody = json.decode(response.body);
        print(responseBody);
        int code = responseBody['meta']['code'];
        print(code);
        if (code == 200) {
          if (responseBody['meta']['status'] == 'success') {
            user.value = Users.fromJson(responseBody['data']['user']);
            error.value = '';
            return true;
          }
        } else if (code == 408) {
          error.value = 'Email sudah terdaftar';
          return false;
        } else if (code == 409) {
          error.value = 'Nomor telepon sudah digunakan';
          return false;
        } else if (code == 500) {
          error.value = 'ada yang error';
          return false;
        }
      } on SocketException {
        error.value = 'Periksa koneksi Internet';
        return false;
      } catch (e) {
        error.value = 'error : $e';
        return false;
      } finally {
        isLoading(false);
      }
    } else {
      error.value = 'password tidak sama';
      return false;
    }
    return false;
  }
}
