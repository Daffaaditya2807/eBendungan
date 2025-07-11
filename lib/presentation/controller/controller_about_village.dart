import 'package:carousel_slider/carousel_slider.dart';
import 'package:e_surat_bendungan/presentation/widgets/carousel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ControllerAboutVillage extends GetxController {
  RxInt currentIndex = 0.obs;
  final CarouselSliderController controllerCarousel =
      CarouselSliderController();

  void getIndex(int current) {
    currentIndex.value = current;
  }

  List<Widget> listWidget(BuildContext context) =>
      List.generate(pathsImage.length, (int index) {
        final listImages = pathsImage[index];
        if (listImages.isNotEmpty) {
          return containerBanner2(context, listImages);
        } else {
          return Container();
        }
      });

  List<String> pathsImage = [
    'assets/images_banner/desa1.jpg',
    'assets/images_banner/desa2.jpg',
    'assets/images_banner/desa3.jpg',
    'assets/images_banner/desa4.jpg',
    'assets/images_banner/desa5.jpg'
  ].obs;
}
