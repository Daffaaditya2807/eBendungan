// Fungsi untuk mengekstrak data KTP dari teks
import 'package:intl/intl.dart';

Map<String, String?> extractKtpData(String text) {
  String? tempatLahir;
  String? tanggalLahir;

  // Normalisasi teks: ubah ke huruf kecil dan hapus spasi berlebih
  final normalizedText = text.toLowerCase().replaceAll(RegExp(r'\s+'), ' ');

  // Regex untuk Tanggal Lahir (format: DD-MM-YYYY atau DD/MM/YYYY)
  final datePattern = RegExp(r'\b(\d{1,2}[-/]\d{1,2}[-/]\d{4})\b');
  final dateMatch = datePattern.firstMatch(normalizedText);
  if (dateMatch != null) {
    tanggalLahir =
        dateMatch.group(1)?.replaceAll('-', '/'); // Format ke DD/MM/YYYY
  }
  // Regex untuk Tempat Lahir (diperbarui untuk menangani berbagai format)
  // Pola 1: "tempat/tgl lahir : JAKARTA, 12-12-1990" atau "TTL : JAKARTA 12/12/1990"
  final birthPlacePattern = RegExp(
      r'(?:tempat/tgl\s+lahir|ttl)\s*[:\-]?\s*([a-z\s\-\.]+?)(?:,|\s+\d{1,2}[-/]\d{1,2}[-/]\d{4}\b)');
  final birthPlaceMatch = birthPlacePattern.firstMatch(normalizedText);
  if (birthPlaceMatch != null) {
    tempatLahir = birthPlaceMatch.group(1)?.trim();
  } else {
    // Pola 2: Tanpa label, teks sebelum tanggal (misalnya, "JAKARTA 12-12-1990")
    final altBirthPlacePattern =
        RegExp(r'\b([a-z\s\-\.]+?)\s*(?:,|\s+)\d{1,2}[-/]\d{1,2}[-/]\d{4}\b');
    final altMatch = altBirthPlacePattern.firstMatch(normalizedText);
    if (altMatch != null) {
      tempatLahir = altMatch.group(1)?.trim();
    }
  }

  // Bersihkan dan validasi Tempat Lahir
  if (tempatLahir != null) {
    // Hapus karakter yang tidak relevan (misalnya, tanda baca berlebih)
    tempatLahir = tempatLahir.replaceAll(RegExp(r'[^\w\s]'), '');
    // Pastikan hanya huruf dan spasi, hindari teks yang tidak valid
    tempatLahir = tempatLahir.trim().toUpperCase();
    if (!RegExp(r'^[A-Z\s]+$').hasMatch(tempatLahir) ||
        tempatLahir.length < 2) {
      tempatLahir = null; // Reset jika tidak valid
    }
  }

  return {
    'tempat_lahir': tempatLahir,
    'tanggal_lahir': tanggalLahir,
  };
}

String convertDateFormat(String inputDate) {
  // Parse string ke DateTime
  DateTime date = DateFormat('dd/MM/yyyy').parse(inputDate);
  // Format ke 'yyyy-MM-dd'
  return DateFormat('yyyy-MM-dd').format(date);
}
