import 'dart:convert';

import 'package:e_surat_bendungan/config/api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../config/models/users.dart';

class ControllerForgetPassword extends GetxController {
  TextEditingController controllerPassowrd = TextEditingController();
  var isLoading = false.obs;
  var errorMesage = ''.obs;
  var user = Rxn<Users>();

  Future<bool> checkPassword({String? email}) async {
    isLoading(true);
    try {
      final response = await http.post(Uri.parse('${apiService}checkemail'),
          headers: {'Content-type': 'application/json'},
          body: jsonEncode({'email': email}));

      final responseBody = json.decode(response.body);
      int code = responseBody['meta']['code'];
      if (code == 200) {
        errorMesage.value = '';
        user.value = Users.fromJson(responseBody['data']['user']);
        return true;
      } else if (code == 404) {
        errorMesage.value = 'email tidak tersedia';
        return false;
      }
    } catch (e) {
      errorMesage.value = 'error $e';
      return false;
    } finally {
      isLoading(false);
    }
    return false;
  }
}
