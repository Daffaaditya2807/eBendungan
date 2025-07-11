import 'package:e_surat_bendungan/config/routes.dart';
import 'package:e_surat_bendungan/presentation/controller/controller_register.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../res/colors.dart';
import '../../res/fonts_style.dart';
import '../../res/margin.dart';
import '../../res/page.dart';
import '../../res/size.dart';
import '../widgets/button.dart';
import '../widgets/text_fields.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final controller = Get.put(ControllerRegister());

  @override
  Widget build(BuildContext context) {
    return bodyApp(
        child: Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Daftar Pengguna",
              style:
                  boldFont.copyWith(color: greenPrimary, fontSize: bigFontSize),
            ),
            Text(
              "Silakan Masukan Data Yang Ingin Didaftarkan",
              style: regularFont.copyWith(
                  color: greyPrimary, fontSize: mediumFontSize),
            ),
            bigHeight(),
            textFieldInput(
                "Nama", "Youndaime", controller.controllerName, context,
                requiredText: '*',
                typeInput: TextInputType.name,
                formatter: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]'))
                ]),
            textFieldInput(
                "Email",
                "pengguna@gmail.com",
                requiredText: '*',
                controller.controllerEmail,
                context,
                typeInput: TextInputType.emailAddress),
            textFieldInput(
                "Nomer Hp", "08123456XXX", controller.controllerPhone, context,
                requiredText: '*',
                lenght: 13,
                typeInput: TextInputType.number,
                formatter: [FilteringTextInputFormatter.digitsOnly]),
            Obx(() => textFieldPassword(
                "Kata Sandi",
                "XXXXXXXXXX",
                requiredText: '*',
                controller.isShowPassword.value,
                controller.controllerPassword,
                context,
                typeInput: TextInputType.visiblePassword,
                controller.isShowPassword.value
                    ? Icons.visibility
                    : Icons.visibility_off,
                controller.showHidePassword)),
            Obx(() => textFieldPassword(
                "Ulangi Kata Sandi",
                "XXXXXXXXXX",
                requiredText: '*',
                controller.isShowConfirmPassword.value,
                controller.controllerConfirmPassword,
                context,
                typeInput: TextInputType.visiblePassword,
                controller.isShowConfirmPassword.value
                    ? Icons.visibility
                    : Icons.visibility_off,
                controller.showHideConfirmPassword)),
            Obx(() => controller.isLoading.value
                ? CircularProgressIndicator(
                    color: greenPrimary,
                  )
                : buttonPrimary("Daftar", () async {
                    if (controller.controllerName.text.isEmpty ||
                        controller.controllerEmail.text.isEmpty ||
                        controller.controllerPhone.text.isEmpty ||
                        controller.controllerPassword.text.isEmpty ||
                        controller.controllerConfirmPassword.text.isEmpty) {
                      Get.snackbar("Gagal Register", "Semua kolom harus diisi");
                    } else if (controller.controllerPassword.text.length < 6) {
                      Get.snackbar("Gagal Register",
                          "Panjang Password Minimal 6 karakter");
                    } else {
                      Get.defaultDialog(
                          title: "Konfirmasi",
                          titleStyle: regularFont.copyWith(
                              fontSize: bigFontSize,
                              color: greenPrimary,
                              fontWeight: FontWeight.bold),
                          backgroundColor: Colors.white,
                          content: Column(
                            children: [
                              Text(
                                "Data yang digunakan nama,email,password,nomor HP hanya untuk verifikasi akun saja",
                                textAlign: TextAlign.center,
                                style: regularFont.copyWith(color: greyPrimary),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Obx(() => controller.isLoading.value
                                  ? CircularProgressIndicator(
                                      color: greenPrimary,
                                    )
                                  : Row(
                                      children: [
                                        Expanded(
                                            child: TextButton(
                                                style: ButtonStyle(
                                                    backgroundColor:
                                                        WidgetStatePropertyAll(
                                                            greenPrimary),
                                                    shape: WidgetStatePropertyAll(
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)))),
                                                onPressed: () async {
                                                  final isLogin =
                                                      await controller.register(
                                                          name:
                                                              controller
                                                                  .controllerName
                                                                  .text,
                                                          email: controller
                                                              .controllerEmail
                                                              .text,
                                                          phone: controller
                                                              .controllerPhone
                                                              .text,
                                                          password: controller
                                                              .controllerPassword
                                                              .text,
                                                          confirmPassword:
                                                              controller
                                                                  .controllerConfirmPassword
                                                                  .text);

                                                  if (isLogin) {
                                                    Get.offNamed(
                                                        Routes.otpScreen,
                                                        arguments: {
                                                          'email': controller
                                                              .user.value?.email
                                                              .toString(),
                                                          'name': controller
                                                              .user.value?.nama
                                                              .toString(),
                                                          'id_user': controller
                                                              .user
                                                              .value!
                                                              .idUser
                                                              .toString(),
                                                          'otp': 'register'
                                                        });
                                                  } else if (controller
                                                          .error.value !=
                                                      '') {
                                                    Get.back();
                                                    Get.snackbar(
                                                        "Gagal Register",
                                                        controller.error.value
                                                            .toString());
                                                  } else {
                                                    Get.back();
                                                    Get.snackbar(
                                                        "Gagal Register",
                                                        "Terjadi error harap periksa format email, jumlah digit HP dan password minimal panjang 6");
                                                  }
                                                },
                                                child: Text(
                                                  "Mengerti",
                                                  style: regularFont.copyWith(
                                                      color: Colors.white),
                                                ))),
                                        mediumwidth(),
                                        Expanded(
                                            child: TextButton(
                                                style: ButtonStyle(
                                                    backgroundColor:
                                                        WidgetStatePropertyAll(
                                                            redPrimary),
                                                    shape: WidgetStatePropertyAll(
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)))),
                                                onPressed: () async {
                                                  Get.back();
                                                },
                                                child: Text(
                                                  "Tidak",
                                                  style: regularFont.copyWith(
                                                      color: Colors.white),
                                                ))),
                                      ],
                                    )),
                            ],
                          ));
                    }
                  })),
            mediumHeight(),
            componenRichTextStyle("Sudah Punya Akun? ", "Masuk", () {
              Get.offNamed(Routes.loginScreen);
            })
          ],
        ),
      ),
    ));
  }
}
