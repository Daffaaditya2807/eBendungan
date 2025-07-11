import 'dart:convert';

import 'package:e_surat_bendungan/config/api.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../config/models/information_model.dart';

class ControllerInformationVillage extends GetxController {
  var informationList = <InformationModel>[].obs;
  var filteredInformationList = <InformationModel>[].obs;
  var isLoading = true.obs;
  var searchQuery = ''.obs;
  var selectedCategory = ''.obs; // Track selected category

  @override
  void onInit() {
    fetchInformation();
    super.onInit();
  }

  Future<void> fetchInformation() async {
    try {
      isLoading(true);
      final response = await http.get(Uri.parse("${apiService}getinformation"));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> listData = jsonData["data"]["data"];

        informationList.value =
            listData.map((item) => InformationModel.fromJson(item)).toList();
        filteredInformationList.value =
            informationList; // Initialize filtered list
      } else {
        Get.snackbar("Error", "Gagal mengambil data: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", "Terjadi kesalahan: Harap Refresh Aplikasi");
      print("ERROR $e");
    } finally {
      isLoading(false);
    }
  }

  // Get unique categories from informationList
  List<String> get uniqueCategories {
    return informationList.map((info) => info.kategori).toSet().toList()
      ..sort(); // Optional: sort categories alphabetically
  }

  // Filter by category and search query
  void filterInformation({String? category}) {
    if (category != null) {
      selectedCategory.value = category;
    }

    filteredInformationList.value = informationList.where((info) {
      final matchesSearch = searchQuery.value.isEmpty ||
          info.judul.toLowerCase().contains(searchQuery.value) ||
          info.kategori.toLowerCase().contains(searchQuery.value) ||
          info.isi.toLowerCase().contains(searchQuery.value);

      final matchesCategory = selectedCategory.value.isEmpty ||
          info.kategori == selectedCategory.value;

      return matchesSearch && matchesCategory;
    }).toList();
  }

  void searchInformation(String query) {
    searchQuery.value = query.toLowerCase();
    filterInformation();
  }

  void resetFilter() {
    filteredInformationList.value = informationList;
    searchQuery.value = '';
    selectedCategory.value = '';
  }
}
