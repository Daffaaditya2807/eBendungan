import 'package:e_surat_bendungan/presentation/views/about_village_screen.dart';
import 'package:e_surat_bendungan/presentation/views/detail_information_village_screen.dart';
import 'package:e_surat_bendungan/presentation/views/forget_password.dart';
import 'package:e_surat_bendungan/presentation/views/information_village_guest_screen.dart';
import 'package:e_surat_bendungan/presentation/views/information_village_screen.dart';
import 'package:e_surat_bendungan/presentation/views/intro_app_first.dart';
import 'package:e_surat_bendungan/presentation/views/intro_app_last.dart';
import 'package:e_surat_bendungan/presentation/views/intro_app_second.dart';
import 'package:e_surat_bendungan/presentation/views/letters/detail_catatan_kepolisian.dart';
import 'package:e_surat_bendungan/presentation/views/letters/detail_izin_usaha.dart';
import 'package:e_surat_bendungan/presentation/views/letters/detail_kehilangan.dart';
import 'package:e_surat_bendungan/presentation/views/letters/detail_kematian.dart';
import 'package:e_surat_bendungan/presentation/views/letters/detail_pembelian_solar.dart';
import 'package:e_surat_bendungan/presentation/views/letters/sk_catatan_kepolisian.dart';
import 'package:e_surat_bendungan/presentation/views/letters/sk_izin_usaha.dart';
import 'package:e_surat_bendungan/presentation/views/letters/sk_kehilangan.dart';
import 'package:e_surat_bendungan/presentation/views/letters/sk_kematian.dart';
import 'package:e_surat_bendungan/presentation/views/login_screen.dart';
import 'package:e_surat_bendungan/presentation/views/navigation_bar_screen.dart';
import 'package:e_surat_bendungan/presentation/views/otp_screen.dart';
import 'package:e_surat_bendungan/presentation/views/pengaduan/aspirasi_detail_screen.dart';
import 'package:e_surat_bendungan/presentation/views/pengaduan/aspirasi_screen.dart';
import 'package:e_surat_bendungan/presentation/views/pengaduan/history_pengaduan.dart';
import 'package:e_surat_bendungan/presentation/views/pengaduan/keluhan_detail_screen.dart';
import 'package:e_surat_bendungan/presentation/views/pengaduan/keluhan_screen.dart';
import 'package:e_surat_bendungan/presentation/views/privacy_policy_screen.dart';
import 'package:e_surat_bendungan/presentation/views/register_screen.dart';
import 'package:e_surat_bendungan/presentation/views/reset_password.dart';
import 'package:e_surat_bendungan/presentation/views/ubah_profile_screen.dart';
import 'package:e_surat_bendungan/presentation/views/ubah_sandi_screen.dart';
import 'package:e_surat_bendungan/presentation/views/verified_succes_screen.dart';
import 'package:get/get.dart';

import '../presentation/views/letters/sk_pembelian_solar_scree.dart';
import '../presentation/views/splash_screen.dart';

class Routes {
  static String splashScreen = '/splashScreen';
  static String introFirstScreen = '/introFirstScreen';
  static String introSecondScreen = '/introSecondScreen';
  static String introLastScreen = '/introLastScreen';
  static String loginScreen = '/loginScreen';
  static String registerScreen = '/registerScreen';
  static String otpScreen = '/otpScreen';
  static String verifiedAccount = '/verifiedAccountScreen';
  static String forgetPassword = '/forgetPasswordScreen';
  static String resetPassword = '/resetPasswordScreen';
  static String navBarScreen = '/navbarScreen';
  static String detailInformationVillage = '/detailInformationVillageScreen';
  static String ubahProfil = '/ubahProfil';
  static String ubahSandi = '/ubahSandi';
  static String informationVillage = '/informationVillage';
  static String informationVillageGuest = '/informationVillageGuest';
  static String aboutVillage = '/aboutVillage';
  static String privacyVillage = '/privacyVillage';

  static String skPembelianSolar = '/skPembelianSolarScreen';
  static String detailSkPembelianSolar = '/detailSkPembelianSolar';
  static String skKehilangan = '/skKehilangan';
  static String detailSkKehilangan = '/detailSkKehilangan';
  static String skKematian = '/skKematian';
  static String detailSkKematian = '/detailSkKematian';
  static String skCatatanKepolisian = '/skCatatanKepolisian';
  static String detailSkCatatanKepolisian = '/detailSkCatatanKepolisian';
  static String skIzinUsaha = '/skIzinUsaha';
  static String detailSkIzinUsaha = '/detailSkIzinUsaha';

  static String aspirasiScreen = '/aspirasiScreen';
  static String aspirasiDetailScreen = '/aspirasiDetailScreen';
  static String keluhanScreen = '/keluhanScreen';
  static String keluhanDetailScreen = '/keluhanDetailScreen';
  static String historyPengaduan = '/historypengaduan';

  static String initialRoutes = splashScreen;

  static List<GetPage> listRoutes = [
    GetPage(name: splashScreen, page: () => SplashScreen()),
    GetPage(name: introFirstScreen, page: () => IntroAppFirst()),
    GetPage(name: introLastScreen, page: () => IntroAppLast()),
    GetPage(name: loginScreen, page: () => LoginScreen()),
    GetPage(name: registerScreen, page: () => RegisterScreen()),
    GetPage(
      name: otpScreen,
      page: () => OtpScreen(),
    ),
    GetPage(
      name: verifiedAccount,
      page: () => VerifiedSuccesScreen(),
    ),
    GetPage(
      name: forgetPassword,
      page: () => ForgetPassword(),
    ),
    GetPage(
      name: resetPassword,
      page: () => ResetPassword(),
    ),
    GetPage(
      name: navBarScreen,
      page: () => NavigationBarScreen(),
    ),
    GetPage(
      name: skPembelianSolar,
      page: () => SkPembelianSolarScree(),
    ),
    GetPage(
      name: skKehilangan,
      page: () => SkKehilangan(),
    ),
    GetPage(
      name: skKematian,
      page: () => SkKematian(),
    ),
    GetPage(
      name: skCatatanKepolisian,
      page: () => SkCatatanKepolisian(),
    ),
    GetPage(
      name: skIzinUsaha,
      page: () => SkIzinUsaha(),
    ),
    GetPage(
      name: aspirasiScreen,
      page: () => AspirasiScreen(),
    ),
    GetPage(
      name: keluhanScreen,
      page: () => KeluhanScreen(),
    ),
    GetPage(
      name: detailInformationVillage,
      page: () => DetailInformationVillageScreen(),
    ),
    GetPage(
      name: detailSkCatatanKepolisian,
      page: () => DetailCatatanKepolisian(),
    ),
    GetPage(
      name: detailSkIzinUsaha,
      page: () => DetailIzinUsaha(),
    ),
    GetPage(
      name: detailSkKehilangan,
      page: () => DetailKehilangan(),
    ),
    GetPage(
      name: detailSkKematian,
      page: () => DetailKematian(),
    ),
    GetPage(
      name: detailSkPembelianSolar,
      page: () => DetailPembelianSolar(),
    ),
    GetPage(
      name: ubahProfil,
      page: () => UbahProfileScreen(),
    ),
    GetPage(
      name: ubahSandi,
      page: () => UbahSandiScreen(),
    ),
    GetPage(
      name: historyPengaduan,
      page: () => HistoryPengaduan(),
    ),
    GetPage(
      name: informationVillage,
      page: () => InformationVillageScreen(),
    ),
    GetPage(
      name: informationVillageGuest,
      page: () => InformationVillageGuestScreen(),
    ),
    GetPage(
      name: aspirasiDetailScreen,
      page: () => AspirasiDetailScreen(),
    ),
    GetPage(
      name: keluhanDetailScreen,
      page: () => KeluhanDetailScreen(),
    ),
    GetPage(
      name: aboutVillage,
      page: () => AboutVillageScreen(),
    ),
    GetPage(name: privacyVillage, page: () => PrivacyPolicyScreen()),
    GetPage(name: introSecondScreen, page: () => IntroAppSecond())
  ];
}
