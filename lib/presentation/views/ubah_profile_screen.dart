import 'package:e_surat_bendungan/presentation/controller/controller_ubah_profil.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../res/colors.dart';
import '../../res/fonts_style.dart';
import '../../res/margin.dart';
import '../../res/page.dart';
import '../../res/size.dart';
import '../widgets/button.dart';
import '../widgets/text_fields.dart';

class UbahProfileScreen extends StatelessWidget {
  UbahProfileScreen({super.key});
  final controller = Get.put(ControllerUbahProfil());
  @override
  Widget build(BuildContext context) {
    controller.controllerName.text =
        controller.sharedPrefsController.user.value?.nama ?? '';

    controller.controllerPhone.text =
        controller.sharedPrefsController.user.value?.noTelp ?? '';
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
                "Ubah Profil",
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
                  "Nama",
                  "Youndaime",
                  controller.controllerName,
                  requiredText: "*",
                  context),
              textFieldInput("Nomer Hp", "08512345678",
                  controller.controllerPhone, context,
                  readOnly: true),
              bigHeight(),
              Obx(() => controller.isLoading.value
                  ? Center(
                      child: CircularProgressIndicator(
                        color: greenPrimary,
                      ),
                    )
                  : buttonPrimary("Ubah Data", () {
                      if (controller.controllerName.text.isEmpty ||
                          controller.controllerPhone.text.isEmpty) {
                        Get.snackbar("Gagal",
                            "Tidak boleh mengosongi nama dan no telepon");
                      } else {
                        controller.updateDataUser(
                            newName: controller.controllerName.text,
                            newPhone: controller.controllerPhone.text);
                      }
                    })),
              mediumHeight()
            ],
          ),
        ));
  }
}
