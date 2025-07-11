import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class ControllerLetter extends GetxController {
  TextEditingController searchController = TextEditingController();
  var letters = <Map<String, String>>[
    {
      "name": "Kehilangan",
      "desc":
          "Gunakan untuk pengurusan dokumen penting, barang berharga yang hilang"
    },
    {
      "name": "Pembelian Solar",
      "desc": "Gunakan untuk Pembelian Solar usaha jasa selep keliling"
    },
    {
      "name": "Kematian",
      "desc": "Gunakan untuk mengurusi dokumen keperluan surat kematian"
    },
    {
      "name": "Catatan Kepolisian",
      "desc":
          "Gunakan untuk membuat keperluan dokumen Surat Keterangan Catatan Kepolisian"
    },
    {
      "name": "Izin Usaha",
      "desc": "Gunakan untuk keperluan Surat bahwa benar benar mempunyai usaha"
    },
  ].obs;

  var filteredLetters = <Map<String, String>>[].obs;

  @override
  void onInit() {
    super.onInit();
    filteredLetters.assignAll(letters);
    searchController.addListener(() {
      searchLetters(searchController.text);
    });
  }

  void searchLetters(String query) {
    if (query.isEmpty) {
      filteredLetters.assignAll(letters);
    } else {
      filteredLetters.assignAll(letters.where((letter) =>
          letter["name"]!.toLowerCase().contains(query.toLowerCase())));
    }
  }
}
