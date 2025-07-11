import 'dart:convert';
import 'dart:developer';

import 'package:e_surat_bendungan/config/api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../controller_shared_prefs.dart';

class ControllerKeluhan extends GetxController {
  TextEditingController controllerJudul = TextEditingController();
  TextEditingController controllerTanggal = TextEditingController();
  TextEditingController controllerIsi = TextEditingController();
  TextEditingController controllerLokasi = TextEditingController();
  TextEditingController controllerKategori = TextEditingController();

  var isLoading = false.obs;
  final sharedPrefsController = Get.find<ControllerSharedPrefs>();
  var inputDate = ''.obs;
  var croppedFile = Rx<CroppedFile?>(null);
  var selectedCategory = ''.obs;
  List<String> categoryList = [
    "Administrasi",
    "Teknis / Sistem",
    "Pelayanan Publik",
    "Keamanan & Privasi",
    "Infrastruktur & Sarana",
    " Lainnya"
  ].obs;

  Future<void> selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      // Format tanggal ke dd/MM/yyyy
      String formattedDate =
          "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      controllerTanggal.text = formattedDate;
      String dateInput =
          "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      inputDate.value = dateInput;
    }
  }

  Future<void> pickImage(ImageSource source) async {
    final pickedImage = await pickedFileImage(source);
    if (pickedImage != null) {
      CroppedFile? cropFile = await cropImage(pickedImage);
      if (cropFile != null) {
        croppedFile.value = cropFile;
      }
    }
  }

  Future<XFile?> pickedFileImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: source);
      if (pickedFile != null) {
        return pickedFile;
      } else {
        return null;
      }
    } catch (e) {
      print("Terjadi kesalahan saat memilih gambar : $e");
      return null;
    }
  }

  Future<CroppedFile?> cropImage(XFile image) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: image.path,
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Sesuaikan Gambar',
            toolbarColor: Colors.blueAccent,
            toolbarWidgetColor: Colors.white,
            cropFrameColor: Colors.greenAccent,
            hideBottomControls: false,
            activeControlsWidgetColor: Colors.blue,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          minimumAspectRatio: 1.0,
        ),
      ],
    );
    return croppedFile;
  }

  Future<void> insertKeluhan() async {
    try {
      isLoading(true);
      var request = http.MultipartRequest(
        'POST',
        Uri.parse("${apiService}insertkeluhan"),
      );
      request.fields['judul'] = controllerJudul.text;
      request.fields['isi'] = controllerIsi.text;
      request.fields['tanggal'] = inputDate.value;
      request.fields['lokasi'] = controllerLokasi.text;
      request.fields['kategori'] = selectedCategory.value;
      request.fields['id_akun'] =
          sharedPrefsController.user.value!.idUser.toString();

      if (croppedFile.value != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'file_pendukung',
            croppedFile.value!.path,
          ),
        );
      }

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      var jsonResponse = jsonDecode(responseBody);

      print("Kode berapa : ${response.statusCode}");

      if (response.statusCode == 200) {
        Get.back();
      } else if (jsonResponse['data']['message']['file_pendukung'][0] ==
          'The file pendukung failed to upload.') {
        Get.snackbar("Gagal Mengirim", "Ukuran Gambar Terlalu Besar");
      } else {
        Get.snackbar(
            "Error", jsonResponse['message'] ?? "Gagal mengirim keluhan");
      }
    } catch (e) {
      Get.snackbar("Error",
          "Terjadi kesalahan: harap ulangi kirim atau buka tutup aplikasi");
      log("Terjadi Kesalahan: $e");
    } finally {
      isLoading(false);
    }
  }
}
