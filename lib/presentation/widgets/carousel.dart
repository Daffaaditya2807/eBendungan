import 'package:carousel_slider/carousel_slider.dart';
import 'package:e_surat_bendungan/res/colors.dart';
import 'package:e_surat_bendungan/res/padding.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

CarouselSlider carouselSlider(
    CarouselSliderController controller,
    double heightContainer,
    Function(int, CarouselPageChangedReason) pageChaned,
    List<Widget> items) {
  return CarouselSlider(
    carouselController: controller,
    options: CarouselOptions(
      height: heightContainer,
      autoPlay: true,
      enlargeCenterPage: false,
      aspectRatio: 16 / 9,
      autoPlayInterval: const Duration(seconds: 3),
      autoPlayAnimationDuration: const Duration(milliseconds: 800),
      autoPlayCurve: Curves.fastOutSlowIn,
      pauseAutoPlayOnTouch: true,
      viewportFraction: 1.0,
      initialPage: 0,
      pageSnapping: true,
      enableInfiniteScroll: items.length == 1 ? false : true,
      onPageChanged: pageChaned,
    ),
    items: items.map((item) => item).toList(),
  );
}

Widget indicatorCarousel(
    int current, List<Widget> items, CarouselSliderController controller) {
  return items.isNotEmpty
      ? AnimatedSmoothIndicator(
          activeIndex: current,
          count: items.length,
          effect: JumpingDotEffect(
              verticalOffset: 10,
              dotColor: greyPrimary,
              dotHeight: 10,
              dotWidth: 10,
              activeDotColor: greenPrimary),
          onDotClicked: (index) {
            controller.animateToPage(index);
          },
        )
      : const SizedBox.shrink();
}

Widget containerBanner2(BuildContext context, String imageUrl) {
  double heightAppBar = MediaQuery.of(context).viewPadding.top;
  double heightScreen = MediaQuery.sizeOf(context).height;
  double heightContainer =
      (heightScreen - kToolbarHeight - heightAppBar) * 0.25;
  return Builder(
    builder: (BuildContext context) {
      return Padding(
        padding: mediumVerticalPadding,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: heightContainer,
          margin: sidePagePadding,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 3,
                blurRadius: 7,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              imageUrl,
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    },
  );
}
