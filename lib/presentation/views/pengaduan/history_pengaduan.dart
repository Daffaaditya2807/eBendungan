import 'package:e_surat_bendungan/config/routes.dart';
import 'package:e_surat_bendungan/presentation/controller/pengaduan/controller_history_pengaduan.dart';
import 'package:e_surat_bendungan/presentation/widgets/appbar.dart';
import 'package:e_surat_bendungan/presentation/widgets/letter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../res/colors.dart';
import '../../../res/fonts_style.dart';
import '../../../res/size.dart';

class HistoryPengaduan extends StatefulWidget {
  const HistoryPengaduan({super.key});

  @override
  State<HistoryPengaduan> createState() => _HistoryPengaduanState();
}

class _HistoryPengaduanState extends State<HistoryPengaduan>
    with SingleTickerProviderStateMixin {
  final controller = Get.put(ControllerHistoryPengaduan());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.tabController =
        TabController(length: controller.menuTab.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: headerWithTabBars(
          "Riwayat Pengaduan", controller.tabController, controller.menuTab),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: bodyTabBar([
          Obx(() {
            if (controller.isLoadingAspirasi.value) {
              return Center(
                child: CircularProgressIndicator(
                  color: greenPrimary,
                ),
              );
            }

            if (controller.aspirasiList.isEmpty) {
              return Center(
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset('assets/image/emptylist.json',
                        width: 150, height: 150),
                    Text(
                      'Tidak ada daftar aspirasi',
                      style: regularFont.copyWith(
                        color: greyPrimary,
                        fontSize: mediumFontSize,
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              itemCount: controller.aspirasiList.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final aspirasii = controller.aspirasiList[index];
                return InkWell(
                    onTap: () {
                      Get.toNamed(Routes.aspirasiDetailScreen,
                          arguments: {'data': aspirasii});
                    },
                    child: listLetterPengaduan(aspirasii.judul, aspirasii.isi,
                        aspirasii.status.toString()));
              },
            );
          }),
          Obx(() {
            if (controller.isLoadingKeluhan.value) {
              return Center(
                child: CircularProgressIndicator(
                  color: greenPrimary,
                ),
              );
            }

            if (controller.keluhanList.isEmpty) {
              return Center(
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset('assets/image/emptylist.json',
                        width: 150, height: 150),
                    Text(
                      'Tidak ada daftar keluhan',
                      style: regularFont.copyWith(
                        color: greyPrimary,
                        fontSize: mediumFontSize,
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              itemCount: controller.keluhanList.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final keluhan = controller.keluhanList[index];
                return InkWell(
                  onTap: () {
                    Get.toNamed(Routes.keluhanDetailScreen,
                        arguments: {'data': keluhan});
                  },
                  child: listLetterPengaduan(
                      keluhan.judul, keluhan.isi, keluhan.status.toString()),
                );
              },
            );
          })
        ], controller.tabController),
      ),
    );
  }
}
