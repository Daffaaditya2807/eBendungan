import 'dart:convert';

import 'package:e_surat_bendungan/config/api.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'controller_shared_prefs.dart';

class ControllerDashboard extends GetxController {
  RxBool isLoading = false.obs;
  RxList<Map<String, dynamic>> lettersToday = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchLettersToday();
  }

  Future<void> fetchLettersToday() async {
    try {
      isLoading.value = true;
      final idAkun = Get.find<ControllerSharedPrefs>().user.value?.idUser;
      final response = await http.post(Uri.parse('${apiService}lettertoday'),
          headers: {'Content-type': 'application/json'},
          body: jsonEncode({'id_akun': idAkun.toString()}));

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data']['data'];

        // Combine all types of letters into one list
        List<Map<String, dynamic>> allLetters = [];

        if (data['izin_usaha'] != null) {
          allLetters.addAll((data['izin_usaha'] as List).map((e) => {
                'type': 'Izin Usaha',
                'name': e['nama'],
                'date': e['created_at'],
                'status': e['status']
              }));
        }

        if (data['izin_pembelian_solar'] != null) {
          allLetters.addAll((data['izin_pembelian_solar'] as List).map((e) => {
                'type': 'Pembelian Solar',
                'name': e['nama'],
                'date': e['created_at'],
                'status': e['status']
              }));
        }

        if (data['keterangan_kehilangan'] != null) {
          allLetters.addAll((data['keterangan_kehilangan'] as List).map((e) => {
                'type': 'Keterangan Kehilangan',
                'name': e['nama'],
                'date': e['created_at'],
                'status': e['status']
              }));
        }

        if (data['keteranganKematian'] != null) {
          allLetters.addAll((data['keteranganKematian'] as List).map((e) => {
                'type': 'Keterangan Kematian',
                'name': e['nama'],
                'date': e['created_at'],
                'status': e['status']
              }));
        }

        if (data['skck'] != null) {
          allLetters.addAll((data['skck'] as List).map((e) => {
                'type': 'SKCK',
                'name': e['nama'],
                'date': e['created_at'],
                'status': e['status']
              }));
        }
        lettersToday.value = allLetters;
      }
    } catch (e) {
      print('Error fetching letters: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
