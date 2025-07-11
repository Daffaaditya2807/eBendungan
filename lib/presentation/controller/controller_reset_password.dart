import 'dart:convert';

import 'package:e_surat_bendungan/config/api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ControllerResetPassword extends GetxController {
  TextEditingController controllerPassword = TextEditingController();
  TextEditingController controllerConfirmPassword = TextEditingController();
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  Future<bool> resetPassword(
      {String? password, String? confirmPassword, String? email}) async {
    if (password == confirmPassword) {
      isLoading(true);
      try {
        final response = await http.post(
            Uri.parse('${apiService}resetpassword'),
            headers: {'Content-type': 'application/json'},
            body: jsonEncode({'email': email, 'new_password': password}));
        final responseBody = json.decode(response.body);
        int code = responseBody['meta']['code'];

        if (code == 200) {
          errorMessage.value = '';
          return true;
        } else {
          errorMessage.value = 'ada yang error';
          return false;
        }
      } catch (e) {
        errorMessage.value = 'error : $e';
        return false;
      } finally {
        isLoading(false);
      }
    } else {
      errorMessage.value = 'password tidak sama';
      return false;
    }
  }
}
