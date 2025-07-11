// FCMService.dart (modifikasi)
import 'dart:convert';
import 'package:e_surat_bendungan/config/api.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../presentation/controller/controller_shared_prefs.dart';
import 'internet_service.dart';



class FcmService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final sharedPrefsController =
      Get.put(ControllerSharedPrefs(), permanent: true);

  Future<void> init() async {
    try {
      // Setup notifikasi lokal terlebih dahulu (tidak memerlukan internet)
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      const InitializationSettings initializationSettings =
          InitializationSettings(android: initializationSettingsAndroid);

      await _flutterLocalNotificationsPlugin.initialize(initializationSettings);

      // Load user data dari penyimpanan lokal
      await sharedPrefsController.loadUser();

      // Coba setup Firebase dengan timeout
      bool firebaseSetupSuccess = await _setupFirebaseWithTimeout();

      if (!firebaseSetupSuccess) {
        print(
            "FCM setup skipped due to connection issues. Will retry when online.");
      }

      // Siapkan listener koneksi untuk mencoba kembali saat online
      final internetService = Get.find<InternetService>();
      ever(internetService.isConnected, (connected) {
        if (connected) {
          _retryFcmSetup();
        }
      });
    } catch (e) {
      print("Error initializing FCM service: $e");
      // Aplikasi tetap berjalan meskipun FCM gagal diinisialisasi
    }
  }

  Future<bool> _setupFirebaseWithTimeout() async {
    try {
      return await Future.delayed(const Duration(seconds: 5), () async {
        final internetService = Get.find<InternetService>();
        if (!await internetService.checkConnection()) {
          return false;
        }

        await _firebaseMessaging.requestPermission();
        String? token = await _firebaseMessaging.getToken();
        if (token != null) {
          print("TOKEN USER = $token");

          // Cek apakah pengguna sudah login
          if (sharedPrefsController.isLoggedIn.value) {
            // Jika sudah login, cek apakah token perlu dikirim
            await _handleTokenForLoggedInUser(token);
          } else {
            // Jika belum login, simpan token tanpa id_akun
            // await sendTokenToServer(token);
          }
        }

        // Setup listeners
        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
          showNotification(message);
        });

        FirebaseMessaging.onBackgroundMessage(
            _firebaseMessagingBackgroundHandler);
        return true;
      }).timeout(const Duration(seconds: 10), onTimeout: () {
        print("Firebase setup timed out");
        return false;
      });
    } catch (e) {
      print("Error in Firebase setup: $e");
      return false;
    }
  }

  Future<void> _retryFcmSetup() async {
    try {
      print("Internet connection restored, retrying FCM setup");
      await _setupFirebaseWithTimeout();
    } catch (e) {
      print("Error retrying FCM setup: $e");
    }
  }

  Future<void> _handleTokenForLoggedInUser(String token) async {
    try {
      // Ambil token yang tersimpan
      final String? storedToken = await sharedPrefsController.getStoredToken();
      final int? idAkun = sharedPrefsController.user.value?.idUser;

      if (idAkun == null) {
        print("No id_akun found, skipping token handling");
        return;
      }

      // Jika token berubah atau belum ada, kirim ke server
      if (storedToken == null || storedToken != token) {
        print("Token changed or not stored, sending to server");
        await sendTokenToServer(token);
        // Simpan token baru ke shared preferences
        await sharedPrefsController.saveToken(token);
      } else {
        print("Token already exists, no need to send to server");
      }
    } catch (e) {
      print("Error handling token for logged-in user: $e");
    }
  }

  Future<void> sendTokenToServer(String token) async {
    try {
      final internetService = Get.find<InternetService>();
      if (!await internetService.checkConnection()) {
        print("No internet connection, skipping token server update");
        return;
      }

      // Jika user sudah login, ambil id_akun
      final idAkun = sharedPrefsController.user.value?.idUser;
      print("akun : $idAkun");

      Map<String, dynamic> body = {'token': token};

      // Tambahkan id_akun ke body jika tersedia
      if (idAkun != null) {
        body['id_akun'] = idAkun;
        print("Tersedia akun : $idAkun");
      }

      final response = await http
          .post(Uri.parse("${apiService}devicetoken"),
              headers: {'Content-type': 'application/json'},
              body: jsonEncode(body))
          .timeout(const Duration(seconds: 10));

      final responseBody = json.decode(response.body);
      print(responseBody.toString());
    } catch (e) {
      print("gagal update token: $e");
    }
  }

  Future<void> deleteTokenFromServer(String token) async {
    try {
      final internetService = Get.find<InternetService>();
      if (!await internetService.checkConnection()) {
        print("No internet connection, skipping token deletion");
        return;
      }

      final response = await http
          .post(
            Uri.parse("${apiService}delete-device-token"),
            headers: {'Content-type': 'application/json'},
            body: jsonEncode({'token': token}),
          )
          .timeout(const Duration(seconds: 10));

      final responseBody = json.decode(response.body);
      print("Delete token response: $responseBody");

      // Hapus token dari shared preferences setelah berhasil dihapus dari server
      await sharedPrefsController.clearToken();
    } catch (e) {
      print("Failed to delete token: $e");
    }
  }

  Future<void> showNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      await _flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notifications',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
      );
    }
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling background message: ${message.messageId}');
}
