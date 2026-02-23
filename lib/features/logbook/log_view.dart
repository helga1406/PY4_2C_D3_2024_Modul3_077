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

  void _showAddLogDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Tambah Catatan Baru"),
        content: Column(
          mainAxisSize: MainAxisSize.min, // Agar dialog tidak memenuhi layar
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
            onPressed: () => Navigator.pop(context), 
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () {
              
              _controller.addLog(
                _titleController.text,
                _contentController.text,
              );

              setState(() {});

              _titleController.clear();
              _contentController.clear();
              Navigator.pop(context);
            },
            child: const Text("Simpan"),
          ),
        ],
      ),
    );
  }

  void _showEditLogDialog(int index, LogModel log) {
    _titleController.text = log.title;
    _contentController.text = log.description;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Catatan"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: _titleController),
            TextField(controller: _contentController),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () {
              _controller.updateLog(
                index,
                _titleController.text,
                _contentController.text,
              );

              setState(() {});

              _titleController.clear();
              _contentController.clear();
              Navigator.pop(context);
            },
            child: const Text("Update"),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Konfirmasi Logout"),
        content: const Text("Apakah Anda yakin ingin keluar dari aplikasi?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); 
              Navigator.of(context).pushReplacementNamed('/'); 
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 158, 101, 140),
            ),
            child: const Text(
              "Keluar",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Logbook: ${widget.username}",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 158, 101, 140),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed:
                _showLogoutDialog, 
          ),
        ],
      ),
      body: ValueListenableBuilder<List<LogModel>>(
        valueListenable: _controller.logsNotifier,
        builder: (context, currentLogs, child) {
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
                onEdit: () => _showEditLogDialog(index, log),
                onDelete: () {
                  setState(() => _controller.removeLog(index));
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddLogDialog,
        backgroundColor: const Color.fromARGB(255, 158, 101, 140),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}
