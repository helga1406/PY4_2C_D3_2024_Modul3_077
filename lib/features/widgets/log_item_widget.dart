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
  return Card(
  child: ListTile(
    leading: const Icon(Icons.note),
    title: Text(log.title),
    subtitle: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(log.description),
        const SizedBox(height: 4),
        Text(
          log.timestamp, 
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    ),
        trailing: Wrap( 
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Color.fromARGB(255, 158, 101, 140)),
              onPressed: onEdit, 
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Color.fromARGB(255, 104, 80, 102)),
              onPressed: onDelete, 
            ),
          ],
        ),
      ),
    );
  }
}