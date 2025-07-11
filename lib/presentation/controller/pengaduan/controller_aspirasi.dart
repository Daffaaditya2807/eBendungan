import 'dart:convert';
import 'dart:developer';

import 'package:e_surat_bendungan/config/api.dart';
import 'package:e_surat_bendungan/presentation/controller/controller_shared_prefs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class ControllerAspirasi extends GetxController {
  TextEditingController controllerJudul = TextEditingController();
  TextEditingController controllerIsi = TextEditingController();

  var isLoading = false.obs;
  var inputDate = ''.obs;
  var croppedFile = Rx<CroppedFile?>(null);
  final sharedPrefsController = Get.find<ControllerSharedPrefs>();

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

  Future<void> insertAspirasi() async {
    try {
      isLoading(true);
      var request = http.MultipartRequest(
        'POST',
        Uri.parse("${apiService}insertAspirasi"),
      );
      request.fields['judul'] = controllerJudul.text;
      request.fields['isi'] = controllerIsi.text;
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

      if (response.statusCode == 200) {
        // Get.snackbar("Success", "Aspirasi berhasil dikirim");
        Get.back();
      } else if (jsonResponse['data']['message']['file_pendukung'][0] ==
          'The file pendukung failed to upload.') {
        Get.snackbar("Error", "Ukuran Gambar Terlalu Besar");
      } else {
        Get.snackbar(
            "Error", jsonResponse['message'] ?? "Gagal mengirim aspirasi");
      }
    } catch (e) {
      Get.snackbar("Error",
          "Terjadi kesalahan: harap ulangi kirim atau buka tutup aplikasi");
      log("ERROR : $e");
    } finally {
      isLoading(false);
    }
  }
}
