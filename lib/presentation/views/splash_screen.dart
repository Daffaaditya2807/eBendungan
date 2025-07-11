import 'package:e_surat_bendungan/presentation/controller/controller_splash_screen.dart';
import 'package:e_surat_bendungan/res/fonts_style.dart';
import 'package:e_surat_bendungan/res/margin.dart';
import 'package:e_surat_bendungan/res/page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});

  final controller = Get.put(ControllerSplashScreen());

  @override
  Widget build(BuildContext context) {
    return bodyApp(
        child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/image/jombang2.png"),
          mediumHeight(),
          componenRichBoldTextStyle("e", "Bendungan", () {})
        ],
      ),
    ));
  }
}
