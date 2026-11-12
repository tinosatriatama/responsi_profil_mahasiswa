import 'package:flutter/material.dart';

import '../models/note.dart';
import '../models/student.dart';
import '../repositories/note_repository.dart';

/// InheritedWidget untuk membagikan state profil mahasiswa dan daftar catatan ke seluruh subtree.
class AppProvider extends InheritedWidget {
  /// Data profil mahasiswa aktif.
  final Student student;

  /// Daftar catatan kuliah yang tersimpan.
  final List<Note> notes;

  /// Status proses pemuatan data awal.
  final bool isLoading;

  /// Fungsi untuk memperbarui data profil mahasiswa.
  final void Function(Student) updateStudent;

  /// Fungsi untuk menambahkan catatan kuliah baru.
  final Future<void> Function(Note) addNote;

  /// Fungsi untuk menghapus catatan kuliah berdasarkan ID.
  final Future<void> Function(String) deleteNote;

  /// Konstruktor [AppProvider].
  const AppProvider({
    super.key,
    required this.student,
    required this.notes,
    required this.isLoading,
    required this.updateStudent,
    required this.addNote,
    required this.deleteNote,
    required super.child,
  });

  /// Mengambil instance [AppProvider] terdekat dari [BuildContext].
  static AppProvider of(BuildContext context) {
    final AppProvider? result =
        context.dependOnInheritedWidgetOfExactType<AppProvider>();
    assert(result != null, 'AppProvider tidak ditemukan dalam context.');
    return result!;
  }

  @override
  bool updateShouldNotify(AppProvider oldWidget) {
    return student != oldWidget.student ||
        notes != oldWidget.notes ||
        isLoading != oldWidget.isLoading;
  }
}

/// StatefulWidget pembungkus yang mengelola siklus hidup state dan menyediakan [AppProvider].
class AppProviderWrapper extends StatefulWidget {
  /// Widget turunan yang akan dibungkus.
  final Widget child;

  /// Konstruktor [AppProviderWrapper].
  const AppProviderWrapper({super.key, required this.child});

  @override
  State<AppProviderWrapper> createState() => _AppProviderWrapperState();
}

class _AppProviderWrapperState extends State<AppProviderWrapper> {
  final NoteRepository _repository = NoteRepository();

  Student _student = const Student(
    name: 'Tino Fanda Satria Tama',
    nim: '25.11.6581',
    programStudi: 'S1 Informatika',
    email: 't.fanda@students.amikom.ac.id',
  );

  List<Note> _notes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInitialNotes();
  }

  Future<void> _loadInitialNotes() async {
    final loadedNotes = await _repository.getAllNotes();
    if (mounted) {
      setState(() {
        _notes = loadedNotes;
        _isLoading = false;
      });
    }
  }

  void _updateStudent(Student updatedStudent) {
    setState(() {
      _student = updatedStudent;
    });
  }

  Future<void> _addNote(Note newNote) async {
    await _repository.saveNote(newNote);
    final updatedNotes = await _repository.getAllNotes();
    if (mounted) {
      setState(() {
        _notes = updatedNotes;
      });
    }
  }

  Future<void> _deleteNote(String noteId) async {
    await _repository.deleteNote(noteId);
    final updatedNotes = await _repository.getAllNotes();
    if (mounted) {
      setState(() {
        _notes = updatedNotes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppProvider(
      student: _student,
      notes: _notes,
      isLoading: _isLoading,
      updateStudent: _updateStudent,
      addNote: _addNote,
      deleteNote: _deleteNote,
      child: widget.child,
    );
  }
}