import 'package:e_surat_bendungan/config/routes.dart';
import 'package:e_surat_bendungan/presentation/controller/controller_login.dart';
import 'package:e_surat_bendungan/presentation/widgets/button.dart';
import 'package:e_surat_bendungan/presentation/widgets/text_fields.dart';
import 'package:e_surat_bendungan/res/colors.dart';
import 'package:e_surat_bendungan/res/fonts_style.dart';
import 'package:e_surat_bendungan/res/margin.dart';
import 'package:e_surat_bendungan/res/page.dart';
import 'package:e_surat_bendungan/res/size.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final controller = Get.put(ControllerLogin());

  @override
  Widget build(BuildContext context) {
    return bodyApp(
        child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: Container()),
          Text(
            "Masuk Aplikasi",
            style:
                boldFont.copyWith(color: greenPrimary, fontSize: bigFontSize),
          ),
          Text(
            "Silakan Masukan Akun Anda",
            style: regularFont.copyWith(
                color: greyPrimary, fontSize: mediumFontSize),
          ),
          bigHeight(),
          textFieldInput(
              "Nomer Hp", "08123456XXX", controller.controllerName, context,
              lenght: 13,
              typeInput: TextInputType.number,
              formatter: [FilteringTextInputFormatter.digitsOnly]),
          Obx(() => textFieldPassword(
                "Kata Sandi",
                "XXXXXXXXXX",
                controller.isShow.value,
                controller.controllerPassword,
                context,
                controller.isShow.value
                    ? Icons.visibility
                    : Icons.visibility_off,
                controller.showHidePassword,
                typeInput: TextInputType.visiblePassword,
              )),
          Align(
            alignment: Alignment.topRight,
            child: InkWell(
              onTap: () {
                Get.toNamed(Routes.forgetPassword);
              },
              child: Text(
                "Lupa Sandi?",
                style: regularFont.copyWith(color: greyPrimary),
              ),
            ),
          ),
          bigHeight(),
          Obx(() => controller.isLoading.value
              ? CircularProgressIndicator(
                  color: greenPrimary,
                )
              : buttonPrimary("Masuk", () async {
                  if (controller.controllerName.text.isEmpty ||
                      controller.controllerPassword.text.isEmpty) {
                    Get.snackbar(
                        "Gagal Login", "Harap isi no telepon atau password");
                  } else {
                    final isLogin = await controller.login(
                        noTelp: controller.controllerName.text,
                        password: controller.controllerPassword.text);
                    if (isLogin == true) {
                      Get.toNamed(Routes.navBarScreen);
                    } else {
                      if (controller.error.value ==
                          'user belum terverifikasi') {
                        Get.offNamed(Routes.otpScreen, arguments: {
                          'email': controller.user.value?.email.toString(),
                          'name': controller.user.value?.nama.toString(),
                          'id_user': controller.user.value!.idUser.toString(),
                          'otp': 'register'
                        });
                      } else {
                        Get.snackbar("Gagal Login", controller.error.value);
                      }
                    }
                  }
                })),
          mediumHeight(),
          componenRichTextStyle("Belum Punya Akun? ", "Daftar", () {
            Get.toNamed(Routes.registerScreen);
          }),
          Expanded(child: Container()),
          InkWell(
              onTap: () {
                Get.toNamed(Routes.informationVillageGuest);
              },
              child: Text(
                "Lihat berita ->",
                style: regularFont.copyWith(color: greyPrimary),
              )),
          mediumHeight()
        ],
      ),
    ));
  }
}
