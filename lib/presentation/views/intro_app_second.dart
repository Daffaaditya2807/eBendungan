import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../config/routes.dart';
import '../../res/colors.dart';
import '../../res/fonts_style.dart';
import '../../res/margin.dart';
import '../../res/page.dart';
import '../../res/size.dart';
import '../widgets/button.dart';

class IntroAppSecond extends StatelessWidget {
  const IntroAppSecond({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return bodyApp(
        child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/image/privacy.png',
            scale: 5,
          ),
          Text(
            "Ketentuan Aplikasi",
            style:
                boldFont.copyWith(color: greenPrimary, fontSize: bigFontSize),
          ),
          Text(
            "Aplikasi digunakan untuk pengajuan surat data yang diberikan hanya untuk validasi aplikasi dan surat yang diajukan",
            textAlign: TextAlign.center,
            style: regularFont.copyWith(
                color: greyPrimary, fontSize: mediumFontSize),
          ),
          bigHeight(),
          buttonPrimary("Mengerti", () {
            Get.toNamed(Routes.loginScreen);
          })
        ],
      ),
    ));
  }
}
