import 'package:e_surat_bendungan/config/fcm_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'config/internet_service.dart';
import 'config/routes.dart';
import 'presentation/controller/controller_shared_prefs.dart';
import 'presentation/controller/letters/controller_download.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  await initializeDateFormatting('id');
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  // Inisiasi service internet terlebih dahulu
  await Get.putAsync(() => InternetService().init(), permanent: true);

  try {
    // Inisialisasi Firebase dengan timeout
    await Firebase.initializeApp().timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        print("Firebase initialization timed out, continuing app startup");
        throw Exception("Firebase timeout");
      },
    );
  } catch (e) {
    print(
        "Firebase initialization failed: $e. App will continue without Firebase.");
    // Aplikasi akan tetap berjalan meskipun Firebase gagal diinisialisasi
  }
  Get.put(ControllerSharedPrefs(), permanent: true);
  FcmService fcmService = FcmService();
  await fcmService.init();
  Get.put(ControllerDownload(), permanent: true);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'E Desa Bendungan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      initialRoute: Routes.initialRoutes,
      getPages: Routes.listRoutes,
    );
  }
}
