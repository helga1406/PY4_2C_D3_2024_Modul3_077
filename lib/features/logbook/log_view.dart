import 'package:flutter/material.dart';
import 'package:logbook_app_077/features/logbook/log_controller.dart';
import 'package:logbook_app_077/features/logbook/models/log_model.dart';
import 'package:logbook_app_077/features/widgets/log_item_widget.dart';

class LogView extends StatefulWidget {
  final String username;
  const LogView({super.key, required this.username});

  @override
  State<LogView> createState() => _LogViewState();
}

class _LogViewState extends State<LogView> {
  final LogController _controller = LogController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final Color _primaryPink = const Color.fromARGB(255, 158, 101, 140);

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.redAccent : _primaryPink,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _openLogDialog({int? index, LogModel? log}) {
    final isEdit = index != null && log != null;
    if (isEdit) {
      _titleController.text = log.title;
      _contentController.text = log.description;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEdit ? "Edit Catatan" : "Tambah Catatan"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(hintText: "Judul Catatan"),
            ),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(hintText: "Isi Deskripsi"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => _closeDialog(),
            child: Text("Batal", style: TextStyle(color: _primaryPink)),
          ),
          ElevatedButton(
            onPressed: () {
              final title = _titleController.text.trim();
              final desc = _contentController.text.trim();

              // Validasi 1: Judul tidak boleh kosong
              if (title.isEmpty) {
                _showSnackBar("Judul tidak boleh kosong!", isError: true);
                return;
              }

              if (isEdit) {
                // Validasi 2: Cek apakah ada perubahan data
                if (title == log.title && desc == log.description) {
                  _showSnackBar("Tidak ada perubahan yang disimpan.");
                  _closeDialog();
                  return;
                }
                _controller.updateLog(index, title, desc);
              } else {
                _controller.addLog(title, desc);
              }

              _closeDialog();
              _showSnackBar(isEdit ? "Berhasil diperbarui!" : "Berhasil disimpan!");
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryPink,
              foregroundColor: Colors.white,
            ),
            child: Text(isEdit ? "Update" : "Simpan"),
          ),
        ],
      ),
    );
  }

  void _closeDialog() {
    _titleController.clear();
    _contentController.clear();
    Navigator.pop(context);
  }

  void _confirmAction({
    required String title,
    required String content,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Batal", style: TextStyle(color: _primaryPink)),
          ),
          ElevatedButton(
            onPressed: onConfirm,
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryPink,
              foregroundColor: Colors.white,
            ),
            child: const Text("Ya"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Logbook: ${widget.username}",
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: _primaryPink,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _confirmAction(
              title: "Konfirmasi Logout",
              content: "Apakah Anda yakin ingin keluar?",
              onConfirm: () => Navigator.of(context).pushReplacementNamed('/'),
            ),
          ),
        ],
      ),
      body: ValueListenableBuilder<List<LogModel>>(
        valueListenable: _controller.logsNotifier,
        builder: (context, currentLogs, _) {
          if (currentLogs.isEmpty) {
            return const Center(
              child: Text(
                "Belum ada catatan logbook.",
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.only(top: 10),
            itemCount: currentLogs.length,
            itemBuilder: (context, index) {
              final log = currentLogs[index];
              return LogItemWidget(
                log: log,
                onEdit: () => _openLogDialog(index: index, log: log),
                onDelete: () => _confirmAction(
                  title: "Konfirmasi Hapus",
                  content: "Hapus catatan ini?",
                  onConfirm: () {
                    _controller.removeLog(index);
                    Navigator.pop(context);
                    _showSnackBar("Catatan telah dihapus.");
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openLogDialog(),
        backgroundColor: _primaryPink,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}