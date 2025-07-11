import 'package:e_surat_bendungan/presentation/controller/controller_status.dart';
import 'package:e_surat_bendungan/res/colors.dart';
import 'package:e_surat_bendungan/res/fonts_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../res/margin.dart';
import '../widgets/appbar.dart';
import '../widgets/letter_list_view.dart';

class StatusLetterScreen extends StatefulWidget {
  const StatusLetterScreen({super.key});

  @override
  State<StatusLetterScreen> createState() => _StatusLetterScreenState();
}

class _StatusLetterScreenState extends State<StatusLetterScreen>
    with SingleTickerProviderStateMixin {
  final controller = Get.put(ControllerStatus());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.tabController =
        TabController(length: controller.menuTab.length, vsync: this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: headerWithTabBars(
          "Status Surat", controller.tabController, controller.menuTab),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: bodyTabBar([
          buildLetterList(),
          buildLetterListDitolak(),
          buildLetterListSelesai(),
        ], controller.tabController),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: greenPrimary,
        onPressed: controller.refreshData,
        child: Icon(
          Icons.refresh,
          size: 30,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget buildLetterList() {
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(
            child: CircularProgressIndicator(
          color: greenPrimary,
        ));
      }

      if (controller.errorMessage.isNotEmpty) {
        return Center(
            child: Text(
          "Terjadi Kesalahan Harap Mulai Ulang Aplikasi",
          style: regularFont,
        ));
      }

      if (controller.letterData.value == null) {
        return const Center(child: Text('Tidak ada data'));
      }

      return SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            mediumHeight(),
            LetterListView(responseData: controller.letterData.value!),
          ],
        ),
      );
    });
  }

  Widget buildLetterListSelesai() {
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(
            child: CircularProgressIndicator(
          color: greenPrimary,
        ));
      }

      if (controller.errorMessage.isNotEmpty) {
        return Center(
            child: Text(
          "Terjadi Kesalahan Harap Mulai Ulang Aplikasi",
          style: regularFont,
        ));
      }

      if (controller.letterDataSelesai.value == null) {
        return const Center(child: Text('Tidak ada data'));
      }

      return SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            mediumHeight(),
            LetterListView(responseData: controller.letterDataSelesai.value!),
          ],
        ),
      );
    });
  }

  Widget buildLetterListDitolak() {
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(
            child: CircularProgressIndicator(
          color: greenPrimary,
        ));
      }

      if (controller.errorMessage.isNotEmpty) {
        return Center(
            child: Text(
          "Terjadi Kesalahan Harap Mulai Ulang Aplikasi",
          style: regularFont,
        ));
      }

      if (controller.letterDataDitolak.value == null) {
        return const Center(child: Text('Tidak ada data'));
      }

      return SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            mediumHeight(),
            LetterListView(responseData: controller.letterDataDitolak.value!),
          ],
        ),
      );
    });
  }
}
