import 'package:e_surat_bendungan/presentation/controller/controller_webview.dart';
import 'package:e_surat_bendungan/presentation/widgets/button.dart';
import 'package:e_surat_bendungan/res/margin.dart';
import 'package:e_surat_bendungan/res/page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../res/colors.dart';
import '../../res/fonts_style.dart';
import '../../res/size.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return bodyApp(
        appbar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          title: Text(
            "Kebijakan Privasi",
            style: boldFont.copyWith(
                color: greenPrimary, fontSize: superBigFontSize),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text(
            //   "Aplikasi ini mengumpulkan beberapa data pribadi pengguna untuk keperluan registrasi dan validasi pengajuan surat.",
            //   textAlign: TextAlign.justify,
            //   style: regularFont.copyWith(fontSize: 16),
            // ),
            bigHeight(),
            Text(
              "Data yang dikumpulkan",
              style:
                  boldFont.copyWith(color: greenPrimary, fontSize: bigFontSize),
            ),
            Text(
              "1.Nomor HP dan Email: digunakan untuk registrasi dan validasi pengguna.\n"
              "2.NIK, Gambar, Tanggal Lahir, Tempat Lahir, Agama, Suku, dan Pekerjaan: digunakan untuk memverifikasi identitas saat pengajuan surat.",
              textAlign: TextAlign.justify,
              style: regularFont.copyWith(
                  color: greyPrimary, fontSize: mediumFontSize),
            ),
            SizedBox(height: 12),
            Text(
              "Penggunaan Gambar",
              style:
                  boldFont.copyWith(color: greenPrimary, fontSize: bigFontSize),
            ),
            Text(
              "Gambar yang dikirimkan hanya dapat diakses oleh admin desa dan tidak akan dibagikan kepada pihak lain.",
              textAlign: TextAlign.justify,
              style: regularFont.copyWith(
                  color: greyPrimary, fontSize: mediumFontSize),
            ),
            SizedBox(height: 12),
            Text(
              "Penghapusan Data dan Kendala",
              style:
                  boldFont.copyWith(color: greenPrimary, fontSize: bigFontSize),
            ),
            Text(
              "Jika Anda ingin menghapus data atau mengalami kendala terkait penggunaan aplikasi, silakan hubungi developer di nomor: 085851065295.",
              textAlign: TextAlign.justify,
              style: regularFont.copyWith(
                  color: greyPrimary, fontSize: mediumFontSize),
            ),
            SizedBox(height: 12),
            Text(
              "Persetujuan",
              style:
                  boldFont.copyWith(color: greenPrimary, fontSize: bigFontSize),
            ),
            Text(
              "Dengan menggunakan aplikasi ini, Anda menyetujui pengumpulan dan penggunaan data sesuai kebijakan ini.",
              textAlign: TextAlign.justify,
              style: regularFont.copyWith(
                  color: greyPrimary, fontSize: mediumFontSize),
            ),
            Expanded(child: Container()),
            Align(
              alignment: Alignment.center,
              child: Text(
                "Contact Developper & Website Desa Bendungan",
                textAlign: TextAlign.center,
                style: regularFont.copyWith(
                    color: Colors.black, fontSize: bigFontSize),
              ),
            ),
            mediumHeight(),
            Row(
              children: [
                Expanded(
                  child: buttonPrimary("Hubungi Developper", () async {
                    openWhatsApp();
                  }),
                ),
                mediumwidth(),
                Expanded(
                  child: buttonPrimary("Buka Halaman Website", () {
                    Get.to(() => const WebViewScreen());
                  }),
                )
              ],
            ),
            bigHeight(),
            bigHeight()
          ],
        ));
  }

  void openWhatsApp() async {
    final phoneNumber = '085851065295';
    final message = Uri.encodeComponent("Halo, saya ingin menanyakan sesuatu.");
    final url =
        Uri.parse("https://wa.me/62${phoneNumber.substring(1)}?text=$message");

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Tidak dapat membuka WhatsApp.';
    }
  }
}

class WebViewScreen extends GetView<ControllerWebview> {
  const WebViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ControllerWebview()); // Inisialisasi controller
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Website Desa Bendungan',
          style: regularFont,
        ),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: controller.webViewController),
          Obx(
            () => controller.loadingProgress.value < 100
                ? LinearProgressIndicator(
                    value: controller.loadingProgress.value / 100,
                    backgroundColor: Colors.grey[200],
                    color: greenPrimary,
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
