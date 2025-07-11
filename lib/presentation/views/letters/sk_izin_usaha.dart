import 'dart:io';

import 'package:e_surat_bendungan/presentation/controller/letters/controller_sk_izin_usaha.dart';
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

class SkIzinUsaha extends StatelessWidget {
  SkIzinUsaha({super.key});
  final controller = Get.put(ControllerSkIzinUsaha());

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
                "SK Izin Usaha",
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
              Obx(() {
                return InkWell(
                  onTap: () {
                    // final controllerPickImage = Get.put(ControllerPickImage());
                    controller.pickImage(ImageSource.gallery);
                  },
                  child: controller.croppedFile.value == null
                      ? uploadDocument(
                          requiredText: "*", label: "Unggah Foto Pendukung")
                      : containesDocument(
                          File(controller.croppedFile.value!.path),
                          requiredText: "*",
                          label: "Unggah Foto Pendukung"),
                );
              }),
              smallHeight(),
              Text(
                "*Data atau foto yang diunggah hanya untuk verifikasi surat, hanya admin yang dapat mengakses",
                style: regularFont.copyWith(
                    color: greyPrimary, fontSize: smallFontSize),
              ),
              mediumHeight(),
              textFieldInput(
                  "Nama", "Youndaime", controller.controllerNama, context,
                  requiredText: "*",
                  typeInput: TextInputType.name,
                  formatter: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]'))
                  ]),
              textFieldInput(
                "Tanggal Lahir",
                "12/02/2002",
                requiredText: "*",
                controller.controllerTglLahir,
                context,
                readOnly: true,
                function: () => controller.selectDate(context),
              ),
              textFieldInput(
                  "NIK", "351717XXX", controller.controllerNik, context,
                  requiredText: "*",
                  lenght: 16,
                  typeInput: TextInputType.number,
                  formatter: [FilteringTextInputFormatter.digitsOnly]),
              textFieldInput(
                  "Tempat Lahir",
                  "Jombang",
                  requiredText: "*",
                  controller.controllerTempatLahir,
                  context),
              textFieldInput(
                  "Usaha",
                  "Toko Kelontong",
                  requiredText: "*",
                  controller.controllerUsaha,
                  context),
              textFieldInput(
                  "Pekerjaan",
                  "Wiraswasta",
                  requiredText: "*",
                  controller.controllerPekerjaan,
                  context),
              textFieldInput(
                  "Alamat",
                  "Dsn. Kepatihan RT XX RW XX",
                  requiredText: "*",
                  controller.controllerTempatAlamat,
                  context),
              Obx(() => controller.isLoading.value
                  ? CircularProgressIndicator(
                      color: greenPrimary,
                    )
                  : buttonPrimary("Buat", () {
                      controller.insertIzinUsaha();
                    })),
              mediumHeight()
            ],
          ),
        ));
  }
}
