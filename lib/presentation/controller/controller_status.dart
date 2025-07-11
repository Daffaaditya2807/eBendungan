import 'dart:convert';

import 'package:e_surat_bendungan/config/api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'controller_shared_prefs.dart';

class ControllerStatus extends GetxController {
  late TabController tabController;
  final sharedPrefsController = Get.find<ControllerSharedPrefs>();
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var letterData = Rx<Map<String, dynamic>?>(null);
  var letterDataSelesai = Rx<Map<String, dynamic>?>(null);
  var letterDataDitolak = Rx<Map<String, dynamic>?>(null);

  final List<Tab> menuTab = [
    const Tab(text: "Diproses"),
    const Tab(text: "Ditolak"),
    const Tab(text: "Selesai")
  ];

  Future<void> refreshData() async {
    errorMessage('');
    letterData(null);
    letterDataSelesai(null);
    letterDataDitolak(null);
    await Future.wait([
      fetchDiproses(),
      fetchSelesai(),
      fetchDitolak(),
    ]);
  }

  Future<void> fetchDiproses() async {
    try {
      isLoading(true);
      final response = await http.post(Uri.parse('${apiService}prosesletter'),
          headers: {'Content-type': 'application/json'},
          body: jsonEncode({
            'id_akun': sharedPrefsController.user.value?.idUser.toString()
          }));
      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        letterData(responseBody);
      }
    } catch (e) {
      errorMessage('Terjadi kesalahan: Buka ulang aplikasi untuk merefresh');
      print('Terjadi kesalahan: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchSelesai() async {
    try {
      isLoading(true);
      final response = await http.post(Uri.parse('${apiService}selesailetter'),
          headers: {'Content-type': 'application/json'},
          body: jsonEncode({
            'id_akun': sharedPrefsController.user.value?.idUser.toString()
          }));
      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        letterDataSelesai(responseBody);
      }
    } catch (e) {
      errorMessage('Terjadi kesalahan: Buka ulang aplikasi untuk merefresh');
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchDitolak() async {
    try {
      isLoading(true);
      final response = await http.post(Uri.parse('${apiService}ditolakletter'),
          headers: {'Content-type': 'application/json'},
          body: jsonEncode({
            'id_akun': sharedPrefsController.user.value?.idUser.toString()
          }));
      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        letterDataDitolak(responseBody);
      }
    } catch (e) {
      errorMessage('Terjadi kesalahan: Buka ulang aplikasi untuk merefresh');
    } finally {
      isLoading(false);
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchDiproses();
    fetchSelesai();
    fetchDitolak();
  }
}
