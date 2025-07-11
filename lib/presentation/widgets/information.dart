import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_surat_bendungan/config/api.dart';
import 'package:e_surat_bendungan/res/colors.dart';
import 'package:e_surat_bendungan/res/fonts_style.dart';
import 'package:e_surat_bendungan/res/margin.dart';
import 'package:e_surat_bendungan/res/padding.dart';
import 'package:e_surat_bendungan/res/rounded.dart';
import 'package:e_surat_bendungan/res/size.dart';
import 'package:flutter/material.dart';

import '../../config/models/information_model.dart';

Widget prosesLetter(
    String nameLetter, String dateLatter, String status, BuildContext context) {
  return Container(
    width: MediaQuery.of(context).size.width - 40, // Fixed width untuk cards
    margin: EdgeInsets.only(right: 20),
    decoration: BoxDecoration(
        gradient: LinearGradient(colors: [greenPrimary, greenPrimaryDarker]),
        borderRadius: borderRoundedMedium),
    child: Padding(
      padding: allBigPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Surat Keterangan",
                style: boldFont.copyWith(
                    fontSize: bigFontSize, color: Colors.white),
              ),
              Text(
                dateLatter,
                style: regularFont.copyWith(
                    fontSize: mediumFontSize, color: Colors.white),
              )
            ],
          ),
          Text(
            nameLetter,
            style: regularFont.copyWith(
                fontSize: mediumFontSize, color: Colors.white),
          ),
          bigHeight(),
          Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: borderRoundedSmall),
            child: Padding(
              padding: allSmallPadding,
              child: Text(
                "   $status   ",
                style: semiBoldFont.copyWith(color: greenPrimary),
              ),
            ),
          )
        ],
      ),
    ),
  );
}

Widget prosesLetterEmpty() {
  return Container(
    width: double.infinity,
    decoration: BoxDecoration(
        border: Border.all(color: greyPrimary),
        borderRadius: borderRoundedMedium),
    child: Padding(
      padding: allMediumPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Tidak ada Surat Yang Diproses",
            textAlign: TextAlign.center,
            style:
                boldFont.copyWith(fontSize: mediumFontSize, color: greyPrimary),
          ),
          Text(
            "Silakan mengajukan surat jika ada yang diperlukan",
            textAlign: TextAlign.center,
            style: regularFont.copyWith(
                fontSize: smallFontSize, color: greyPrimary),
          ),
          mediumHeight(),
          Image.asset(
            "assets/image/emptylist.png",
            height: 50,
            width: 50,
          ),
        ],
      ),
    ),
  );
}

Widget letter(String nameLetter, String desc) {
  return Container(
    width: double.infinity,
    decoration: BoxDecoration(
        gradient: LinearGradient(colors: [greenPrimary, greenPrimaryDarker]),
        borderRadius: borderRoundedMedium),
    child: Padding(
      padding: allBigPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            nameLetter,
            style:
                boldFont.copyWith(fontSize: bigFontSize, color: Colors.white),
          ),
          Text(
            desc,
            style: regularFont.copyWith(
                fontSize: mediumFontSize, color: Colors.white),
          ),
          bigHeight(),
          Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: borderRoundedSmall),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              child: Text(
                "Buat",
                style: semiBoldFont.copyWith(color: greenPrimary),
              ),
            ),
          )
        ],
      ),
    ),
  );
}

Widget informationVillage(InformationModel info) {
  return Container(
    width: 200,
    margin: EdgeInsets.only(right: 20),
    decoration: BoxDecoration(
      color: Colors.grey.shade100.withOpacity(0.5),
      border: Border.all(color: greyPrimary),
      borderRadius: roundedMediumGeo,
    ),
    child: Padding(
      padding: allMediumPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: ClipRRect(
              borderRadius: roundedMediumGeo,
              child: CachedNetworkImage(
                imageUrl: "$accesImage${info.urlGambar.toString()}",
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
          smallHeight(),
          Text(
            info.judul, // Menampilkan judul berita
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style:
                boldFont.copyWith(color: Colors.black, fontSize: bigFontSize),
          ),
          smallHeight(),
          Text(
            info.isi, // Menampilkan isi berita

            style: regularFont.copyWith(
                color: greyPrimary, fontSize: mediumFontSize),
            maxLines: 2,
            textAlign: TextAlign.justify,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    ),
  );
}

Widget informationVillageDetail(InformationModel info) {
  return Container(
    width: 200,
    // margin: EdgeInsets.only(right: 20),
    decoration: BoxDecoration(
      color: Colors.grey.shade100.withOpacity(0.5),
      border: Border.all(color: greyPrimary),
      borderRadius: roundedMediumGeo,
    ),
    child: Padding(
      padding: allMediumPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: ClipRRect(
              borderRadius: roundedMediumGeo,
              child: CachedNetworkImage(
                imageUrl: "$accesImage${info.urlGambar.toString()}",
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
          smallHeight(),
          Text(
            info.judul,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style:
                boldFont.copyWith(color: Colors.black, fontSize: bigFontSize),
          ),
          smallHeight(),
          Text(
            info.isi,
            style: regularFont.copyWith(
                color: greyPrimary, fontSize: mediumFontSize),
            maxLines: 2,
            textAlign: TextAlign.justify,
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    ),
  );
}

Widget statusLetter(String status) {
  Color? bg;
  Color? border;
  Color? font;
  switch (status) {
    case 'Diajukan':
      bg = Colors.lightBlueAccent.shade200;
      border = Colors.blueAccent;
      font = Colors.white;
    case 'Diproses':
      bg = Colors.amberAccent.shade200;
      border = Colors.amberAccent;
      font = Colors.white;
    case 'Ditolak':
      bg = Color(0xfff6d5da);
      border = Color(0xffc13d60);
      font = Color(0xffc13d60);
    case 'Selesai':
      bg = Color(0xffa4f6ce);
      border = greenPrimary;
      font = greenPrimaryDarker;
  }
  return Container(
      decoration: BoxDecoration(
          color: bg,
          border: Border.all(color: border!),
          borderRadius: borderRoundedMedium),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
        child: Text(
          status,
          style: semiBoldFont.copyWith(color: font, fontSize: mediumFontSize),
        ),
      ));
}
