import 'package:e_surat_bendungan/config/models/keluhan_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../config/api.dart';
import '../../../res/colors.dart';
import '../../../res/fonts_style.dart';
import '../../../res/margin.dart';
import '../../../res/page.dart';
import '../../../res/size.dart';
import '../../controller/letters/controller_download.dart';
import '../../widgets/button.dart';
import '../../widgets/letter.dart';

class KeluhanDetailScreen extends StatelessWidget {
  KeluhanDetailScreen({super.key});

  final KeluhanModel data = Get.arguments['data'];
  String formatedDate(String date) {
    DateTime dateTime = DateTime.parse(date);
    return DateFormat("d MMMM yyyy", 'id').format(dateTime);
  }

  final ControllerDownload downloadController = Get.find<ControllerDownload>();

  @override
  Widget build(BuildContext context) {
    final String uniqueFileName = "Keluhan_${data.judul.replaceAll(' ', '_')}";
    return bodyApp(
        appbar: AppBar(
          centerTitle: true,
          surfaceTintColor: Colors.white,
          elevation: 0,
          backgroundColor: Colors.white,
          title: Text(
            "Detail Keluhan",
            style: boldFont.copyWith(
                color: Colors.black, fontSize: superBigFontSize),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            bigHeight(),
            dataDetailLetter("Judul", data.judul, "Tanggal",
                formatedDate(data.createdAt.toString())),
            dataDetailLetter("Kategori", data.kategori, "", ""),
            dataLongdetailLetter("Isi", data.isi),
            dataLongdetailLetter("Lokasi", data.lokasi),
            data.status == "Ditolak"
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Alasan Ditolak",
                        style: boldFont.copyWith(
                            color: greenPrimary, fontSize: superBigFontSize),
                      ),
                      Text(
                        data.fileHasil.toString(),
                        style: regularFont.copyWith(
                            fontSize: mediumFontSize, color: greyPrimary),
                      )
                    ],
                  )
                : Container(),
            data.status == "Selesai"
                ? Column(
                    children: [
                      Obx(() => downloadController.isDownloading.value
                          ? Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: LinearProgressIndicator(
                                        value:
                                            downloadController.progress.value,
                                        backgroundColor: Colors.grey[300],
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                greenPrimary),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    InkWell(
                                      onTap: () {
                                        // Cancel the download
                                        downloadController
                                            .cancelDownload(uniqueFileName);
                                      },
                                      child: Icon(
                                        Icons.close,
                                        color: greyPrimary,
                                        size: 25,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  downloadController.downloadStatus.value,
                                  style: regularFont.copyWith(
                                    color: greenPrimary,
                                    fontSize: regularFontSize,
                                  ),
                                ),
                                const SizedBox(height: 16),
                              ],
                            )
                          : const SizedBox()),
                      Obx(() => downloadController.isDownloading.value
                          ? Container()
                          : buttonPrimary("Unduh Surat", () {
                              // Assuming data.fileUrl contains the download URL for the letter
                              if (!downloadController.isDownloading.value) {
                                // final urlDownload =
                                //     "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf";
                                final urlDownload =
                                    "${accesFile}File Keluhan/${data.fileHasil.toString()}";
                                print("LINK $urlDownload");
                                downloadController.downloadSurat(
                                    urlDownload, uniqueFileName);
                              } else {
                                Get.snackbar(
                                  'Unduhan Sedang Berlangsung',
                                  'Harap tunggu hingga unduhan selesai',
                                  snackPosition: SnackPosition.BOTTOM,
                                );
                              }
                            }, icon: Icons.download)),
                    ],
                  )
                : Container()
          ],
        ));
  }
}
