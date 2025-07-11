import 'dart:io';

import 'package:e_surat_bendungan/presentation/controller/pengaduan/controller_aspirasi.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../res/colors.dart';
import '../../../res/fonts_style.dart';
import '../../../res/margin.dart';
import '../../../res/page.dart';
import '../../../res/size.dart';
import '../../widgets/button.dart';
import '../../widgets/text_fields.dart';

class AspirasiScreen extends StatelessWidget {
  AspirasiScreen({super.key});

  final controller = Get.put(ControllerAspirasi());

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
                "Ajukan Aspirasi",
                style: boldFont.copyWith(
                    color: greenPrimary, fontSize: bigFontSize),
              ),
              Text(
                "Silakan isi semua data yang diperlukan!",
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
                  "Judul", "Taman Baca", controller.controllerJudul, context,
                  requiredText: "*"),
              textFieldInput(
                  "Isi", "agar...", controller.controllerIsi, context,
                  requiredText: "*"),
              Obx(() => InkWell(
                    onTap: () {
                      controller.pickImage(ImageSource.gallery);
                    },
                    child: controller.croppedFile.value == null
                        ? uploadDocument(
                            requiredText: "*", label: "Upload Bukti Pendukung")
                        : containesDocument(
                            File(controller.croppedFile.value!.path),
                            requiredText: "*",
                            label: "Upload Bukti Pendukung"),
                  )),
              bigHeight(),
              Obx(() => controller.isLoading.value
                  ? CircularProgressIndicator(
                      color: greenPrimary,
                    )
                  : buttonPrimary("Ajukan", () {
                      controller.insertAspirasi();
                    })),
              smallHeight(),
              Text(
                "*Data atau foto yang diunggah hanya untuk verifikasi surat, hanya admin yang dapat mengakses",
                style: regularFont.copyWith(
                    color: greyPrimary, fontSize: smallFontSize),
              ),
              mediumHeight()
            ],
          ),
        ));
  }
}
