import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:best_ktp_ocr_flutter/bestktpocrflutter.dart';
import 'package:e_surat_bendungan/config/api.dart';
import 'package:e_surat_bendungan/presentation/controller/controller_shared_prefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

import '../../../config/extract_ttl_ktp.dart';
import '../../../config/routes.dart';

class ControllerSkPembelianSolar extends GetxController {
  TextEditingController controllerNIK = TextEditingController();
  TextEditingController controllerNama = TextEditingController();
  TextEditingController controllerTanggalLahir = TextEditingController();
  TextEditingController controllerTempatLahir = TextEditingController();
  TextEditingController controllerAlamat = TextEditingController();
  String? _ktpJson = 'Unknown';

  final _bestktpocrflutterPlugin = Bestktpocrflutter();

  final sharedPrefsController = Get.find<ControllerSharedPrefs>();
  var isLoading = false.obs;
  var isLoadingImage = false.obs;
  var inputDate = ''.obs;

  var croppedFile = Rx<CroppedFile?>(null);
  var processedImagePath = Rx<String?>(null);

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
      String dateInput =
          "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      controllerTanggalLahir.text = formattedDate; // Update controller
      inputDate.value = dateInput;
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

  Future<void> insertPembelianSolar() async {
    if (controllerNama.text.isEmpty ||
        controllerTempatLahir.text.isEmpty ||
        controllerTanggalLahir.text.isEmpty ||
        controllerNIK.text.isEmpty ||
        controllerAlamat.text.isEmpty ||
        croppedFile.value == null) {
      Get.snackbar("Error", "Semua kolom harus diisi!");
      return;
    }

    try {
      isLoading(true);
      var request = http.MultipartRequest(
          'POST', Uri.parse("${apiService}insertpembeliansolar"));
      request.fields['nama'] = controllerNama.text;
      request.fields['tempat_lahir'] = controllerTempatLahir.text;
      request.fields['tanggal_lahir'] = inputDate.value;
      request.fields['NIK'] = controllerNIK.text;
      request.fields['alamat'] = controllerAlamat.text;
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

      log(responseBody);
      if (response.statusCode == 200) {
        Get.offAllNamed(Routes.navBarScreen);
      } else {
        Get.snackbar(
            "Gagal", jsonResponse['data']['message'] ?? "Gagal mengirim data");
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

        processedImagePath.value = tempPath;
        // metode 1
        _ktpJson = await _bestktpocrflutterPlugin.scanKTP(processedBytes);
        // metode 2
        final inputImage = InputImage.fromFilePath(tempPath);
        final textRecognizer =
            TextRecognizer(script: TextRecognitionScript.latin);
        final RecognizedText recognizedText =
            await textRecognizer.processImage(inputImage);
        final ocrData = extractKtpData(recognizedText.text);

        if (_ktpJson != null) {
          final ktpData = jsonDecode(_ktpJson!);
          log(ocrData['tanggal_lahir'].toString());

          // Populate text controllers
          controllerNIK.text = ktpData['nik'] == 'null' ? '' : ktpData['nik'];
          controllerNama.text =
              ktpData['nama'] == 'null' ? '' : ktpData['nama'];
          controllerAlamat.text =
              ktpData['alamat'] == 'null' ? '' : ktpData['alamat'];
          controllerTanggalLahir.text =
              ocrData['tanggal_lahir'].toString() == 'null'
                  ? ''
                  : ocrData['tanggal_lahir'].toString();
          inputDate.value =
              convertDateFormat(ocrData['tanggal_lahir'].toString());
          controllerTempatLahir.text =
              ocrData['tempat_lahir'].toString() == 'null'
                  ? ''
                  : ocrData['tempat_lahir'].toString();
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
