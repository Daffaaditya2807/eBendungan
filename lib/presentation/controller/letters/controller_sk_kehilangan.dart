import 'dart:convert';
import 'dart:io';
import 'package:best_ktp_ocr_flutter/bestktpocrflutter.dart';
import 'package:e_surat_bendungan/config/api.dart';
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
import '../controller_shared_prefs.dart';

class ControllerSkKehilangan extends GetxController {
  TextEditingController controllerNik = TextEditingController();
  TextEditingController controllerNama = TextEditingController();
  TextEditingController controllerTglLahir = TextEditingController();
  TextEditingController controllerTempatLahir = TextEditingController();
  TextEditingController controllerTempatAlamat = TextEditingController();
  TextEditingController controllerPekerjaan = TextEditingController();
  TextEditingController controllerKeterangan = TextEditingController();

  final sharedPrefsController = Get.find<ControllerSharedPrefs>();
  var croppedFile = Rx<CroppedFile?>(null);
  var isLoading = false.obs;
  var inputDate = ''.obs;
  String? _ktpJson = 'Unknown';
  final _bestktpocrflutterPlugin = Bestktpocrflutter();

  var selectedJenisKelamin = ''.obs;
  List<String> jenisKelaminList = ['Laki - Laki', 'Perempuan'].obs;
  var selectedAgama = ''.obs;
  List<String> agamaList =
      ['Islam', 'Kristen', 'Kristen Katolik', 'Hindu', 'Budha', 'Konghucu'].obs;

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
      inputDate.value = dateInput;
      controllerTglLahir.text = formattedDate; // Update controller
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

  void handleApiError(Map<String, dynamic> jsonResponse) {
    if (jsonResponse.containsKey("meta") &&
        jsonResponse["meta"]["status"] == "error") {
      String message = jsonResponse["meta"]["message"] ?? "Terjadi kesalahan";

      // Jika ada kesalahan validasi di "data.message"
      if (jsonResponse["data"] != null &&
          jsonResponse["data"]["message"] is Map<String, dynamic>) {
        var errors = jsonResponse["data"]["message"];
        String errorMessages = "";

        // Loop semua error yang ada
        errors.forEach((key, value) {
          if (value is List) {
            errorMessages += "${value.join("\n")}\n";
          }
        });

        // Tampilkan snackbar dengan error spesifik
        Get.snackbar("Validation Error", errorMessages);
        return;
      }

      // Jika hanya ada pesan error umum
      Get.snackbar("Error", message);
    } else {
      Get.snackbar("Error", "Terjadi kesalahan yang tidak diketahui.");
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

  Future<void> insertKeteranganKehilangan() async {
    if (controllerNama.text.isEmpty ||
        controllerTempatLahir.text.isEmpty ||
        controllerNik.text == '' ||
        controllerTempatAlamat.text.isEmpty ||
        selectedAgama.value == '' ||
        controllerPekerjaan.text.isEmpty ||
        controllerKeterangan.text.isEmpty ||
        croppedFile.value == null) {
      Get.snackbar("Error", "Semua kolom harus diisi!");
      return;
    }

    try {
      isLoading(true);
      var request = http.MultipartRequest(
          'POST', Uri.parse("${apiService}insertketerangankehilangan"));
      request.fields['nama'] = controllerNama.text;
      request.fields['tempat_lahir'] = controllerTempatLahir.text;
      request.fields['tanggal_lahir'] = inputDate.value;
      request.fields['jenis_kelamin'] = selectedJenisKelamin.value;
      request.fields['agama'] = selectedAgama.value;
      request.fields['pekerjaan'] = controllerPekerjaan.text;
      request.fields['NIK'] = controllerNik.text;
      request.fields['alamat'] = controllerTempatAlamat.text;
      request.fields['keterangan'] = controllerKeterangan.text;
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

      print(responseBody);

      if (response.statusCode == 200) {
        Get.offAllNamed(Routes.navBarScreen);
      } else {
        // handleApiError(jsonResponse);
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

          selectedAgama.value = normalizeAgama(ktpData['agama']);

          controllerNik.text = ktpData['nik'] == 'null' ? '' : ktpData['nik'];
          controllerNama.text =
              ktpData['nama'] == 'null' ? '' : ktpData['nama'];
          controllerTempatAlamat.text =
              ktpData['alamat'] == 'null' ? '' : ktpData['alamat'];
          controllerTempatLahir.text =
              ocrData['tempat_lahir'].toString() == 'null'
                  ? ''
                  : ocrData['tempat_lahir'].toString();
          controllerTglLahir.text =
              ocrData['tanggal_lahir'].toString() == 'null'
                  ? ''
                  : ocrData['tanggal_lahir'].toString();
          inputDate.value =
              convertDateFormat(ocrData['tanggal_lahir'].toString());
          controllerPekerjaan.text =
              ktpData['pekerjaan'] == 'null' ? '' : ktpData['pekerjaan'];
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

    return 'Tidak Diketahui'; // Jika tidak ditemukan
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }
}
