import 'dart:convert';

import 'package:e_surat_bendungan/config/api.dart';
import 'package:e_surat_bendungan/config/models/aspirasi_model.dart';
import 'package:e_surat_bendungan/config/models/keluhan_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../controller_shared_prefs.dart';

class ControllerHistoryPengaduan extends GetxController {
  var keluhanList = <KeluhanModel>[].obs;
  var aspirasiList = <AspirasiModel>[].obs;
  var isLoadingKeluhan = false.obs;
  var isLoadingAspirasi = false.obs;
  late TabController tabController;
  final sharedPrefsController = Get.find<ControllerSharedPrefs>();

  final List<Tab> menuTab = [
    const Tab(text: "Aspirasi"),
    const Tab(text: "Keluhan"),
  ];

  Future<void> fetchAspirasi() async {
    try {
      isLoadingAspirasi(true);
      final response = await http.post(Uri.parse('${apiService}getaspirasi'),
          headers: {'Content-type': 'application/json'},
          body: jsonEncode({
            'id_akun': sharedPrefsController.user.value?.idUser.toString()
          }));

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        if (responseBody['data']['success']) {
          List<dynamic> data = responseBody['data']['data'];
          aspirasiList.value =
              data.map((e) => AspirasiModel.fromJson(e)).toList();
        }
      }
    } catch (e) {
      print("error : $e");
    } finally {
      isLoadingAspirasi(false);
    }
  }

  Future<void> fetchKeluhan() async {
    try {
      isLoadingKeluhan(true);
      final response = await http.post(Uri.parse('${apiService}getkeluhan'),
          headers: {'Content-type': 'application/json'},
          body: jsonEncode({
            'id_akun': sharedPrefsController.user.value?.idUser.toString()
          }));

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        if (responseBody['data']['success']) {
          List<dynamic> data = responseBody['data']['data'];
          keluhanList.value =
              data.map((e) => KeluhanModel.fromJson(e)).toList();
        }
      }
    } catch (e) {
      print("error : $e");
    } finally {
      isLoadingKeluhan(false);
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchKeluhan();
    fetchAspirasi();
  }
}
