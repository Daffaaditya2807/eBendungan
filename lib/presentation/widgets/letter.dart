import 'package:e_surat_bendungan/presentation/widgets/information.dart';
import 'package:e_surat_bendungan/res/colors.dart';
import 'package:e_surat_bendungan/res/fonts_style.dart';
import 'package:e_surat_bendungan/res/margin.dart';
import 'package:e_surat_bendungan/res/padding.dart';
import 'package:e_surat_bendungan/res/rounded.dart';
import 'package:e_surat_bendungan/res/size.dart';
import 'package:flutter/material.dart';

Widget listLetter(String nameLetter, String dateLetter) {
  return Column(
    children: [
      ListTile(
        contentPadding: EdgeInsets.all(0),
        leading: Container(
          decoration: BoxDecoration(
              color: greenPrimary, borderRadius: borderRoundedMedium),
          child: Padding(
            padding: allBigPadding,
            child: Icon(
              Icons.my_library_books_rounded,
              color: Colors.white,
            ),
          ),
        ),
        title: Text(
          "Surat Keterangan",
          style: semiBoldFont.copyWith(fontSize: bigFontSize),
        ),
        subtitle: Text(
          nameLetter,
          style: regularFont.copyWith(
              color: greyPrimary, fontSize: mediumFontSize),
        ),
        trailing: Text(
          dateLetter,
          style: regularFont.copyWith(
              color: greyPrimary, fontSize: mediumFontSize),
        ),
      ),
      Divider()
    ],
  );
}

Widget listLetterPengaduan(String judul, String isi, String dateLetter) {
  return Column(
    children: [
      ListTile(
          contentPadding: EdgeInsets.all(0),
          leading: Container(
            decoration: BoxDecoration(
                color: greenPrimary, borderRadius: borderRoundedMedium),
            child: Padding(
              padding: allBigPadding,
              child: Icon(
                Icons.light_mode_rounded,
                color: Colors.white,
              ),
            ),
          ),
          title: Text(
            judul,
            style: semiBoldFont.copyWith(fontSize: bigFontSize),
          ),
          subtitle: Text(
            isi,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: regularFont.copyWith(
                color: greyPrimary, fontSize: mediumFontSize),
          ),
          trailing: statusLetter(dateLetter)),
      Divider()
    ],
  );
}

Widget dataDetailLetter(
    String header1, String data1, String header2, String data2) {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment
            .spaceBetween, // This will space out the columns evenly
        children: [
          Expanded(
            // Add Expanded to make the first column take up available space
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  header1,
                  style: boldFont.copyWith(color: Colors.black),
                ),
                const SizedBox(height: 4), // Add small vertical spacing
                Text(
                  data1,
                  style: regularFont.copyWith(color: greyPrimary),
                )
              ],
            ),
          ),
          Expanded(
            // Add Expanded to make the second column take up available space
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  header2,
                  style: boldFont.copyWith(color: Colors.black),
                ),
                const SizedBox(height: 4), // Add small vertical spacing
                Text(
                  data2,
                  style: regularFont.copyWith(color: greyPrimary),
                )
              ],
            ),
          )
        ],
      ),
      const SizedBox(height: 8), // Add spacing before divider
      const Divider(color: Colors.grey), // Add color to make divider visible
      mediumHeight()
    ],
  );
}

Widget dataLongdetailLetter(String header, String data) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            header,
            style: boldFont.copyWith(color: Colors.black),
          ),
          const SizedBox(height: 4), // Add small vertical spacing
          Text(
            data,
            style: regularFont.copyWith(color: greyPrimary),
          )
        ],
      ),
      const SizedBox(height: 8), // Add spacing before divider
      const Divider(color: Colors.grey), // Add color to make divider visible
      mediumHeight()
    ],
  );
}
