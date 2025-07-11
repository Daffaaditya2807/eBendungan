import 'dart:io';

import 'package:e_surat_bendungan/presentation/controller/letters/controller_sk_pembelian_solar.dart';
import 'package:e_surat_bendungan/presentation/widgets/button.dart';
import 'package:e_surat_bendungan/presentation/widgets/text_fields.dart';
import 'package:e_surat_bendungan/res/margin.dart';
import 'package:e_surat_bendungan/res/page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../res/colors.dart';
import '../../../res/fonts_style.dart';
import '../../../res/size.dart';

class SkPembelianSolarScree extends StatelessWidget {
  SkPembelianSolarScree({super.key});

  final controller = Get.put(ControllerSkPembelianSolar());

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
                "SK Pembelian Solar",
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
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              bigHeight(),
              Obx(() => InkWell(
                    onTap: () {
                      controller.pickImage(ImageSource.gallery);
                    },
                    child: controller.croppedFile.value == null
                        ? uploadDocument(
                            requiredText: '*', label: "Unggah Foto Pendukung")
                        : containesDocument(
                            File(controller.croppedFile.value!.path),
                            requiredText: '*',
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
                "Nama",
                "Youndaime",
                controller.controllerNama,
                context,
                requiredText: "*",
                typeInput: TextInputType.text,
              ),
              textFieldInput(
                  "NIK", "351717128XXX", controller.controllerNIK, context,
                  lenght: 16,
                  requiredText: "*",
                  typeInput: TextInputType.number,
                  formatter: [FilteringTextInputFormatter.digitsOnly]),
              textFieldInput(
                "Tanggal Lahir",
                "12/12/2000",
                controller.controllerTanggalLahir,
                context,
                requiredText: "*",
                readOnly: true,
                function: () {
                  controller.selectDate(context);
                },
              ),
              textFieldInput(
                  "Tempat Lahir",
                  "Jombang",
                  requiredText: "*",
                  controller.controllerTempatLahir,
                  context,
                  typeInput: TextInputType.text),
              textFieldInput(
                  "Alamat",
                  "Dsn. Kepatihan RT XX",
                  requiredText: "*",
                  controller.controllerAlamat,
                  context,
                  typeInput: TextInputType.emailAddress),
              Obx(() => controller.isLoading.value
                  ? Center(
                      child: CircularProgressIndicator(
                      color: greenPrimary,
                    ))
                  : buttonPrimary("Buat", () {
                      controller.insertPembelianSolar();
                    })),
              bigHeight()
            ],
          ),
        ));
  }
}
