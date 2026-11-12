/// Model data yang merepresentasikan catatan kuliah.
class Note {
  /// Pengenal unik catatan (misalnya timestamp).
  final String id;

  /// Judul catatan kuliah.
  final String title;

  /// Tanggal pembuatan catatan dalam format string.
  final String date;

  /// Isi lengkap catatan (opsional karena disimpan terpisah di SecureStorage).
  final String? content;

  /// Konstruktor untuk membuat objek [Note].
  const Note({
    required this.id,
    required this.title,
    required this.date,
    this.content,
  });

  /// Mengonversi metadata catatan ([id], [title], [date]) menjadi Map JSON
  /// untuk disimpan di SharedPreferences tanpa menyertakan [content].
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'date': date,
    };
  }

  /// Membuat objek [Note] dari Map JSON yang dibaca dari SharedPreferences.
  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'] as String,
      title: json['title'] as String,
      date: json['date'] as String,
    );
  }

  /// Membuat salinan objek [Note], berguna saat menggabungkan metadata dengan [content] dari SecureStorage.
  Note copyWith({
    String? id,
    String? title,
    String? date,
    String? content,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      content: content ?? this.content,
    );
  }
}