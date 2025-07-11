import 'package:e_surat_bendungan/config/models/keterangan_kematian_model.dart';
import 'package:e_surat_bendungan/presentation/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../config/api.dart';
import '../../../res/colors.dart';
import '../../../res/fonts_style.dart';
import '../../../res/margin.dart';
import '../../../res/page.dart';
import '../../../res/size.dart';
import '../../controller/letters/controller_download.dart';
import '../../widgets/information.dart';
import '../../widgets/letter.dart';

class DetailKematian extends StatelessWidget {
  DetailKematian({super.key});

  final KeteranganKematianModel data = Get.arguments['data'];
  final ControllerDownload downloadController = Get.find<ControllerDownload>();

  @override
  Widget build(BuildContext context) {
    final String uniqueFileName =
        "Surat_Keterangan_Kematian_${data.nama.replaceAll(' ', '_')}";
    return bodyApp(
        appbar: AppBar(
          centerTitle: true,
          surfaceTintColor: Colors.white,
          elevation: 0,
          backgroundColor: Colors.white,
          title: Text(
            "Detail Surat",
            style: boldFont.copyWith(
                color: Colors.black, fontSize: superBigFontSize),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 5.0),
              child: statusLetter(data.status),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            mediumHeight(),
            Text(
              "Identitas",
              style: boldFont.copyWith(
                  color: greenPrimary, fontSize: superBigFontSize),
            ),
            bigHeight(),
            dataDetailLetter("Nama", data.nama, "Usia", data.usia.toString()),
            dataLongdetailLetter("Jenis Kelamin", data.jenisKelamin),
            dataLongdetailLetter("Alamat Terakhir", data.alamatTerakhir),
            mediumHeight(),
            Text(
              "Surat dan Dokumen",
              style: boldFont.copyWith(
                  color: greenPrimary, fontSize: superBigFontSize),
            ),
            bigHeight(),
            dataDetailLetter(
                "Hari", data.hari, "Tanggal Kematian", data.tanggalKematian),
            dataDetailLetter("Bertempat", data.bertempat, "Penyebab Kematian",
                data.disebabkan),
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
                                final urlDownload =
                                    "${accesFile}File SK Kematian/${data.fileHasil.toString()}";
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
