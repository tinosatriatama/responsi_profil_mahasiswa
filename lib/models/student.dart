/// Model data yang merepresentasikan profil mahasiswa.
class Student {
  /// Nama lengkap mahasiswa.
  final String name;

  /// Nomor Induk Mahasiswa (NIM).
  final String nim;

  /// Nama program studi mahasiswa.
  final String programStudi;

  /// Alamat email institusi atau pribadi mahasiswa.
  final String email;

  /// Konstruktor untuk membuat objek [Student].
  const Student({
    required this.name,
    required this.nim,
    required this.programStudi,
    required this.email,
  });

  /// Membuat salinan objek [Student] dengan memperbarui field tertentu.
  Student copyWith({
    String? name,
    String? nim,
    String? programStudi,
    String? email,
  }) {
    return Student(
      name: name ?? this.name,
      nim: nim ?? this.nim,
      programStudi: programStudi ?? this.programStudi,
      email: email ?? this.email,
    );
  }
}