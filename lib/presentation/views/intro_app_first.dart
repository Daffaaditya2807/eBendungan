import 'package:e_surat_bendungan/presentation/widgets/button.dart';
import 'package:e_surat_bendungan/res/colors.dart';
import 'package:e_surat_bendungan/res/fonts_style.dart';
import 'package:e_surat_bendungan/res/margin.dart';
import 'package:e_surat_bendungan/res/page.dart';
import 'package:e_surat_bendungan/res/size.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../config/routes.dart';

class IntroAppFirst extends StatelessWidget {
  const IntroAppFirst({super.key});

  @override
  Widget build(BuildContext context) {
    return bodyApp(
        child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/image/image1.png'),
          Text(
            "Urus Dokumen Keperluan Anda",
            style:
                boldFont.copyWith(color: greenPrimary, fontSize: bigFontSize),
          ),
          Text(
            "Banyak layanan surat pada aplikasi sesuai dokumen yang anda perlukan",
            textAlign: TextAlign.center,
            style: regularFont.copyWith(
                color: greyPrimary, fontSize: mediumFontSize),
          ),
          bigHeight(),
          buttonPrimary("Lanjut", () {
            Get.toNamed(Routes.introLastScreen);
          })
        ],
      ),
    ));
  }
}
