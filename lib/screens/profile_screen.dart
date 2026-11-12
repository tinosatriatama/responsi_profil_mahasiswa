import 'package:flutter/material.dart';

import '../providers/app_provider.dart';
import '../widgets/profile_card.dart';

/// Layar untuk menampilkan dan mengedit data profil mahasiswa.
class ProfileScreen extends StatelessWidget {
  /// Konstruktor [ProfileScreen].
  const ProfileScreen({super.key});

  void _showEditDialog(BuildContext context) {
    final provider = AppProvider.of(context);
    final student = provider.student;

    final nameController = TextEditingController(text: student.name);
    final nimController = TextEditingController(text: student.nim);
    final prodiController = TextEditingController(text: student.programStudi);
    final emailController = TextEditingController(text: student.email);
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Edit Profil Mahasiswa'),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Nama Lengkap'),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Nama wajib diisi' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: nimController,
                    decoration: const InputDecoration(labelText: 'NIM'),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'NIM wajib diisi' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: prodiController,
                    decoration: const InputDecoration(labelText: 'Program Studi'),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Prodi wajib diisi' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: (v) =>
                        (v == null || !v.contains('@')) ? 'Email tidak valid' : null,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  provider.updateStudent(
                    student.copyWith(
                      name: nameController.text.trim(),
                      nim: nimController.text.trim(),
                      programStudi: prodiController.text.trim(),
                      email: emailController.text.trim(),
                    ),
                  );
                  Navigator.pop(dialogContext);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Profil berhasil diperbarui')),
                  );
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final student = AppProvider.of(context).student;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Mahasiswa'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, true),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ProfileCard(student: student),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => _showEditDialog(context),
                icon: const Icon(Icons.edit),
                label: const Text('Edit Profil'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}