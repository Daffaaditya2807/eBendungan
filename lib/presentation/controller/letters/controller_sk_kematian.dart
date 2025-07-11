import 'dart:convert';
import 'dart:io';

import 'package:best_ktp_ocr_flutter/bestktpocrflutter.dart';
import 'package:e_surat_bendungan/config/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

import '../../../config/routes.dart';
import '../controller_shared_prefs.dart';

class ControllerSkKematian extends GetxController {
  TextEditingController controllerNama = TextEditingController();
  TextEditingController controllerUsia = TextEditingController();
  TextEditingController controllerAlamat = TextEditingController();
  TextEditingController controllerHari = TextEditingController();
  TextEditingController controllerTglKematian = TextEditingController();
  TextEditingController controllerTempat = TextEditingController();
  TextEditingController controllerKematian = TextEditingController();

  final sharedPrefsController = Get.find<ControllerSharedPrefs>();
  var croppedFile = Rx<CroppedFile?>(null);
  var isLoading = false.obs;
  var inputDate = ''.obs;

  var selectedJenisKelamin = ''.obs;
  List<String> jenisKelaminList = ['Laki - Laki', 'Perempuan'].obs;

  String? _ktpJson = 'Unknown';
  final _bestktpocrflutterPlugin = Bestktpocrflutter();

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
      controllerTglKematian.text = formattedDate;
      String dateInput =
          "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      inputDate.value = dateInput;
      controllerHari.text = DateFormat.EEEE('id').format(picked);
    }
  }

  Future<void> pickImage(ImageSource source) async {
    final pickedImage = await pickedFileImage(source);
    if (pickedImage != null) {
      CroppedFile? cropFile = await cropImage(pickedImage);
      if (cropFile != null) {
        croppedFile.value = cropFile;
        await scanKTPImage(XFile(croppedFile.value!.path));
        Get.snackbar("Harap Periksa",
            "Periksa Kembali data, karena mungkin saja hasil kurang akurat",
            duration: Duration(seconds: 6));
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

  Future<void> insertKeteranganKematian() async {
    if (controllerNama.text.isEmpty ||
        controllerUsia.text.isEmpty ||
        selectedJenisKelamin.value.isEmpty ||
        controllerAlamat.text.isEmpty ||
        controllerHari.text.isEmpty ||
        controllerTglKematian.text.isEmpty ||
        controllerTempat.text.isEmpty ||
        controllerKematian.text.isEmpty ||
        croppedFile.value == null) {
      Get.snackbar("Error", "Semua kolom harus diisi!");
      return;
    }

    try {
      isLoading(true);
      var request = http.MultipartRequest(
          'POST', Uri.parse("${apiService}insertketerangankematian"));
      request.fields['nama'] = controllerNama.text;
      request.fields['usia'] = controllerUsia.text;
      request.fields['jenis_kelamin'] = selectedJenisKelamin.value;
      request.fields['alamat_terakhir'] = controllerAlamat.text;
      request.fields['hari'] = controllerHari.text;
      request.fields['tanggal_kematian'] = inputDate.value;
      request.fields['bertempat'] = controllerTempat.text;
      request.fields['disebabkan'] = controllerKematian.text;
      request.fields['id_akun'] =
          sharedPrefsController.user.value!.idUser.toString();

      if (croppedFile.value != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'file_pendukung',
          croppedFile.value!.path,
        ));
      }

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      var jsonResponse = jsonDecode(responseBody);

      print(responseBody);

      if (response.statusCode == 200) {
        await Future.delayed(Duration(milliseconds: 2000), () {
          isLoading(false);
          // Get.snackbar("Berhasil Mengirim Surat",
          //     "Surat Izin Pembelian Solar Berhasil Dikirim");
        });
        Get.offAllNamed(Routes.navBarScreen);
      } else {
        Get.snackbar(
            "Error", jsonResponse['data']['message'] ?? "Gagal mengirim data");
      }
    } catch (e) {
      Get.snackbar("Error", "Terjadi kesalahan: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> scanKTPImage(XFile imageFile) async {
    try {
      // Convert XFile to File
      File file = File(imageFile.path);

      // Preprocess the image using image package
      final img.Image? originalImage = img.decodeImage(file.readAsBytesSync());

      if (originalImage != null) {
        // Apply preprocessing steps
        var processedImage = originalImage;

        // 1. Resize image to optimal size while maintaining aspect ratio
        processedImage = img.copyResize(
          processedImage,
          width: 1280, // Standard width for better OCR
          height: (1280 * processedImage.height ~/ processedImage.width),
        );
        processedImage = img.grayscale(processedImage);
        processedImage = img.gaussianBlur(processedImage, radius: 01);
        final processedBytes = img.encodeJpg(processedImage, quality: 100);
        final tempDir = await getTemporaryDirectory();
        final tempPath = '${tempDir.path}/processed_ktp.jpg';
        await File(tempPath).writeAsBytes(processedBytes);

        _ktpJson = await _bestktpocrflutterPlugin.scanKTP(processedBytes);
        if (_ktpJson != null) {
          final ktpData = jsonDecode(_ktpJson!);

          ktpData['jenisKelamin'].toString().contains("E")
              ? selectedJenisKelamin.value = jenisKelaminList[1]
              : selectedJenisKelamin.value = jenisKelaminList[0];
          controllerNama.text =
              ktpData['nama'] == 'null' ? '' : ktpData['nama'];
          controllerAlamat.text =
              ktpData['alamat'] == 'null' ? '' : ktpData['alamat'];
        }

        print(_ktpJson);
      } else {
        throw Exception('Failed to decode image');
      }
    } on PlatformException {
      _ktpJson = 'Failed to scan KTP.';
      Get.snackbar("Error", "Gagal memindai KTP");
    } catch (e) {
      _ktpJson = 'Error: $e';
      Get.snackbar("Error", "Terjadi kesalahan saat memindai KTP");
    } finally {}
  }
}
