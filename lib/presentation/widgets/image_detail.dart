import 'package:e_surat_bendungan/res/colors.dart';
import 'package:e_surat_bendungan/res/fonts_style.dart';
import 'package:e_surat_bendungan/res/size.dart';
import 'package:flutter/material.dart';

Widget imageDetail(String asset, String header, String desc) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Image.asset(asset),
      Text(
        header,
        textAlign: TextAlign.center,
        style:
            boldFont.copyWith(fontSize: superBigFontSize, color: greenPrimary),
      ),
      Text(
        desc,
        textAlign: TextAlign.center,
        style: regularFont.copyWith(
          fontSize: mediumFontSize,
          color: greyPrimary,
        ),
      )
    ],
  );
}
