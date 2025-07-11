import 'dart:io';

import 'package:e_surat_bendungan/presentation/controller/letters/controller_sk_kematian.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../res/colors.dart';
import '../../../res/fonts_style.dart';
import '../../../res/margin.dart';
import '../../../res/page.dart';
import '../../../res/size.dart';
import '../../widgets/button.dart';
import '../../widgets/text_fields.dart';

class SkKematian extends StatelessWidget {
  SkKematian({super.key});
  final controller = Get.put(ControllerSkKematian());

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
                "SK Kematian",
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
              Obx(() => InkWell(
                    onTap: () {
                      controller.pickImage(ImageSource.gallery);
                    },
                    child: controller.croppedFile.value == null
                        ? uploadDocument(
                            requiredText: "*", label: "Unggah Foto Pendukung")
                        : containesDocument(
                            File(controller.croppedFile.value!.path),
                            requiredText: "*",
                            label: "Unggah Foto Pendukung"),
                  )),
              smallHeight(),
              Text(
                "*Data atau foto yang diunggah hanya untuk verifikasi surat, hanya admin yang dapat mengakses",
                style: regularFont.copyWith(
                    color: greyPrimary, fontSize: smallFontSize),
              ),
              mediumHeight(),
              textFieldInput(
                  "Nama", "Pengguna", controller.controllerNama, context,
                  requiredText: "*",
                  typeInput: TextInputType.name,
                  formatter: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]'))
                  ]),
              textFieldInput("Usia", "XX", controller.controllerUsia, context,
                  lenght: 2,
                  typeInput: TextInputType.number,
                  requiredText: "*",
                  formatter: [FilteringTextInputFormatter.digitsOnly]),
              Obx(() => dropDownTextField(
                    "Jenis Kelamin",
                    "Pilih Jenis Kelamin",
                    requiredText: "*",
                    controller.jenisKelaminList
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: regularFont,
                          ));
                    }).toList(),
                    (newValue) {
                      controller.selectedJenisKelamin.value =
                          newValue.toString();
                    },
                    context,
                    counter: null,
                    value: controller.selectedJenisKelamin.value.isEmpty
                        ? null
                        : controller.selectedJenisKelamin.value,
                  )),
              textFieldInput(
                  "Alamat Terakhir",
                  "Dsn. Kepatihan RT XX RW XX",
                  requiredText: "*",
                  controller.controllerAlamat,
                  context),
              textFieldInput(
                "Tanggal Kematian",
                "12/12/2024",
                requiredText: "*",
                controller.controllerTglKematian,
                context,
                readOnly: true,
                function: () {
                  controller.selectDate(context);
                },
              ),
              textFieldInput(
                  "Hari", "Senin", controller.controllerHari, context,
                  requiredText: "*", readOnly: true),
              textFieldInput(
                  "Bertempat",
                  "Rumah Pengguna",
                  requiredText: "*",
                  controller.controllerTempat,
                  context),
              textFieldInput(
                  "Penyebab Kematian",
                  "Sakit",
                  requiredText: "*",
                  controller.controllerKematian,
                  context),
              Obx(() => controller.isLoading.value
                  ? CircularProgressIndicator(
                      color: greenPrimary,
                    )
                  : buttonPrimary("Buat", () {
                      controller.insertKeteranganKematian();
                    })),
              mediumHeight()
            ],
          ),
        ));
  }
}
