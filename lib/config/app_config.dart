import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Kelas konfigurasi aplikasi yang memuat variabel dari file .env.
class AppConfig {
  /// Memuat file .env ke dalam memori.
  static Future<void> load() async {
    await dotenv.load(fileName: ".env");
  }

  /// Mengambil BASE_URL dari environment.
  static String get baseUrl => dotenv.env['BASE_URL'] ?? 'https://jsonplaceholder.typicode.com';

  /// Mengambil API_KEY dari environment tanpa mengekspos ke log.
  static String get apiKey => dotenv.env['API_KEY'] ?? '';
}