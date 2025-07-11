import 'package:e_surat_bendungan/presentation/controller/controller_reset_password.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../config/routes.dart';
import '../../res/colors.dart';
import '../../res/fonts_style.dart';
import '../../res/margin.dart';
import '../../res/page.dart';
import '../../res/size.dart';
import '../widgets/button.dart';
import '../widgets/text_fields.dart';

class ResetPassword extends StatelessWidget {
  ResetPassword({super.key});

  final controller = Get.put(ControllerResetPassword());
  final email = Get.arguments['email'];

  @override
  Widget build(BuildContext context) {
    return bodyApp(
        child: Column(
      children: [
        bigHeight(),
        bigHeight(),
        bigHeight(),
        Text(
          "Atur Ulang Sandi",
          style: boldFont.copyWith(color: greenPrimary, fontSize: bigFontSize),
        ),
        Text(
          "P3ngguna dapat mengatur ulang kata sandi dan harap agar selalu diingat kembali",
          textAlign: TextAlign.center,
          style: regularFont.copyWith(
              color: greyPrimary, fontSize: mediumFontSize),
        ),
        bigHeight(),
        bigHeight(),
        bigHeight(),
        textFieldInput("Kata Sandi Baru", "XXXXXXXX",
            controller.controllerPassword, context),
        textFieldInput("Ulangi Sandi", "XXXXXXXX",
            controller.controllerConfirmPassword, context),
        mediumHeight(),
        Expanded(child: Container()),
        Obx(() => controller.isLoading.value
            ? CircularProgressIndicator(
                color: greenPrimary,
              )
            : buttonPrimary("Ubah Sandi", () async {
                if (controller.controllerPassword.text.isEmpty ||
                    controller.controllerConfirmPassword.text.isEmpty) {
                } else {
                  if (controller.controllerPassword.text.length < 6) {
                    Get.snackbar("Gagal Reset Sandi",
                        "Panjang Sandi minimal 6 karakter");
                  } else {
                    final isReset = await controller.resetPassword(
                        email: email,
                        password: controller.controllerConfirmPassword.text,
                        confirmPassword:
                            controller.controllerConfirmPassword.text);
                    if (isReset) {
                      Get.offAllNamed(Routes.loginScreen);
                    } else {
                      Get.snackbar("Gagal", controller.errorMessage.value);
                    }
                  }
                }
              })),
        bigHeight(),
        bigHeight(),
        bigHeight(),
      ],
    ));
  }
}
