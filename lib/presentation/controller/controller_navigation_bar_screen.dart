import 'package:e_surat_bendungan/presentation/views/dashboard_screen.dart';
import 'package:e_surat_bendungan/presentation/views/letter_screen.dart';
import 'package:e_surat_bendungan/presentation/views/profile_screen.dart';
import 'package:e_surat_bendungan/presentation/views/status_letter_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

import '../../res/colors.dart';

class ControllerNavigationBarScreen extends GetxController {
  PersistentTabController? tabController;
  List<Widget> buildScreens() {
    return [
      DashboardScreen(),
      LetterScreen(),
      StatusLetterScreen(),
      ProfileScreen()
    ];
  }

  List<PersistentBottomNavBarItem> navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.dashboard),
        title: ("Home"),
        activeColorPrimary: greenPrimary,
        inactiveColorPrimary: greyPrimary,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.my_library_books_outlined),
        title: ("Layanan"),
        activeColorPrimary: greenPrimary,
        inactiveColorPrimary: greyPrimary,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.history),
        title: ("Layanan"),
        activeColorPrimary: greenPrimary,
        inactiveColorPrimary: greyPrimary,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.profile_circled),
        title: ("Settings"),
        activeColorPrimary: greenPrimary,
        inactiveColorPrimary: greyPrimary,
      ),
    ];
  }

  @override
  void onInit() {
    super.onInit();
    tabController = PersistentTabController(initialIndex: 0);
  }
}
