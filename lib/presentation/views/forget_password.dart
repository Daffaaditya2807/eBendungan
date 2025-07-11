import 'package:e_surat_bendungan/config/routes.dart';
import 'package:e_surat_bendungan/presentation/controller/controller_forget_password.dart';
import 'package:e_surat_bendungan/presentation/widgets/button.dart';
import 'package:e_surat_bendungan/presentation/widgets/text_fields.dart';
import 'package:e_surat_bendungan/res/margin.dart';
import 'package:e_surat_bendungan/res/page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../res/colors.dart';
import '../../res/fonts_style.dart';
import '../../res/size.dart';

class ForgetPassword extends StatelessWidget {
  ForgetPassword({super.key});

  final controller = Get.put(ControllerForgetPassword());

  @override
  Widget build(BuildContext context) {
    return bodyApp(
        child: Column(
      children: [
        bigHeight(),
        bigHeight(),
        bigHeight(),
        Text(
          "Lupa Sandi",
          style: boldFont.copyWith(color: greenPrimary, fontSize: bigFontSize),
        ),
        Text(
          "Pastikan email sudah terdaftar maka dapat mengatur ulang kata sandi akun",
          textAlign: TextAlign.center,
          style: regularFont.copyWith(
              color: greyPrimary, fontSize: mediumFontSize),
        ),
        bigHeight(),
        bigHeight(),
        textFieldInput("Email Terdaftar", "pengguna@gmail.com",
            controller.controllerPassowrd, context,
            typeInput: TextInputType.emailAddress),
        mediumHeight(),
        Obx(() => controller.errorMesage.value == 'ok'
            ? Text(
                "akun tidak ditemukan atau belum terdaftar pada aplikasi sebelumnya",
                textAlign: TextAlign.center,
                style: regularFont.copyWith(
                    color: redPrimary, fontSize: mediumFontSize),
              )
            : Container()),
        Expanded(child: Container()),
        Obx(
          () => controller.isLoading.value
              ? CircularProgressIndicator(
                  color: greenPrimary,
                )
              : buttonPrimary("Periksa Email", () async {
                  if (controller.controllerPassowrd.text.isEmpty) {
                    Get.snackbar(
                        "Pengguna Tidak ditemukan", "Harap isi kolom email");
                  } else {
                    final isCheckEmail = await controller.checkPassword(
                        email: controller.controllerPassowrd.text);
                    if (isCheckEmail) {
                      Get.toNamed(Routes.otpScreen, arguments: {
                        'email': controller.user.value?.email.toString(),
                        'name': controller.user.value?.nama.toString(),
                        'id_user': controller.user.value!.idUser.toString(),
                        'otp': 'resetpassword'
                      });
                    } else {
                      Get.snackbar("Gagal", controller.errorMesage.value);
                    }
                  }
                }),
        ),
        bigHeight(),
        bigHeight(),
        bigHeight(),
      ],
    ));
  }
}
