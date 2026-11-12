import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../config/app_config.dart';
import '../models/note.dart';
import '../services/secure_storage_service.dart';

/// Repository yang mengelola penyimpanan catatan lokal dan pengambilan data API publik.
class NoteRepository {
  static const String _notesKey = 'notes_metadata';
  final SecureStorageService _secureStorage;

  /// Konstruktor [NoteRepository] dengan injeksi [SecureStorageService].
  NoteRepository({SecureStorageService? secureStorage})
      : _secureStorage = secureStorage ?? SecureStorageService();

  /// Memuat seluruh catatan beserta isi terenkripsinya dari penyimpanan lokal.
  Future<List<Note>> getAllNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_notesKey);

    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }

    final List decodedList = jsonDecode(jsonString) as List;
    final List<Note> notes = [];

    for (final item in decodedList) {
      final metadata = Note.fromJson(item as Map<String, dynamic>);
      final encryptedContent = await _secureStorage.getContent(metadata.id);
      notes.add(metadata.copyWith(content: encryptedContent ?? ''));
    }

    debugPrint('[NoteRepository] Berhasil memuat ${notes.length} catatan.');
    return notes;
  }

  /// Menyimpan catatan baru: metadata ke SharedPreferences dan isi ke SecureStorage.
  Future<void> saveNote(Note note) async {
    final prefs = await SharedPreferences.getInstance();
    final currentNotes = await getAllNotes();

    currentNotes.insert(0, note);
    final encodedList = jsonEncode(currentNotes.map((n) => n.toJson()).toList());

    await prefs.setString(_notesKey, encodedList);
    await _secureStorage.saveContent(note.id, note.content ?? '');

    debugPrint('[NoteRepository] Catatan baru tersimpan (ID: ${note.id}).');
  }

  /// Menghapus catatan berdasarkan [noteId] dari SharedPreferences dan SecureStorage.
  Future<void> deleteNote(String noteId) async {
    final prefs = await SharedPreferences.getInstance();
    final currentNotes = await getAllNotes();

    currentNotes.removeWhere((note) => note.id == noteId);
    final encodedList = jsonEncode(currentNotes.map((n) => n.toJson()).toList());

    await prefs.setString(_notesKey, encodedList);
    await _secureStorage.deleteContent(noteId);

    debugPrint('[NoteRepository] Catatan dihapus (ID: $noteId).');
  }

  /// Mengambil daftar referensi artikel/post dari API publik menggunakan konfigurasi .env.
  Future<List> fetchPublicPosts() async {
    final uri = Uri.parse('${AppConfig.baseUrl}/posts?_limit=5');

    try {
      debugPrint('[NoteRepository] Mengambil data dari endpoint: /posts');
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          if (AppConfig.apiKey.isNotEmpty) 'X-API-Key': AppConfig.apiKey,
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body) as List;
        debugPrint('[NoteRepository] Berhasil mengambil ${data.length} item API.');
        return data;
      } else {
        throw HttpException('Server mengembalikan status ${response.statusCode}');
      }
    } on SocketException {
      debugPrint('[NoteRepository] Gagal koneksi jaringan (SocketException).');
      throw Exception('Tidak ada koneksi internet. Periksa jaringan Anda.');
    } on TimeoutException {
      debugPrint('[NoteRepository] Request timeout setelah 10 detik.');
      throw Exception('Koneksi waktu habis (Timeout). Coba lagi nanti.');
    } catch (e) {
      debugPrint('[NoteRepository] Terjadi kesalahan saat mengambil data API.');
      throw Exception('Gagal memuat data referensi: $e');
    }
  }
}