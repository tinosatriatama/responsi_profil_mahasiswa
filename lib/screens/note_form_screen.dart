import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/note.dart';
import '../providers/app_provider.dart';
import '../utils/validators.dart';

/// Layar form untuk menambahkan catatan kuliah baru dengan validasi dan sanitasi input.
class NoteFormScreen extends StatefulWidget {
  /// Konstruktor [NoteFormScreen].
  const NoteFormScreen({super.key});

  @override
  State<NoteFormScreen> createState() => _NoteFormScreenState();
}

class _NoteFormScreenState extends State<NoteFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  bool _isSaving = false;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final sanitizedTitle = Validators.sanitize(_titleController.text);
    final sanitizedContent = Validators.sanitize(_contentController.text);
    final formattedDate = DateFormat('dd MMM yyyy, HH:mm').format(DateTime.now());

    final newNote = Note(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: sanitizedTitle,
      date: formattedDate,
      content: sanitizedContent,
    );

    await AppProvider.of(context).addNote(newNote);

    if (mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Catatan Kuliah'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Judul Catatan',
                  hintText: 'Contoh: Pertemuan 6 - Secure Storage',
                  border: OutlineInputBorder(),
                ),
                validator: Validators.validateTitle,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _contentController,
                maxLines: 6,
                decoration: const InputDecoration(
                  labelText: 'Isi Catatan',
                  hintText: 'Tulis ringkasan materi kuliah di sini (min. 10 karakter)...',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                ),
                validator: Validators.validateContent,
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _isSaving ? null : _submitForm,
                icon: _isSaving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save),
                label: Text(_isSaving ? 'Menyimpan...' : 'Simpan Catatan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}