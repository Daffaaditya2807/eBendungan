import 'package:e_surat_bendungan/res/colors.dart';
import 'package:e_surat_bendungan/res/fonts_style.dart';
import 'package:e_surat_bendungan/res/size.dart';
import 'package:flutter/material.dart';

AppBar headerWithTabBars(
  String label,
  TabController controller,
  List<Tab> menuTabBar,
) {
  return AppBar(
    title: Text(
      label,
      style: boldFont.copyWith(
          color: greenPrimaryDarker, fontSize: superBigFontSize),
    ),
    centerTitle: true,
    elevation: 0,
    bottom: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: TabBar(
            controller: controller,
            labelStyle: boldFont.copyWith(
                color: greenPrimary, fontSize: regularFontSize),
            labelColor: greenPrimary,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorWeight: 3,
            unselectedLabelColor: greyPrimary,
            indicatorColor: redPrimaryLighter,
            tabs: menuTabBar)),
    backgroundColor: Colors.white,
    surfaceTintColor: Colors.white,
  );
}

Widget bodyTabBar(List<Widget> widgets, TabController controller) {
  return DefaultTabController(
      length: widgets.length,
      child: Column(
        children: [
          Expanded(child: TabBarView(controller: controller, children: widgets))
        ],
      ));
}
