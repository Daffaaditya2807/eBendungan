import 'package:e_surat_bendungan/config/models/izin_pembelian_solar_model.dart';
import 'package:e_surat_bendungan/config/models/izin_usaha_model.dart';
import 'package:e_surat_bendungan/config/models/keterangan_kehilangan_model.dart';
import 'package:e_surat_bendungan/config/models/keterangan_kematian_model.dart';
import 'package:e_surat_bendungan/config/models/skck_model.dart';
import 'package:e_surat_bendungan/presentation/widgets/letter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../../config/models/letter_info.dart';
import '../../config/routes.dart';
import '../../res/colors.dart';
import '../../res/fonts_style.dart';
import '../../res/margin.dart';
import '../../res/size.dart';

class LetterListView extends StatelessWidget {
  final Map<String, dynamic> responseData;

  const LetterListView({Key? key, required this.responseData})
      : super(key: key);

  bool _isAllLettersEmpty(Map<String, dynamic> data) {
    return data['izin_usaha'].isEmpty &&
        data['izin_pembelian_solar'].isEmpty &&
        data['keterangan_kehilangan'].isEmpty &&
        data['keteranganKematian'].isEmpty &&
        data['skck'].isEmpty;
  }

  // Create a class to store letter info for sorting

  @override
  Widget build(BuildContext context) {
    final data = responseData['data']['data'];

    if (_isAllLettersEmpty(data)) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset('assets/image/emptylist.json',
                width: 150, height: 150),
            smallHeight(),
            Text(
              'Tidak ada surat',
              style: regularFont.copyWith(
                color: greyPrimary,
                fontSize: mediumFontSize,
              ),
            ),
          ],
        ),
      );
    }

    // Create a list to hold all letters
    List<LetterInfo> allLetters = [];

    // Add Izin Usaha letters
    if (data['izin_usaha'].isNotEmpty) {
      for (var json in data['izin_usaha']) {
        final izinUsaha = IzinUsahaModel.fromJson(json);
        allLetters.add(
          LetterInfo(
            title: 'Izin Usaha - ${izinUsaha.nama}',
            createdAt: DateTime.parse(izinUsaha.createdAt),
            letterWidget: InkWell(
              onTap: () {
                Get.toNamed(Routes.detailSkIzinUsaha,
                    arguments: {'data': izinUsaha});
              },
              child: listLetter(
                'Izin Usaha - ${izinUsaha.nama}',
                DateFormat('dd/MM/yyyy')
                    .format(DateTime.parse(izinUsaha.createdAt)),
              ),
            ),
          ),
        );
      }
    }

    // Add Izin Pembelian Solar letters
    if (data['izin_pembelian_solar'].isNotEmpty) {
      for (var json in data['izin_pembelian_solar']) {
        final izinSolar = IzinPembelianSolarModel.fromJson(json);
        allLetters.add(
          LetterInfo(
            title: 'Izin Pembelian Solar - ${izinSolar.nama}',
            createdAt: DateTime.parse(izinSolar.createdAt),
            letterWidget: InkWell(
              onTap: () {
                Get.toNamed(Routes.detailSkPembelianSolar,
                    arguments: {'data': izinSolar});
              },
              child: listLetter(
                'Izin Pembelian Solar - ${izinSolar.nama}',
                DateFormat('dd/MM/yyyy')
                    .format(DateTime.parse(izinSolar.createdAt)),
              ),
            ),
          ),
        );
      }
    }

    // Add Keterangan Kehilangan letters
    if (data['keterangan_kehilangan'].isNotEmpty) {
      for (var json in data['keterangan_kehilangan']) {
        final kehilangan = KeteranganKehilanganModel.fromJson(json);
        allLetters.add(
          LetterInfo(
            title: 'Surat Keterangan Kehilangan - ${kehilangan.nama}',
            createdAt: DateTime.parse(kehilangan.createdAt),
            letterWidget: InkWell(
              onTap: () {
                Get.toNamed(Routes.detailSkKehilangan,
                    arguments: {'data': kehilangan});
              },
              child: listLetter(
                'Surat Keterangan Kehilangan - ${kehilangan.nama}',
                DateFormat('dd/MM/yyyy')
                    .format(DateTime.parse(kehilangan.createdAt)),
              ),
            ),
          ),
        );
      }
    }

    // Add Keterangan Kematian letters
    if (data['keteranganKematian'].isNotEmpty) {
      for (var json in data['keteranganKematian']) {
        final kematian = KeteranganKematianModel.fromJson(json);
        allLetters.add(
          LetterInfo(
            title: 'Surat Keterangan Kematian - ${kematian.nama}',
            createdAt: DateTime.parse(kematian.createdAt),
            letterWidget: InkWell(
              onTap: () {
                Get.toNamed(Routes.detailSkKematian,
                    arguments: {'data': kematian});
              },
              child: listLetter(
                'Surat Keterangan Kematian - ${kematian.nama}',
                DateFormat('dd/MM/yyyy')
                    .format(DateTime.parse(kematian.createdAt)),
              ),
            ),
          ),
        );
      }
    }

    // Add SKCK letters
    if (data['skck'].isNotEmpty) {
      for (var json in data['skck']) {
        final skck = SkckModel.fromJson(json);
        allLetters.add(
          LetterInfo(
            title: 'SKCK - ${skck.nama}',
            createdAt: DateTime.parse(skck.createdAt),
            letterWidget: InkWell(
              onTap: () {
                Get.toNamed(Routes.detailSkCatatanKepolisian,
                    arguments: {'data': skck});
              },
              child: listLetter(
                'SKCK - ${skck.nama}',
                DateFormat('dd/MM/yyyy').format(DateTime.parse(skck.createdAt)),
              ),
            ),
          ),
        );
      }
    }

    // Sort all letters by date (newest first)
    allLetters.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    // Return sorted widgets
    return Column(
      children: allLetters.map((letter) => letter.letterWidget).toList(),
    );
  }
}
