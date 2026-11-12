import 'package:flutter/material.dart';

/// Widget tampilan kosong ketika belum ada catatan kuliah yang tersimpan.
class EmptyState extends StatelessWidget {
  /// Pesan informasi yang ditampilkan kepada pengguna.
  final String message;

  /// Konstruktor [EmptyState].
  const EmptyState({
    super.key,
    this.message = 'Belum ada catatan kuliah.\nTekan tombol + untuk menambahkan.',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.note_alt_outlined,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}