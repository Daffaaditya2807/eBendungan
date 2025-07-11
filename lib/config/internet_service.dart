// InternetService.dart
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class InternetService extends GetxService {
  final isConnected = false.obs;
  late StreamSubscription<List<ConnectivityResult>> _subscription;

  Future<InternetService> init() async {
    // Periksa koneksi awal
    var connectivityResult = await Connectivity().checkConnectivity();
    isConnected.value = connectivityResult.isNotEmpty &&
        !connectivityResult.contains(ConnectivityResult.none);

    // Pantau perubahan konektivitas
    _subscription = Connectivity().onConnectivityChanged.listen((results) {
      // Anggap terhubung jika setidaknya ada satu koneksi yang aktif
      isConnected.value =
          results.isNotEmpty && !results.contains(ConnectivityResult.none);
    });

    return this;
  }

  Future<bool> checkConnection() async {
    var connectivityResults = await Connectivity().checkConnectivity();
    return connectivityResults.isNotEmpty &&
        !connectivityResults.contains(ConnectivityResult.none);
  }

  @override
  void onClose() {
    _subscription.cancel();
    super.onClose();
  }
}
