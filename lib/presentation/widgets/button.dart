import 'package:e_surat_bendungan/res/colors.dart';
import 'package:e_surat_bendungan/res/fonts_style.dart';
import 'package:e_surat_bendungan/res/margin.dart';
import 'package:e_surat_bendungan/res/padding.dart';
import 'package:e_surat_bendungan/res/rounded.dart';
import 'package:e_surat_bendungan/res/size.dart';
import 'package:flutter/material.dart';

ElevatedButton buttonPrimary(String nameButton, VoidCallback function,
    {IconData? icon}) {
  return ElevatedButton(
    onPressed: function,
    style: ElevatedButton.styleFrom(
        minimumSize: Size.fromHeight(50),
        elevation: 0.0,
        backgroundColor: greenPrimary,
        shape: RoundedRectangleBorder(borderRadius: borderRoundedMedium)),
    child: icon != null
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Colors.white,
              ),
              smallwidth(),
              Text(
                nameButton,
                style: semiBoldFont.copyWith(color: Colors.white),
              ),
            ],
          )
        : Text(
            nameButton,
            style: semiBoldFont.copyWith(color: Colors.white),
          ),
  );
}

ElevatedButton buttonPengaduan(
    String nameButton, VoidCallback function, Color color, IconData icon) {
  return ElevatedButton(
      onPressed: function,
      style: ElevatedButton.styleFrom(
          elevation: 0.0,
          backgroundColor: color,
          shape: RoundedRectangleBorder(borderRadius: borderRoundedMedium)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: Colors.white,
          ),
          smallwidth(),
          Text(
            nameButton,
            style: semiBoldFont.copyWith(color: Colors.white),
          ),
        ],
      ));
}

Widget buttonMenu(IconData icon, String nameButton, VoidCallback function) {
  return InkWell(
    onTap: function,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
              color: redPrimaryLighter, borderRadius: borderRoundedMedium),
          child: Padding(
            padding: allMediumPadding,
            child: Icon(
              icon,
              size: 25,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(
          width: 80,
          child: Text(
            nameButton,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: regularFont.copyWith(
              color: greyPrimary,
            ),
          ),
        )
      ],
    ),
  );
}

Widget buttonSetting(String menuSetting, VoidCallback function, IconData icon) {
  return InkWell(
    onTap: function,
    child: Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: Color(0xfff6f6f6), borderRadius: borderRoundedMedium),
      child: Padding(
        padding: allBigPadding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                ),
                mediumwidth(),
                Text(
                  menuSetting,
                  style: regularFont.copyWith(fontSize: mediumFontSize),
                )
              ],
            ),
            Icon(
              Icons.chevron_right,
            )
          ],
        ),
      ),
    ),
  );
}
