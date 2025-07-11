import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:best_ktp_ocr_flutter/bestktpocrflutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../../config/api.dart';
import '../../../config/extract_ttl_ktp.dart';
import '../../../config/routes.dart';
import '../controller_shared_prefs.dart';

class ControllerSkCatatanKepolisian extends GetxController {
  TextEditingController controllerNik = TextEditingController();
  TextEditingController controllerNama = TextEditingController();
  TextEditingController controllerTglLahir = TextEditingController();
  TextEditingController controllerTempatLahir = TextEditingController();
  TextEditingController controllerTempatAlamat = TextEditingController();
  TextEditingController controllerSuku = TextEditingController();
  TextEditingController controllerPekerjaan = TextEditingController();
  TextEditingController controllerStatus = TextEditingController();
  TextEditingController controllerPendidikan = TextEditingController();
  final sharedPrefsController = Get.find<ControllerSharedPrefs>();

  var isLoading = false.obs;
  var inputDate = ''.obs;

  var croppedFile = Rx<CroppedFile?>(null);

  var selectedJenisKelamin = ''.obs;
  List<String> jenisKelaminList = ['Laki - Laki', 'Perempuan'].obs;
  var selectedAgama = ''.obs;
  List<String> agamaList = [
    'Islam',
    'Kristen',
    'Kristen Protestan',
    'Kristen Katolik',
    'Hindu',
    'Budha',
    'Konghucu'
  ].obs;

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
      String formattedDate =
          "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      String dateInput =
          "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      controllerTglLahir.text = formattedDate;
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

  Future<void> insertSkck() async {
    if (controllerNama.text.isEmpty ||
        controllerTempatLahir.text.isEmpty ||
        controllerTglLahir.text.isEmpty ||
        selectedAgama.value == '' ||
        controllerStatus.text.isEmpty ||
        controllerSuku.text.isEmpty ||
        selectedJenisKelamin.value == '' ||
        controllerPendidikan.text.isEmpty ||
        controllerPekerjaan.text.isEmpty ||
        controllerNik.text.isEmpty ||
        controllerStatus.text.isEmpty ||
        controllerTempatAlamat.text.isEmpty ||
        croppedFile.value == null) {
      Get.snackbar("Error", "Semua kolom harus diisi!");
      return;
    }

    try {
      isLoading(true);
      var request =
          http.MultipartRequest('POST', Uri.parse("${apiService}insertskck"));
      request.fields['nama'] = controllerNama.text;
      request.fields['tempat_lahir'] = controllerTempatLahir.text;
      request.fields['tanggal_lahir'] = inputDate.value;
      request.fields['jenis_kelamin'] = selectedJenisKelamin.value;
      request.fields['status_perkawinan'] = controllerStatus.text;
      request.fields['suku'] = controllerSuku.text;
      request.fields['agama'] = selectedAgama.value;
      request.fields['pendidikan'] = controllerPendidikan.text;
      request.fields['pekerjaan'] = controllerPekerjaan.text;
      request.fields['NIK'] = controllerNik.text;
      request.fields['alamat'] = controllerTempatAlamat.text;
      request.fields['id_akun'] = sharedPrefsController.user.value!.idUser
          .toString(); // Sesuaikan dengan ID akun pengguna

      if (croppedFile.value != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'file_pendukung',
          croppedFile.value!.path,
        ));
      }

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      var jsonResponse = jsonDecode(responseBody);

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
          width: 1280,
          height: (1280 * processedImage.height ~/ processedImage.width),
        );
        processedImage = img.grayscale(processedImage);
        processedImage = img.gaussianBlur(processedImage, radius: 01);
        final processedBytes = img.encodeJpg(processedImage, quality: 100);
        final tempDir = await getTemporaryDirectory();
        final tempPath = '${tempDir.path}/processed_ktp.jpg';
        await File(tempPath).writeAsBytes(processedBytes);

        _ktpJson = await _bestktpocrflutterPlugin.scanKTP(processedBytes);

        final inputImage = InputImage.fromFilePath(tempPath);
        final textRecognizer =
            TextRecognizer(script: TextRecognitionScript.latin);
        final RecognizedText recognizedText =
            await textRecognizer.processImage(inputImage);
        final ocrData = extractKtpData(recognizedText.text);

        if (_ktpJson != null) {
          final ktpData = jsonDecode(_ktpJson!);

          ktpData['jenisKelamin'].toString().contains("E")
              ? selectedJenisKelamin.value = jenisKelaminList[1]
              : selectedJenisKelamin.value = jenisKelaminList[0];

          // Normalisasi agama dan periksa apakah ada dalam agamaList
          String normalizedAgama = normalizeAgama(ktpData['agama']);
          if (agamaList.contains(normalizedAgama)) {
            selectedAgama.value = normalizedAgama;
          } else {
            selectedAgama.value = ''; // Biarkan kosong jika tidak valid
          }

          controllerNik.text = ktpData['nik'] == 'null' ? '' : ktpData['nik'];

          controllerNama.text =
              ktpData['nama'] == 'null' ? '' : ktpData['nama'];

          controllerTempatAlamat.text =
              ktpData['alamat'] == 'null' ? '' : ktpData['alamat'];

          controllerTempatLahir.text =
              ocrData['tempat_lahir'].toString() == 'null'
                  ? ''
                  : ocrData['tempat_lahir'].toString();

          controllerPekerjaan.text =
              ktpData['pekerjaan'] == 'null' ? '' : ktpData['pekerjaan'];

          controllerStatus.text = ktpData['statusPerkawinan'] == 'null'
              ? ''
              : ktpData['statusPerkawinan'];

          controllerTglLahir.text =
              ocrData['tanggal_lahir'].toString() == 'null'
                  ? ''
                  : ocrData['tanggal_lahir'].toString();
          inputDate.value =
              convertDateFormat(ocrData['tanggal_lahir'].toString());
        }

        log("Data : $_ktpJson");
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

  String normalizeAgama(String scannedAgama) {
    scannedAgama =
        scannedAgama.toLowerCase(); // Ubah ke huruf kecil untuk normalisasi

    Map<String, List<String>> mapping = {
      'Islam': ['islm', 'islam', 'islamic'],
      'Kristen': ['krist', 'kristen', 'protestan'],
      'Kristen Katolik': ['katolik', 'catholic', 'kristen katolik'],
      'Hindu': ['hindu'],
      'Budha': ['budha', 'buddha'],
      'Konghucu': ['konghucu', 'confucian']
    };

    for (var entry in mapping.entries) {
      if (entry.value.any((alias) => scannedAgama.contains(alias))) {
        return entry.key;
      }
    }

    return '';
  }
}
