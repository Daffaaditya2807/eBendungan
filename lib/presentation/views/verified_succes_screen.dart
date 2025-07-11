import 'package:e_surat_bendungan/res/page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../config/routes.dart';
import '../../res/colors.dart';
import '../../res/fonts_style.dart';
import '../../res/margin.dart';
import '../../res/size.dart';
import '../widgets/button.dart';

class VerifiedSuccesScreen extends StatelessWidget {
  const VerifiedSuccesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return bodyApp(
        child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/image/image1.png'),
          Text(
            "Verifikasi Akun Berhasil",
            style:
                boldFont.copyWith(color: greenPrimary, fontSize: bigFontSize),
          ),
          Text(
            "Akun berhasil dibuat  dan sudah terverifikasi pengguna dapat masuk dalam aplikasi untuk menggunakan fitur fitur yang ada",
            textAlign: TextAlign.center,
            style: regularFont.copyWith(
                color: greyPrimary, fontSize: mediumFontSize),
          ),
          bigHeight(),
          buttonPrimary("Selesai", () {
            Get.toNamed(Routes.loginScreen);
          })
        ],
      ),
    ));
  }
}
