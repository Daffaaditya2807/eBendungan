import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:e_surat_bendungan/config/api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:http/http.dart' as http;

class ControllerOtp extends GetxController {
  final TextEditingController controllerOtp = TextEditingController();
  final Random random = Random();
  var emailVerificationCode = 0.obs;
  var isLoading = false.obs;
  var isLoadingVerified = false.obs;
  var countdown = 60.obs;
  var isLoadingSendAgain = false.obs;
  var candSendEmail = false.obs;
  var errorMessage = ''.obs;

  int makeCodeOtp() {
    int otp = random.nextInt(9000) + 1000; // Pastikan angkanya memiliki 6 digit
    return emailVerificationCode.value =
        int.parse(otp.toString().padLeft(9, '0'));
  }

  void startTimer() {
    try {
      Timer.periodic(const Duration(seconds: 1), (Timer timer) {
        if (countdown.value == 0) {
          timer.cancel();
          candSendEmail(true);
        } else {
          countdown.value--;
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> sendEmail(
      BuildContext context, String email, String name) async {
    String username = 'antriquapps@gmail.com';
    String password = 'kgts qgce vszl umkk';

    final smtpServer = gmail(username, password);
    final message = Message()
      ..from = Address(username, 'eBendungan Apps')
      ..recipients.add(email)
      ..subject = 'KODE OTP VERIFICATION'
      ..html = emailTemplate(name, emailVerificationCode.toString());

    isLoading(true);
    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
      if (countdown.value == 0) {
        countdown.value = 60;
        candSendEmail(false);
        startTimer();
      }
    } on SocketException {
      errorMessage.value = 'periksa koneksi internet anda';
    } on MailerException catch (e) {
      print('Message not sent.');
      print(e.message);
      errorMessage.value = e.message;
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    } finally {
      isLoading(false);
    }
  }

  Future<bool> verifikasiUser({String? idUser}) async {
    isLoadingVerified(true);
    try {
      final response = await http.post(Uri.parse('${apiService}verified'),
          headers: {'Content-type': 'application/json'},
          body: jsonEncode({'id_users': idUser}));
      final responseBody = json.decode(response.body);
      int code = responseBody['meta']['code'];
      if (code == 200) {
        errorMessage.value = '';
        return true;
      } else {
        errorMessage.value = 'ada sesuatu yang error';
        return false;
      }
    } catch (e) {
      errorMessage.value = 'error : $e';

      return false;
    } finally {
      isLoadingVerified(false);
    }
  }

  String emailTemplate(String name, String kodeOtp) {
    return '''
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>OTP Verification</title>
    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: Arial, sans-serif;
        }
        .container {
            max-width: 600px;
            margin: 0 auto;
            padding: 20px;
            background-image: url('https://archisketch-resources.s3.ap-northeast-2.amazonaws.com/vrstyler/1661497957196_595865/email-template-background-banner');
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
        }
        .content {
            background-color: rgba(255, 255, 255, 0.95);
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        .header {
            font-size: 24px;
            font-weight: bold;
            color: #333;
            margin-bottom: 20px;
            text-align: center;
        }
        .otp-code {
            font-size: 32px;
            font-weight: bold;
            color: #007bff;
            text-align: center;
            margin: 20px 0;
            letter-spacing: 2px;
        }
        .footer {
            text-align: center;
            margin-top: 20px;
            color: #666;
            font-size: 14px;
        }
        .brand {
            font-weight: bold;
            color: #333;
            font-size: 18px;
            margin-top: 15px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="content">
            <div class="header">Kode OTP</div>
            <p>Hey $name,</p>
            <p>Terima kasih telah memilih eBendungan Apps. Gunakan OTP berikut untuk menyelesaikan pembuatan akun email Anda. Silakan kembali ke menu registrasi dan masukkan kode dibawah ini agar akun anda terverifikasi</p>
            <div class="otp-code">$kodeOtp</div>
            <p>Need help? Ask at <a href="mailto:ebendungan@gmail.com">ebendungan@gmail.com</a></p>
            <div class="footer">
                <div class="brand">eBendungan</div>
            </div>
        </div>
    </div>
</body>
</html>
''';
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    startTimer();
    makeCodeOtp();
    print(makeCodeOtp().toString());
  }
}
