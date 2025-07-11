import 'package:e_surat_bendungan/config/routes.dart';
import 'package:e_surat_bendungan/presentation/controller/controller_shared_prefs.dart';
import 'package:e_surat_bendungan/presentation/widgets/button.dart';
import 'package:e_surat_bendungan/res/page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../config/fcm_service.dart';
import '../../res/colors.dart';
import '../../res/fonts_style.dart';
import '../../res/margin.dart';
import '../../res/size.dart';

// ignore: must_be_immutable
class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final sharedPrefsController = Get.find<ControllerSharedPrefs>();
  FcmService fcmService = FcmService();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  Widget build(BuildContext context) {
    return bodyApp(
        child: Column(
      children: [
        bigHeight(),
        Center(
          child: Text(
            "Profil",
            style: boldFont.copyWith(
                color: greenPrimaryDarker, fontSize: superBigFontSize),
          ),
        ),
        bigHeight(),
        Center(
          child: ClipOval(
            child: Container(
              width: 120,
              height: 120,
              color: Colors.white, // Warna latar jika gambar kosong
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.network(
                  sharedPrefsController.user.value?.fotoProfil ?? "",
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        bigHeight(),
        Obx(() => Text(
              sharedPrefsController.user.value?.nama ?? '',
              style: boldFont.copyWith(
                  color: greenPrimaryDarker, fontSize: bigFontSize),
            )),
        Text(
          sharedPrefsController.user.value?.email ?? '',
          style: regularFont.copyWith(
              color: greyPrimary, fontSize: mediumFontSize),
        ),
        mediumHeight(),
        Divider(),
        bigHeight(),
        buttonSetting("Ubah Profil", () {
          Get.toNamed(Routes.ubahProfil);
        }, Icons.person_3_rounded),
        bigHeight(),
        buttonSetting("Ubah Kata Sandi", () {
          Get.toNamed(Routes.ubahSandi);
        }, Icons.key),
        bigHeight(),
        buttonSetting("Tentang Desa", () {
          Get.toNamed(Routes.aboutVillage);
        }, Icons.info),
        bigHeight(),
        buttonSetting("Kebijakan Privasi", () {
          Get.toNamed(Routes.privacyVillage);
        }, Icons.policy),
        bigHeight(),
        buttonSetting("Keluar Aplikasi", () {
          Get.defaultDialog(
              title: "Konfirmasi",
              titleStyle:
                  boldFont.copyWith(fontSize: bigFontSize, color: greenPrimary),
              backgroundColor: Colors.white,
              content: Column(
                children: [
                  Text("Ingin Keluar Aplikasi?"),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: TextButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      WidgetStatePropertyAll(redPrimary),
                                  shape: WidgetStatePropertyAll(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)))),
                              onPressed: () async {
                                String? token =
                                    await _firebaseMessaging.getToken();
                                if (token != null) {
                                  // Hapus token dari server
                                  await fcmService.deleteTokenFromServer(token);
                                }
                                // Bersihkan data pengguna lokal
                                await Get.find<ControllerSharedPrefs>()
                                    .clearUser();
                                // Arahkan ke halaman login
                                Get.offAllNamed(Routes.loginScreen);
                              },
                              child: Text(
                                "Iya",
                                style:
                                    regularFont.copyWith(color: Colors.white),
                              ))),
                      mediumwidth(),
                      Expanded(
                          child: TextButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      WidgetStatePropertyAll(greenPrimary),
                                  shape: WidgetStatePropertyAll(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)))),
                              onPressed: () async {
                                Get.back();
                              },
                              child: Text(
                                "Tidak",
                                style:
                                    regularFont.copyWith(color: Colors.white),
                              ))),
                    ],
                  ),
                ],
              ));
        }, Icons.logout)
      ],
    ));
  }
}
