import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_surat_bendungan/config/models/information_model.dart';
import 'package:e_surat_bendungan/res/colors.dart';
import 'package:e_surat_bendungan/res/fonts_style.dart';
import 'package:e_surat_bendungan/res/margin.dart';
import 'package:e_surat_bendungan/res/page.dart';
import 'package:e_surat_bendungan/res/rounded.dart';
import 'package:e_surat_bendungan/res/size.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../config/api.dart';

class DetailInformationVillageScreen extends StatelessWidget {
  DetailInformationVillageScreen({super.key});
  final InformationModel data = Get.arguments['data'];

  @override
  Widget build(BuildContext context) {
    return bodyApp(
        appbar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          title: Text(
            "Berita",
            style: boldFont.copyWith(
                color: greenPrimary, fontSize: superBigFontSize),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              mediumHeight(),
              SizedBox(
                width: double.infinity,
                height: 200,
                child: ClipRRect(
                  borderRadius: roundedMediumGeo,
                  child: CachedNetworkImage(
                    imageUrl: "$accesImage${data.urlGambar.toString()}",
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey.shade200,
                      child: Icon(
                        Icons.info_rounded,
                        color: greyPrimary,
                      ),
                    ),
                  ),
                ),
              ),
              bigHeight(),
              Text(data.judul,
                  style: boldFont.copyWith(
                      color: greenPrimary, fontSize: bigFontSize)),
              smallHeight(),
              Text("${formatedDate(date: data.tanggal)} - ${data.kategori}",
                  style: regularFont.copyWith(
                      color: greyPrimary, fontSize: mediumFontSize)),
              bigHeight(),
              Text(
                data.isi,
                style: regularFont.copyWith(
                    color: greyPrimary, fontSize: mediumFontSize),
                textAlign: TextAlign.justify,
              )
            ],
          ),
        ));
  }

  String formatedDate({String? date}) {
    DateTime dateTime = DateTime.parse(date!);
    String formattedDate = DateFormat("d MMMM yyyy", 'id').format(dateTime);
    return formattedDate;
  }
}
