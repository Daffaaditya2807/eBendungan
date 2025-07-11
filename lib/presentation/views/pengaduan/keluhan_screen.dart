import 'dart:io';

import 'package:e_surat_bendungan/presentation/controller/pengaduan/controller_keluhan.dart';
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

class KeluhanScreen extends StatelessWidget {
  KeluhanScreen({super.key});
  final controller = Get.put(ControllerKeluhan());

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
                "Ajukan Keluhan",
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
                "Tanggal",
                "12/02/2002",
                controller.controllerTanggal,
                context,
                requiredText: "*",
                readOnly: true,
                function: () {
                  controller.selectDate(context);
                },
              ),
              textFieldInput(
                "Isi",
                "agar...",
                controller.controllerIsi,
                context,
                requiredText: "*",
              ),
              textFieldInput(
                  "Lokasi",
                  "Dsn. XX RT XX RW XX",
                  requiredText: "*",
                  controller.controllerLokasi,
                  context),
              // textFieldInput(
              //     "Kategori",
              //     "Infeastruktur Desa",
              //     requiredText: "*",
              //     controller.controllerKategori,
              //     context),
              Obx(() => dropDownTextField(
                      "Kategori",
                      "Pilih Kategori Keluhan",
                      requiredText: "*",
                      controller.categoryList
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: regularFont,
                            ));
                      }).toList(), (newValue) {
                    controller.selectedCategory.value = newValue.toString();
                  }, context,
                      value: controller.selectedCategory.value.isEmpty
                          ? null
                          : controller.selectedCategory.value)),
              Obx(() => InkWell(
                    onTap: () {
                      controller.pickImage(ImageSource.gallery);
                    },
                    child: controller.croppedFile.value == null
                        ? uploadDocument(
                            requiredText: "*", label: "Upload File Pendukung")
                        : containesDocument(
                            File(controller.croppedFile.value!.path),
                            requiredText: "*",
                            label: "Upload File Pendukung"),
                  )),
              bigHeight(),
              Obx(() => controller.isLoading.value
                  ? CircularProgressIndicator(
                      color: greenPrimary,
                    )
                  : buttonPrimary("Ajukan", () {
                      controller.insertKeluhan();
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
