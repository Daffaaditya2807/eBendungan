import 'package:e_surat_bendungan/presentation/controller/controller_about_village.dart';
import 'package:e_surat_bendungan/presentation/widgets/carousel.dart';
import 'package:e_surat_bendungan/res/page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../res/colors.dart';
import '../../res/fonts_style.dart';
import '../../res/margin.dart';
import '../../res/size.dart';

class AboutVillageScreen extends StatelessWidget {
  AboutVillageScreen({super.key});

  final controller = Get.put(ControllerAboutVillage());

  @override
  Widget build(BuildContext context) {
    double heightAppBar = MediaQuery.of(context).viewPadding.top;
    double heightScreen = MediaQuery.sizeOf(context).height;
    double heightContainer =
        (heightScreen - kToolbarHeight - heightAppBar) * 0.25;
    return bodyApp(
        appbar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          title: Text(
            "Desa Bendungan",
            style: boldFont.copyWith(
                color: greenPrimary, fontSize: superBigFontSize),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              mediumHeight(),
              Obx(() => controller.listWidget(context).isEmpty
                  ? Container()
                  : carouselSlider(
                      controller.controllerCarousel,
                      heightContainer,
                      (index, reason) => controller.getIndex(index),
                      controller.listWidget(context))),
              Obx(() => controller.listWidget(context).isEmpty
                  ? Container()
                  : indicatorCarousel(
                      controller.currentIndex.value,
                      controller.listWidget(context),
                      controller.controllerCarousel)),
              bigHeight(),
              ExpansionTile(
                tilePadding: EdgeInsets.all(0),
                title: Text(
                  "Desa Bendungan",
                  style: boldFont.copyWith(color: greenPrimary),
                ),
                subtitle: Text(
                  "Ringkasan Desa",
                  style: regularFont,
                ),
                shape: RoundedRectangleBorder(
                  side: BorderSide.none,
                ),
                collapsedShape: RoundedRectangleBorder(
                  side: BorderSide.none,
                ),
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Desa Bendungan adalah desa yang terdiri dari dua dusun yaitu Bendungan dan Kepatihan. Desa Bendungan mayoritas warganya adalah petani dengan tiap tahunnya menghasilkan padi dan tembakau.",
                        style: regularFont,
                        textAlign: TextAlign.justify,
                      )
                    ],
                  )
                ],
              ),
              ExpansionTile(
                tilePadding: EdgeInsets.all(0),
                title: Text(
                  "Lokasi Desa",
                  style: boldFont.copyWith(color: greenPrimary),
                ),
                subtitle: Text(
                  "Detail Lokasi Desa",
                  style: regularFont,
                ),
                shape: RoundedRectangleBorder(
                  side: BorderSide.none,
                ),
                collapsedShape: RoundedRectangleBorder(
                  side: BorderSide.none,
                ),
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Desa Bendungan terletak pada Kecamatan Kudu Kabupaten Jombang, yaitu utara dari sungai brantas.",
                        style: regularFont,
                        textAlign: TextAlign.justify,
                      )
                    ],
                  )
                ],
              ),
              // ExpansionTile(
              //   tilePadding: EdgeInsets.all(0),
              //   title: Text(
              //     "Strukktur Organisasi Desa",
              //     style: boldFont.copyWith(color: greenPrimary),
              //   ),
              //   subtitle: Text(
              //     "Kepala Desa & Pemerintahan Desa",
              //     style: regularFont,
              //   ),
              //   shape: RoundedRectangleBorder(
              //     side: BorderSide.none,
              //   ),
              //   collapsedShape: RoundedRectangleBorder(
              //     side: BorderSide.none,
              //   ),
              //   children: [
              //     Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         Text(
              //           "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse ac sapien tortor. Nam auctor dictum nunc, a vulputate felis commodo quis. Proin nec ultricies orci. Integer vestibulum a nunc ac eleifend. Maecenas mi est, consequat at magna ut, tristique convallis eros. Aliquam dapibus congue neque. Mauris pulvinar felis nec ullamcorper dignissim. Maecenas in sem erat. Mauris et diam consequat, suscipit tortor sed, maximus ipsum. Sed vitae tortor nisl.",
              //           style: regularFont,
              //           textAlign: TextAlign.justify,
              //         )
              //       ],
              //     )
              //   ],
              // )
            ],
          ),
        ));
  }
}
