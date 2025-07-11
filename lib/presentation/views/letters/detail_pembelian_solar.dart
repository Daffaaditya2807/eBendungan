import 'package:e_surat_bendungan/config/api.dart';
import 'package:e_surat_bendungan/config/models/izin_pembelian_solar_model.dart';
import 'package:e_surat_bendungan/presentation/controller/letters/controller_download.dart';
import 'package:e_surat_bendungan/presentation/widgets/information.dart';
import 'package:e_surat_bendungan/presentation/widgets/letter.dart';
import 'package:e_surat_bendungan/res/colors.dart';
import 'package:e_surat_bendungan/res/fonts_style.dart';
import 'package:e_surat_bendungan/res/margin.dart';
import 'package:e_surat_bendungan/res/page.dart';
import 'package:e_surat_bendungan/res/size.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/button.dart';

class DetailPembelianSolar extends StatelessWidget {
  DetailPembelianSolar({super.key});

  final IzinPembelianSolarModel data = Get.arguments['data'];
  final ControllerDownload downloadController = Get.find<ControllerDownload>();

  @override
  Widget build(BuildContext context) {
    final String uniqueFileName =
        "Surat_Izin_Pembelian_Solar_${data.nama.replaceAll(' ', '_')}";
    return WillPopScope(
      onWillPop: () async {
        if (downloadController.isDownloading.value) {
          Get.snackbar(
            'Unduhan Berlanjut',
            'Unduhan akan dilanjutkan di latar belakang',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 2),
          );
        }
        return true;
      },
      child: bodyApp(
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
              dataDetailLetter("Nama", data.nama, "NIK", data.nik),
              dataDetailLetter("Tempat Lahir", data.tempatLahir,
                  "Tanggal Lahir", data.tanggalLahir),
              dataLongdetailLetter("Alamat", data.alamat),
              data.status == "Ditolak"
                  ? dataLongdetailLetter(
                      "Alasan Ditolak", data.fileHasil.toString())
                  : Container(),
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
                                      "${accesFile}File SK Pembelian Solar/${data.fileHasil.toString()}";
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
          )),
    );
  }
}
