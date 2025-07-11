import 'package:e_surat_bendungan/config/routes.dart';
import 'package:e_surat_bendungan/presentation/controller/controller_otp.dart';
import 'package:e_surat_bendungan/presentation/widgets/button.dart';
import 'package:e_surat_bendungan/res/colors.dart';
import 'package:e_surat_bendungan/res/fonts_style.dart';
import 'package:e_surat_bendungan/res/margin.dart';
import 'package:e_surat_bendungan/res/page.dart';
import 'package:e_surat_bendungan/res/rounded.dart';
import 'package:e_surat_bendungan/res/size.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

class OtpScreen extends StatefulWidget {
  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final controller = Get.put(ControllerOtp());

  final String emailUser = Get.arguments['email'];
  final String nameUser = Get.arguments['name'];
  final String idUser = Get.arguments['id_user'].toString();
  final String otp = Get.arguments['otp'];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.sendEmail(context, emailUser, nameUser);
  }

  @override
  Widget build(BuildContext context) {
    return bodyApp(
        child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: Container()),
          Text(
            "Kode OTP",
            style:
                boldFont.copyWith(color: greenPrimary, fontSize: bigFontSize),
          ),
          Text(
            "Periksa email yang didaftarkan dan dapatkan kode OTP",
            textAlign: TextAlign.center,
            style: regularFont.copyWith(
                color: greyPrimary, fontSize: mediumFontSize),
          ),
          bigHeight(),
          // Expanded(child: Container()),
          Text(
            "Kode OTP dikirimkan pada",
            textAlign: TextAlign.center,
            style: regularFont.copyWith(
                color: greyPrimary, fontSize: mediumFontSize),
          ),
          Text(
            emailUser,
            style: boldFont.copyWith(
                color: greenPrimary, fontSize: mediumFontSize),
          ),
          bigHeight(),
          Pinput(
            length: 4,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            crossAxisAlignment: CrossAxisAlignment.center,
            controller: controller.controllerOtp,
            onCompleted: (value) async {
              if (controller.emailVerificationCode.value.toString() ==
                  controller.controllerOtp.text) {
                if (otp == 'register') {
                  final isVerified =
                      await controller.verifikasiUser(idUser: idUser);
                  if (isVerified) {
                    Get.offAllNamed(Routes.verifiedAccount);
                  }
                } else {
                  Get.toNamed(Routes.resetPassword,
                      arguments: {'email': emailUser});
                }
              }
            },
            defaultPinTheme: PinTheme(
                textStyle: regularFont.copyWith(
                  fontSize: bigFontSize,
                ),
                decoration: BoxDecoration(
                    color: Color(0xfff2f2f2),
                    // border: Border.all(color: greyPrimary),
                    borderRadius: borderRoundedMedium),
                width: 50,
                height: 50),
            focusedPinTheme: PinTheme(
                textStyle: boldFont.copyWith(
                  fontSize: bigFontSize,
                ),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: greenPrimaryDarker),
                    borderRadius: borderRoundedMedium),
                width: 50,
                height: 50),
            submittedPinTheme: PinTheme(
                textStyle: boldFont.copyWith(
                  fontSize: bigFontSize,
                ),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: greenPrimary),
                    borderRadius: borderRoundedMedium),
                width: 50,
                height: 50),
            errorTextStyle: regularFont.copyWith(
                color: redPrimary, fontSize: regularFontSize),
            validator: (value) {
              return value == controller.emailVerificationCode.value.toString()
                  ? null
                  : 'Kode OTP Tidak Sama';
            },
            pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
            showCursor: true,
          ),
          bigHeight(),
          Obx(() => controller.countdown.value == 0
              ? Container()
              : Text(
                  "Belum menerima kode?\nKirim ulang setelah ${controller.countdown.value} detik",
                  textAlign: TextAlign.center,
                  style: regularFont.copyWith(
                      color: greyPrimary, fontSize: mediumFontSize),
                )),
          Obx(() {
            if (controller.candSendEmail.value) {
              return controller.isLoading.value
                  ? CircularProgressIndicator(
                      color: greenPrimary,
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: buttonPrimary("Kirim Ulang", () {
                        if (controller.candSendEmail.value) {
                          controller.sendEmail(context, emailUser, nameUser);
                        }
                      }),
                    );
            } else {
              return Container();
            }
          }),
          Expanded(child: Container()),
        ],
      ),
    ));
  }
}
