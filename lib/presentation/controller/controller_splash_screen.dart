import 'package:e_surat_bendungan/config/routes.dart';
import 'package:e_surat_bendungan/res/colors.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../config/internet_service.dart';
import 'controller_shared_prefs.dart';

class ControllerSplashScreen extends GetxController {
  final internetService = Get.find<InternetService>();

  void navigateToNextScreen() async {
    await Future.delayed(Duration(milliseconds: 2000));
    final sharedPrefsController = Get.find<ControllerSharedPrefs>();

    // Check if internet is available
    bool isConnected = await internetService.checkConnection();
    if (!isConnected) {
      // Tampilkan pesan jika tidak ada koneksi internet
      Get.snackbar(
        'Tidak Ada Koneksi Internet',
        'Beberapa fitur mungkin tidak berfungsi dengan baik',
        backgroundColor: greenPrimary,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
        snackPosition: SnackPosition.BOTTOM,
      );
    }

    // Tetap lanjutkan navigasi terlepas dari status koneksi
    if (sharedPrefsController.isLoggedIn.value) {
      Get.toNamed(Routes.navBarScreen);
    } else {
      Get.toNamed(Routes.introFirstScreen);
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    navigateToNextScreen();
  }
}
