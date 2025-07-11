import 'package:e_surat_bendungan/config/routes.dart';
import 'package:e_surat_bendungan/presentation/widgets/button.dart';
import 'package:e_surat_bendungan/res/colors.dart';
import 'package:e_surat_bendungan/res/fonts_style.dart';
import 'package:e_surat_bendungan/res/margin.dart';
import 'package:e_surat_bendungan/res/page.dart';
import 'package:e_surat_bendungan/res/size.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IntroAppLast extends StatelessWidget {
  const IntroAppLast({super.key});

  @override
  Widget build(BuildContext context) {
    return bodyApp(
        child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/image/image2.png'),
          Text(
            "Baca Berita Dari Aktivitas Desa",
            style:
                boldFont.copyWith(color: greenPrimary, fontSize: bigFontSize),
          ),
          Text(
            "Baca berita terupdate dari aktivitas yang terdapat pada Desa agar tidak ketinggalan informasi",
            textAlign: TextAlign.center,
            style: regularFont.copyWith(
                color: greyPrimary, fontSize: mediumFontSize),
          ),
          bigHeight(),
          buttonPrimary("Lanjut", () {
            Get.toNamed(Routes.introSecondScreen);
          })
        ],
      ),
    ));
  }
}
