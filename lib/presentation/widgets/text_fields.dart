import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:e_surat_bendungan/res/colors.dart';
import 'package:e_surat_bendungan/res/fonts_style.dart';
import 'package:e_surat_bendungan/res/margin.dart';
import 'package:e_surat_bendungan/res/padding.dart';
import 'package:e_surat_bendungan/res/rounded.dart';
import 'package:e_surat_bendungan/res/size.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget textFieldInput(String label, String hintext,
    TextEditingController controller, BuildContext context,
    {TextInputType? typeInput,
    String? counter,
    bool? readOnly,
    VoidCallback? function,
    String? requiredText,
    List<TextInputFormatter>? formatter,
    Function(String value)? onSubmit,
    int? lenght}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            label,
            style: regularFont.copyWith(
                color: greyPrimary, fontSize: mediumFontSize),
          ),
          Text(
            requiredText ?? "",
            style: regularFont.copyWith(
                color: redPrimary, fontSize: mediumFontSize),
          )
        ],
      ),
      mediumHeight(),
      Theme(
        data: Theme.of(context).copyWith(
            textSelectionTheme:
                TextSelectionThemeData(selectionColor: greenPrimaryLighter)),
        child: TextField(
          style: regularFont.copyWith(
              color: Colors.black, fontSize: mediumFontSize),
          controller: controller,
          cursorColor: greyPrimary,
          cursorWidth: 1.5,
          readOnly: readOnly ?? false,
          onTap: function,
          maxLength: lenght,
          onSubmitted: onSubmit,
          inputFormatters: formatter,
          keyboardType: typeInput,
          decoration: InputDecoration(
              hintText: hintext,
              counterText: counter,
              filled: true,
              fillColor: Color.fromARGB(255, 248, 248, 248),
              hintStyle: regularFont.copyWith(color: greyPrimary),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xffD0D5DD), width: 1.0),
                borderRadius: borderRoundedMedium,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xffD0D5DD), width: 1.0),
                borderRadius: borderRoundedMedium,
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: greenPrimary, width: 1.0),
                borderRadius: borderRoundedMedium,
              )),
        ),
      ),
      bigHeight()
    ],
  );
}

Widget dropDownTextField(
    String label,
    String hintext,
    List<DropdownMenuItem<String>>? items,
    Function(String?)? newValue,
    BuildContext context,
    {String? counter,
    VoidCallback? function,
    String? requiredText,
    String? value,
    List<TextInputFormatter>? formatter}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            label,
            style: regularFont.copyWith(
                color: greyPrimary, fontSize: mediumFontSize),
          ),
          Text(
            requiredText ?? "",
            style: regularFont.copyWith(
                color: redPrimary, fontSize: mediumFontSize),
          )
        ],
      ),
      mediumHeight(),
      Theme(
        data: Theme.of(context).copyWith(
            textSelectionTheme:
                TextSelectionThemeData(selectionColor: greenPrimaryLighter)),
        child: DropdownButtonFormField<String>(
          value: value,
          onChanged: newValue,
          items: items,
          borderRadius: borderRoundedMedium,
          dropdownColor: Colors.white,
          style: regularFont.copyWith(
              color: Colors.black, fontSize: mediumFontSize),
          onTap: function,
          decoration: InputDecoration(
              hintText: hintext,
              counterText: counter,
              filled: true,
              fillColor: Color.fromARGB(255, 248, 248, 248),
              hintStyle: regularFont.copyWith(color: greyPrimary),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xffD0D5DD), width: 1.0),
                borderRadius: borderRoundedMedium,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xffD0D5DD), width: 1.0),
                borderRadius: borderRoundedMedium,
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: greenPrimary, width: 1.0),
                borderRadius: borderRoundedMedium,
              )),
        ),
      ),
      bigHeight()
    ],
  );
}

Widget textFieldPassword(
    String label,
    String hintext,
    bool isShow,
    TextEditingController controller,
    BuildContext context,
    IconData showHide,
    VoidCallback funcion,
    {TextInputType? typeInput,
    Function(String value)? onSubmit,
    String? requiredText,
    List<TextInputFormatter>? formatter}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            label,
            style: regularFont.copyWith(
                color: greyPrimary, fontSize: mediumFontSize),
          ),
          Text(
            requiredText ?? "",
            style: regularFont.copyWith(
                color: redPrimary, fontSize: mediumFontSize),
          )
        ],
      ),
      mediumHeight(),
      Theme(
        data: Theme.of(context).copyWith(
            textSelectionTheme:
                TextSelectionThemeData(selectionColor: greenPrimaryLighter)),
        child: TextField(
          style: regularFont.copyWith(
              color: Colors.black, fontSize: mediumFontSize),
          controller: controller,
          cursorColor: greyPrimary,
          cursorWidth: 1.5,
          obscureText: isShow,
          inputFormatters: formatter,
          keyboardType: typeInput,
          onSubmitted: onSubmit,
          decoration: InputDecoration(
              hintText: hintext,
              filled: true,
              fillColor: Color.fromARGB(255, 248, 248, 248),
              hintStyle: regularFont.copyWith(color: greyPrimary),
              suffixIcon: IconButton(
                  onPressed: funcion,
                  icon: Icon(
                    showHide,
                    color: greyPrimary,
                  )),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xffD0D5DD), width: 1.0),
                borderRadius: borderRoundedMedium,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xffD0D5DD), width: 1.0),
                borderRadius: borderRoundedMedium,
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: greenPrimary, width: 1.0),
                borderRadius: borderRoundedMedium,
              )),
        ),
      ),
      bigHeight()
    ],
  );
}

Widget uploadDocument({String? label, String? requiredText}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            label ?? 'Unggah Foto Ktp',
            style: regularFont.copyWith(
                color: greyPrimary, fontSize: mediumFontSize),
          ),
          Text(
            requiredText ?? "",
            style: regularFont.copyWith(
                color: redPrimary, fontSize: mediumFontSize),
          )
        ],
      ),
      mediumHeight(),
      DottedBorder(
        color: greyPrimary,
        padding: allSmallPadding,
        dashPattern: [7, 5],
        borderType: BorderType.RRect,
        strokeWidth: 1.0,
        radius: Radius.circular(3),
        strokeCap: StrokeCap.round,
        child: Container(
            width: double.infinity,
            decoration:
                BoxDecoration(color: Color.fromARGB(255, 248, 248, 248)),
            child: Padding(
              padding: allMediumPadding,
              child: Column(
                children: [
                  Icon(
                    Icons.upload_file_outlined,
                    color: greyPrimary,
                  ),
                  mediumHeight(),
                  Text(
                    "Pilih File Dari Folder Handphone",
                    style: regularFont.copyWith(
                        color: greyPrimary, fontSize: bigFontSize),
                  ),
                  mediumHeight(),
                  Text(
                    "Ukuran Maximal: 2Mb",
                    style: regularFont.copyWith(
                        color: greyPrimary, fontSize: mediumFontSize),
                  )
                ],
              ),
            )),
      )
    ],
  );
}

Widget containesDocument(File image, {String? label, String? requiredText}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            label ?? 'Unggah Foto Ktp',
            style: regularFont.copyWith(
                color: greyPrimary, fontSize: mediumFontSize),
          ),
          Text(
            requiredText ?? "",
            style: regularFont.copyWith(
                color: redPrimary, fontSize: mediumFontSize),
          )
        ],
      ),
      mediumHeight(),
      DottedBorder(
        color: greyPrimary,
        padding: allSmallPadding,
        dashPattern: [7, 5],
        borderType: BorderType.RRect,
        strokeWidth: 1.0,
        radius: Radius.circular(3),
        strokeCap: StrokeCap.round,
        child: Container(
            width: double.infinity,
            decoration:
                BoxDecoration(color: Color.fromARGB(255, 248, 248, 248)),
            child: Padding(
                padding: allMediumPadding,
                child: ClipRRect(
                  borderRadius: roundedMediumGeo,
                  child: Image.file(
                    image,
                    fit: BoxFit.cover,
                  ),
                ))),
      )
    ],
  );
}
