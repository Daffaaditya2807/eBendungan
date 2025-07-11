import 'package:e_surat_bendungan/res/colors.dart';
import 'package:e_surat_bendungan/res/size.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

TextStyle regularFont = TextStyle(fontFamily: 'plusJakartaSans');
TextStyle semiBoldFont = TextStyle(fontFamily: 'plusJakartaSemiBold');
TextStyle boldFont =
    TextStyle(fontFamily: 'plusJakartaSans', fontWeight: FontWeight.bold);

Widget componenRichTextStyle(
    String firstText, String lastText, VoidCallback function) {
  return RichText(
    text: TextSpan(
        text: firstText,
        style:
            regularFont.copyWith(fontSize: mediumFontSize, color: greyPrimary),
        children: <TextSpan>[
          TextSpan(
              text: lastText,
              style: semiBoldFont.copyWith(
                  fontSize: mediumFontSize, color: greenPrimary),
              recognizer: TapGestureRecognizer()..onTap = function)
        ]),
  );
}

Widget componenRichBoldTextStyle(
    String firstText, String lastText, VoidCallback function) {
  return RichText(
    text: TextSpan(
        text: firstText,
        style: boldFont.copyWith(fontSize: bigFontSize, color: redPrimary),
        children: <TextSpan>[
          TextSpan(
              text: lastText,
              style:
                  boldFont.copyWith(fontSize: bigFontSize, color: greenPrimary),
              recognizer: TapGestureRecognizer()..onTap = function)
        ]),
  );
}
