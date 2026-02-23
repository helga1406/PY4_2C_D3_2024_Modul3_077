import 'package:flutter/material.dart';
import 'package:logbook_app_077/features/logbook/models/log_model.dart';

class LogItemWidget extends StatelessWidget {
  final LogModel log;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const LogItemWidget({
    super.key,
    required this.log,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    // Widget ini hanya mengembalikan Card, bukan Scaffold atau App lengkap [cite: 49, 122]
    return Card(
      child: ListTile(
        leading: const Icon(Icons.note), // Ikon catatan [cite: 105]
        title: Text(log.title), // Menampilkan judul dari model [cite: 105]
        subtitle: Text(log.description), // Menampilkan deskripsi dari model [cite: 105]
        trailing: Wrap( // Langkah 5: Menggunakan Wrap untuk tombol aksi [cite: 121, 122]
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: onEdit, // Memicu fungsi edit yang dikirim dari parent [cite: 122]
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete, // Memicu fungsi hapus yang dikirim dari parent [cite: 122]
            ),
          ],
        ),
      ),
    );
  }
}