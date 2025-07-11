import 'dart:io';

import 'package:e_surat_bendungan/presentation/controller/letters/controller_sk_kehilangan.dart';
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

class SkKehilangan extends StatelessWidget {
  SkKehilangan({super.key});
  final controller = Get.put(ControllerSkKehilangan());
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
                "SK Kehilangan",
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
                    onTap: () => controller.pickImage(ImageSource.gallery),
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
                  "NIK", "351717128XXX", controller.controllerNik, context,
                  requiredText: "*",
                  lenght: 16,
                  typeInput: TextInputType.number,
                  formatter: [FilteringTextInputFormatter.digitsOnly]),
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
                controller.controllerTglLahir,
                requiredText: "*",
                context,
                readOnly: true,
                function: () => controller.selectDate(context),
              ),
              textFieldInput("Tempat Lahir", "Jombang",
                  controller.controllerTempatLahir, context,
                  requiredText: "*", typeInput: TextInputType.text),
              textFieldInput("Alamat", "Dsn. Kepatihan RT XX RW XX",
                  controller.controllerTempatAlamat, context,
                  requiredText: "*", typeInput: TextInputType.streetAddress),
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
                      }).toList(), (newValue) {
                    controller.selectedJenisKelamin.value = newValue.toString();
                  }, context,
                      counter: null,
                      value: controller.selectedJenisKelamin.value.isEmpty
                          ? null
                          : controller.selectedJenisKelamin.value)),
              Obx(() => dropDownTextField(
                      "Agama",
                      "Pilih Agama",
                      requiredText: "*",
                      controller.agamaList
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: regularFont,
                            ));
                      }).toList(), (newValue) {
                    controller.selectedAgama.value = newValue.toString();
                  }, context,
                      value: controller.selectedAgama.value.isEmpty
                          ? null
                          : controller.selectedAgama.value)),
              textFieldInput(
                  "Pekerjaan",
                  "Mahasiswa",
                  requiredText: "*",
                  controller.controllerPekerjaan,
                  context),
              textFieldInput(
                  "Keterangan",
                  "Kehilangan KK, KTP",
                  requiredText: "*",
                  controller.controllerKeterangan,
                  context),
              Obx(() => controller.isLoading.value
                  ? CircularProgressIndicator(
                      color: greenPrimary,
                    )
                  : buttonPrimary("Buat", () {
                      controller.insertKeteranganKehilangan();
                    })),
              mediumHeight()
            ],
          ),
        ));
  }
}
