import 'package:e_surat_bendungan/presentation/controller/controller_ubah_sandi.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../res/colors.dart';
import '../../res/fonts_style.dart';
import '../../res/margin.dart';
import '../../res/page.dart';
import '../../res/size.dart';
import '../widgets/button.dart';
import '../widgets/text_fields.dart';

class UbahSandiScreen extends StatelessWidget {
  UbahSandiScreen({super.key});

  final controller = Get.put(ControllerUbahSandi());
  @override
  Widget build(BuildContext context) {
    return bodyApp(
        appbar: AppBar(
          centerTitle: true,
          elevation: 0,
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.white,
          title: Column(
            children: [
              mediumHeight(),
              Text(
                "Ubah Kata Sandi",
                style: boldFont.copyWith(
                    color: greenPrimary, fontSize: bigFontSize),
              ),
              Text(
                "Silakan Ubah Data Anda!",
                style: regularFont.copyWith(
                    color: greyPrimary, fontSize: mediumFontSize),
              ),
              mediumHeight(),
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              bigHeight(),
              mediumHeight(),
              textFieldInput(
                  "Kata Sandi Lama",
                  "XXXXX",
                  requiredText: "*",
                  controller.controllerSandiOld,
                  context),
              textFieldInput(
                  "Kata Sandi Baru",
                  "XXXXX",
                  requiredText: "*",
                  controller.controllerSandiNew,
                  context),
              textFieldInput(
                  "Konfirmasi Sandi Baru",
                  "XXXXX",
                  requiredText: "*",
                  controller.controllerConfirmSandi,
                  context),
              bigHeight(),
              Obx(() => controller.isLoading.value
                  ? Center(
                      child: CircularProgressIndicator(
                        color: greenPrimary,
                      ),
                    )
                  : buttonPrimary("Ubah Kata Sandi", () {
                      if (controller.controllerConfirmSandi.text.isEmpty ||
                          controller.controllerSandiNew.text.isEmpty ||
                          controller.controllerSandiOld.text.isEmpty) {
                        Get.snackbar("Gagal", "Harap mengisi semua inputan");
                      } else {
                        if (controller.controllerSandiNew.text.length < 6) {
                          Get.snackbar("Gagal Ubah Sandi",
                              "Panjang Sandi minimal 6 karakter");
                        } else {
                          controller.updatePassword(
                              oldPassword: controller.controllerSandiOld.text,
                              newPassword: controller.controllerSandiNew.text,
                              confirmPassword:
                                  controller.controllerConfirmSandi.text);
                        }
                      }
                    })),
              mediumHeight()
            ],
          ),
        ));
  }
}
