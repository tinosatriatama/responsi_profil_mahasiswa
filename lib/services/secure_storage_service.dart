import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Layanan untuk menyimpan, membaca, dan menghapus isi catatan secara terenkripsi.
class SecureStorageService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static const String _prefix = 'note_content_';

  /// Menyimpan isi catatan terenkripsi dengan key `note_content_<noteId>`.
  Future<void> saveContent(String noteId, String content) async {
    await _storage.write(key: '$_prefix$noteId', value: content);
  }

  /// Membaca isi catatan terenkripsi berdasarkan [noteId].
  Future<String?> getContent(String noteId) async {
    return await _storage.read(key: '$_prefix$noteId');
  }

  /// Menghapus isi catatan terenkripsi berdasarkan [noteId].
  Future<void> deleteContent(String noteId) async {
    await _storage.delete(key: '$_prefix$noteId');
  }
}