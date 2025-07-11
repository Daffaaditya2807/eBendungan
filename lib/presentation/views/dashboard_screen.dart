import 'package:e_surat_bendungan/config/routes.dart';
import 'package:e_surat_bendungan/presentation/controller/controller_dashboard.dart';
import 'package:e_surat_bendungan/presentation/controller/controller_information_village.dart';
import 'package:e_surat_bendungan/presentation/controller/controller_navigation_bar_screen.dart';
import 'package:e_surat_bendungan/presentation/widgets/button.dart';
import 'package:e_surat_bendungan/presentation/widgets/information.dart';
import 'package:e_surat_bendungan/res/colors.dart';
import 'package:e_surat_bendungan/res/fonts_style.dart';
import 'package:e_surat_bendungan/res/margin.dart';
import 'package:e_surat_bendungan/res/page.dart';
import 'package:e_surat_bendungan/res/size.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controller/controller_shared_prefs.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});

  final controllerNavbar = Get.put(ControllerNavigationBarScreen());
  final sharedPrefsController = Get.find<ControllerSharedPrefs>();
  final controllerBerita = Get.put(ControllerInformationVillage());
  final controller = Get.put(ControllerDashboard());

  Widget letterProcessList(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(
          child: CircularProgressIndicator(
            color: greenPrimary,
          ),
        );
      }

      if (controller.lettersToday.isEmpty) {
        return prosesLetterEmpty();
      }
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: controller.lettersToday.map((letter) {
            return prosesLetter(
                "${letter['type']} - ${letter['name']}",
                DateFormat('dd/MM/yyyy').format(DateTime.parse(letter['date'])),
                letter['status'],
                context);
          }).toList(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return bodyApp(
        child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          bigHeight(),
          Center(
            child: Text(
              "Halaman Utama",
              style: boldFont.copyWith(
                  color: greenPrimaryDarker, fontSize: superBigFontSize),
            ),
          ),
          bigHeight(),
          Text(
            "Halo!",
            style: regularFont.copyWith(
                color: greyPrimary, fontSize: mediumFontSize),
          ),
          Obx(() => Text(
                sharedPrefsController.user.value?.nama ?? "",
                style: boldFont.copyWith(
                    color: greenPrimaryDarker, fontSize: bigFontSize),
              )),
          bigHeight(),
          letterProcessList(context),
          bigHeight(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Surat Keterangan",
                style: boldFont.copyWith(
                    color: Colors.black, fontSize: bigFontSize),
              ),
              InkWell(
                onTap: () {
                  controllerNavbar.tabController?.jumpToTab(1);
                },
                child: Text(
                  "Lihat Selengkapnya ->",
                  style: regularFont.copyWith(
                      color: greyPrimary, fontSize: mediumFontSize),
                ),
              ),
            ],
          ),
          mediumHeight(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buttonMenu(Icons.gas_meter, "Pembelian Solar", () {
                Get.toNamed(Routes.skPembelianSolar);
              }),
              buttonMenu(Icons.find_in_page_outlined, "Kehilangan", () {
                Get.toNamed(Routes.skKehilangan);
              }),
              buttonMenu(Icons.person_off_sharp, "Kematian", () {
                Get.toNamed(Routes.skKematian);
              }),
              buttonMenu(Icons.poll_outlined, "Catatan Kepolisian", () {
                Get.toNamed(Routes.skCatatanKepolisian);
              })
            ],
          ),
          bigHeight(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Pengaduan",
                style: boldFont.copyWith(
                    color: Colors.black, fontSize: bigFontSize),
              ),
              InkWell(
                onTap: () => Get.toNamed(Routes.historyPengaduan),
                child: Text(
                  "Riwayat Pengaduan->",
                  style: regularFont.copyWith(
                      color: greyPrimary, fontSize: mediumFontSize),
                ),
              ),
            ],
          ),
          mediumHeight(),
          Row(
            children: [
              Expanded(
                  child: buttonPengaduan("Aspirasi", () {
                Get.toNamed(Routes.aspirasiScreen);
              }, greenPrimary, Icons.label_important_outline_rounded)),
              mediumwidth(),
              Expanded(
                  child: buttonPengaduan("Keluhan", () {
                Get.toNamed(Routes.keluhanScreen);
              }, redPrimaryLighter, Icons.draw_outlined)),
            ],
          ),
          mediumHeight(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Berita",
                style: boldFont.copyWith(
                    color: Colors.black, fontSize: bigFontSize),
              ),
              InkWell(
                onTap: () {
                  controllerBerita
                      .resetFilter(); // Reset filter before navigating
                  Get.toNamed(Routes.informationVillage);
                },
                child: Text(
                  "Lainnya->",
                  style: regularFont.copyWith(
                      color: greyPrimary, fontSize: mediumFontSize),
                ),
              ),
            ],
          ),
          mediumHeight(),
          SizedBox(
            height: 230,
            child: Obx(() {
              if (controllerBerita.isLoading.value) {
                return Center(
                    child: CircularProgressIndicator(
                  color: greenPrimary,
                )); // Loading indicator
              }

              if (controllerBerita.informationList.isEmpty) {
                return Center(child: Text("Tidak ada data"));
              }

              return ListView.builder(
                shrinkWrap: true,
                itemCount: controllerBerita.informationList.length > 5
                    ? 5
                    : controllerBerita.informationList.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final info = controllerBerita.informationList[index];
                  return InkWell(
                    onTap: () {
                      Get.toNamed(Routes.detailInformationVillage,
                          arguments: {'data': info});
                    },
                    child: informationVillage(info),
                  );
                },
              );
            }),
          ),
          bigHeight(),
        ],
      ),
    ));
  }
}
