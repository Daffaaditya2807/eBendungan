import 'package:e_surat_bendungan/presentation/controller/letters/controller_letter.dart';
import 'package:e_surat_bendungan/presentation/widgets/information.dart';
import 'package:e_surat_bendungan/presentation/widgets/text_fields.dart';
import 'package:e_surat_bendungan/res/page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../config/routes.dart';
import '../../res/colors.dart';
import '../../res/fonts_style.dart';
import '../../res/margin.dart';
import '../../res/size.dart';

// ignore: must_be_immutable
class LetterScreen extends StatelessWidget {
  LetterScreen({super.key});

  final controller = Get.put(ControllerLetter());

  @override
  Widget build(BuildContext context) {
    return bodyApp(
        child: Column(
      children: [
        bigHeight(),
        Center(
          child: Text(
            "Surat Keterangan",
            style: boldFont.copyWith(
                color: greenPrimaryDarker, fontSize: superBigFontSize),
          ),
        ),
        mediumHeight(),
        textFieldInput("", "Nama Surat", controller.searchController, context),
        Expanded(
            child: Obx(
          () => ListView.builder(
            padding: EdgeInsets.only(top: 10),
            itemCount: controller.filteredLetters.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: InkWell(
                    onTap: () {
                      int indexLetter = index;
                      switch (indexLetter) {
                        case 0:
                          Get.toNamed(Routes.skKehilangan);
                          break;
                        case 1:
                          Get.toNamed(Routes.skPembelianSolar);
                          break;
                        case 2:
                          Get.toNamed(Routes.skKematian);
                          break;
                        case 3:
                          Get.toNamed(Routes.skCatatanKepolisian);
                          break;
                        default:
                          Get.toNamed(Routes.skIzinUsaha);
                          break;
                      }
                    },
                    child: letter(
                      controller.filteredLetters[index]["name"]!,
                      controller.filteredLetters[index]["desc"]!,
                    )),
              );
            },
          ),
        )),
      ],
    ));
  }
}
